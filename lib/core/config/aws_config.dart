/// Configuración de AWS IVS.
///
/// Los valores NO se escriben aquí: se inyectan al compilar, para que las
/// credenciales no queden en el repositorio. La forma cómoda es un archivo
/// JSON local (ignorado por git) y `--dart-define-from-file`:
///
/// ```bash
/// flutter run  --dart-define-from-file=aws_config.json
/// flutter build apk --release --dart-define-from-file=aws_config.json
/// ```
///
/// Con `aws_config.json` así (copiar de `aws_config.example.json`):
///
/// ```json
/// {
///   "AWS_REGION": "us-east-1",
///   "AWS_CHANNEL_ARN": "arn:aws:ivs:us-east-1:...:channel/...",
///   "AWS_PLAYBACK_URL": "https://....m3u8",
///   "AWS_INGEST_ENDPOINT": "rtmp://....global-contribute.live-video.net:1935/app/",
///   "AWS_STREAM_KEY": "sk_us-east-1_..."
/// }
/// ```
class AWSConfig {
  // ═══════════════════════════════════════════════════════════
  // VALORES INYECTADOS AL COMPILAR
  // ═══════════════════════════════════════════════════════════

  /// Región de AWS donde está configurado el canal IVS.
  static const String region = String.fromEnvironment(
    'AWS_REGION',
    defaultValue: 'us-east-1',
  );

  /// ARN del canal IVS.
  static const String channelArn = String.fromEnvironment('AWS_CHANNEL_ARN');

  /// URL para reproducir el stream (HLS).
  static const String playbackUrl = String.fromEnvironment('AWS_PLAYBACK_URL');

  /// Endpoint donde se envía el stream.
  ///
  /// AWS IVS acepta RTMPS (TLS, puerto 443) y RTMP plano (puerto 1935).
  ///
  /// ⚠️ El plugin `apivideo_live_stream` 1.2.0 NO implementa RTMPS: contra el
  /// 443 manda el handshake sin cifrar y el servidor corta la conexión. Hay
  /// que usar el 1935, y para eso el canal IVS debe tener habilitado
  /// "insecure ingest" al crearlo. La alternativa es cambiar de plugin por
  /// uno con soporte RTMPS (p. ej. haishin_kit) y volver al 443.
  static const String ingestEndpoint = String.fromEnvironment(
    'AWS_INGEST_ENDPOINT',
  );

  /// ⚠️ STREAM KEY — es una credencial.
  ///
  /// Nunca escribirla en el código ni commitearla. En producción debería
  /// pedirse al backend en vez de inyectarse al compilar, para poder rotarla
  /// sin publicar una versión nueva de la app.
  static const String streamKey = String.fromEnvironment('AWS_STREAM_KEY');

  /// URL del backend para operaciones AWS (opcional).
  static const String backendUrl = String.fromEnvironment('BACKEND_URL');

  // ═══════════════════════════════════════════════════════════
  // CONFIGURACIÓN DE CALIDAD DE STREAMING
  // ═══════════════════════════════════════════════════════════

  /// Calidad de video para streaming.
  static const Map<String, dynamic> videoQuality = {
    'width': 1280,
    'height': 720,
    'bitrate': 2500000, // 2.5 Mbps
    'fps': 30,
  };

  /// Calidad de audio.
  static const Map<String, dynamic> audioQuality = {
    'bitrate': 128000, // 128 kbps
    'sampleRate': 44100,
  };

  // ═══════════════════════════════════════════════════════════
  // VALIDACIÓN
  // ═══════════════════════════════════════════════════════════

  /// Campos obligatorios para poder transmitir.
  static Map<String, String> get _requeridos => {
    'AWS_REGION': region,
    'AWS_CHANNEL_ARN': channelArn,
    'AWS_PLAYBACK_URL': playbackUrl,
    'AWS_INGEST_ENDPOINT': ingestEndpoint,
    'AWS_STREAM_KEY': streamKey,
  };

  /// Nombres de los valores que faltan.
  static List<String> get faltantes => _requeridos.entries
      .where((e) => e.value.isEmpty)
      .map((e) => e.key)
      .toList();

  /// Verificar si la configuración está completa.
  static bool isConfigured() => faltantes.isEmpty;

  /// Mensaje de error si falta configuración.
  static String? getConfigError() {
    if (isConfigured()) return null;

    return '''
⚠️ AWS IVS no está configurado.

Faltan estos valores:
${faltantes.map((k) => '- $k').join('\n')}

Se inyectan al compilar. Copia aws_config.example.json a aws_config.json,
rellénalo con los datos del canal IVS y compila así:

  flutter run --dart-define-from-file=aws_config.json
''';
  }
}
