/// ⚠️ NO SUBIR ESTE ARCHIVO CON VALORES REALES A GITHUB
/// Agregar al .gitignore
class AWSConfig {
  // ═══════════════════════════════════════════════════════════
  // CONFIGURACIÓN AWS IVS
  // ═══════════════════════════════════════════════════════════

  /// Región de AWS donde está configurado tu canal IVS
  /// Ejemplos: 'us-east-1', 'us-west-2', 'eu-west-1'
  static const String region = 'us-east-1';

  /// ARN del canal IVS
  static const String channelArn =
      'arn:aws:ivs:us-east-1:113090259489:channel/OIMcwh8yaLQw';

  /// URL para reproducir el stream (HLS)
  static const String playbackUrl =
      'https://d29f9326cfc6.us-east-1.playback.live-video.net/api/video/v1/us-east-1.113090259489.channel.OIMcwh8yaLQw.m3u8';

  /// Endpoint RTMP donde se envía el stream
  static const String ingestEndpoint =
      'rtmps://d29f9326cfc6.global-contribute.live-video.net:443/app/';

  /// ⚠️ STREAM KEY - MANTENER SECRETO
  /// Este valor DEBE venir de tu backend en producción
  /// NUNCA hardcodearlo en la app en producción
  /// Para testing inicial, está aquí temporalmente
  static const String streamKey =
      'sk_us-east-1_PSHu2JfIfnQL_XeuuaX2Qx9a3qcWNxvf69RYkndYUvu';
  // CONFIGURACIÓN DE BACKEND
  // ═══════════════════════════════════════════════════════════

  /// URL de tu backend/Cloud Functions para operaciones AWS
  /// En producción, las operaciones AWS deben hacerse desde el backend
  /// por seguridad (no exponer credenciales en la app)
  static const String backendUrl =
      'PENDING'; // TODO: URL de tus Cloud Functions

  // ═══════════════════════════════════════════════════════════
  // CONFIGURACIÓN DE CALIDAD DE STREAMING
  // ═══════════════════════════════════════════════════════════

  /// Calidad de video para streaming
  static const Map<String, dynamic> videoQuality = {
    'width': 1280,
    'height': 720,
    'bitrate': 2500000, // 2.5 Mbps
    'fps': 30,
  };

  /// Calidad de audio
  static const Map<String, dynamic> audioQuality = {
    'bitrate': 128000, // 128 kbps
    'sampleRate': 44100,
  };

  // ═══════════════════════════════════════════════════════════
  // VALIDACIÓN
  // ═══════════════════════════════════════════════════════════

  /// Verificar si la configuración está completa
  static bool isConfigured() {
    return region != 'PENDING' &&
        channelArn != 'PENDING' &&
        playbackUrl != 'PENDING' &&
        ingestEndpoint != 'PENDING' &&
        streamKey != 'PENDING';
  }

  /// Obtener mensaje de error si falta configuración
  static String? getConfigError() {
    if (!isConfigured()) {
      return '''
⚠️ AWS IVS no está configurado correctamente.

Faltan los siguientes valores:
${region == 'PENDING' ? '- AWS Region\n' : ''}${channelArn == 'PENDING' ? '- Channel ARN\n' : ''}${playbackUrl == 'PENDING' ? '- Playback URL\n' : ''}${ingestEndpoint == 'PENDING' ? '- Ingest Endpoint\n' : ''}${streamKey == 'PENDING' ? '- Stream Key\n' : ''}
Por favor, lee docs/AWS_SETUP_REQUIRED.md para configurar AWS IVS.
''';
    }
    return null;
  }

  /// Para testing: Modo simulado sin AWS real
  static const bool useSimulatedMode = false; // AWS configurado ✅
}
