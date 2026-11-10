import 'dart:convert';
import 'package:http/http.dart' as http;

/// Cliente para interactuar con AWS IVS a través de tu backend
/// En producción, estas operaciones deben hacerse desde Cloud Functions
/// por seguridad (no exponer credenciales AWS en la app)
class AWSIVSClient {
  final String region;
  final String baseUrl;

  AWSIVSClient({required this.region, required this.baseUrl});

  /// Obtener configuración del canal para un usuario
  /// Esto debe llamar a tu backend/Cloud Function
  Future<IVSChannelInfo> getChannelForUser(String userId) async {
    try {
      // TODO: Reemplazar con tu endpoint real
      final response = await http.get(
        Uri.parse('$baseUrl/getChannel?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return IVSChannelInfo.fromJson(data);
      } else {
        throw Exception('Error al obtener canal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con AWS: $e');
    }
  }

  /// Crear un nuevo canal para un usuario
  Future<IVSChannelInfo> createChannel(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/createChannel'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return IVSChannelInfo.fromJson(data);
      } else {
        throw Exception('Error al crear canal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear canal: $e');
    }
  }

  /// Obtener stream key de forma segura
  Future<String> getStreamKey(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getStreamKey?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['streamKey'] as String;
      } else {
        throw Exception('Error al obtener stream key');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

/// Información de un canal IVS
class IVSChannelInfo {
  final String channelArn;
  final String playbackUrl;
  final String ingestEndpoint;
  final String userId;
  final DateTime createdAt;

  IVSChannelInfo({
    required this.channelArn,
    required this.playbackUrl,
    required this.ingestEndpoint,
    required this.userId,
    required this.createdAt,
  });

  factory IVSChannelInfo.fromJson(Map<String, dynamic> json) {
    return IVSChannelInfo(
      channelArn: json['channelArn'] as String,
      playbackUrl: json['playbackUrl'] as String,
      ingestEndpoint: json['ingestEndpoint'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channelArn': channelArn,
      'playbackUrl': playbackUrl,
      'ingestEndpoint': ingestEndpoint,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
