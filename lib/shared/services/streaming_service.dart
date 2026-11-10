import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/config/aws_config.dart';

/// Servicio para gestionar streaming con AWS IVS
class StreamingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Obtener información del canal del usuario actual
  Future<Map<String, String>?> getMyChannelInfo() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Retornar configuración de AWS IVS
      return {
        'playbackUrl': AWSConfig.playbackUrl,
        'ingestEndpoint': AWSConfig.ingestEndpoint,
        'streamKey': AWSConfig.streamKey,
      };
    } catch (e) {
      print('Error al obtener canal: $e');
      return null;
    }
  }

  /// Registrar inicio de streaming
  Future<String> startStreaming({
    required String userId,
    required String userName,
    required String userAvatar,
  }) async {
    try {
      final streamId = _firestore.collection('active_streams').doc().id;

      final streamData = {
        'streamId': streamId,
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'playbackUrl': AWSConfig.playbackUrl,
        'startedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'viewerCount': 0,
      };

      print('📝 Creando documento en Firestore:');
      print('   Collection: active_streams');
      print('   Doc ID: $streamId');
      print('   Data: $streamData');

      await _firestore
          .collection('active_streams')
          .doc(streamId)
          .set(streamData);

      print('✅ Documento creado exitosamente en Firestore');

      return streamId;
    } catch (e) {
      print('❌ Error al registrar streaming: $e');
      throw Exception('Error al registrar streaming: $e');
    }
  }

  /// Finalizar streaming
  Future<void> stopStreaming(String streamId) async {
    try {
      print('🛑 Finalizando stream: $streamId');
      await _firestore.collection('active_streams').doc(streamId).update({
        'isActive': false,
        'endedAt': FieldValue.serverTimestamp(),
      });
      print('✅ Stream finalizado');
    } catch (e) {
      print('❌ Error al finalizar streaming: $e');
      throw Exception('Error al finalizar streaming: $e');
    }
  }

  /// Verificar si el usuario actual tiene un live activo
  Future<Map<String, dynamic>?> getMyActiveLive() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      print('🔍 Buscando live activo para userId: ${user.uid}');

      final querySnapshot = await _firestore
          .collection('active_streams')
          .where('userId', isEqualTo: user.uid)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('📭 No hay live activo');
        return null;
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      data['streamId'] = doc.id;

      print('✅ Live activo encontrado: ${doc.id}');
      return data;
    } catch (e) {
      print('❌ Error al buscar live activo: $e');
      return null;
    }
  }

  /// Obtener streams activos
  Stream<QuerySnapshot> getActiveStreamsStream() {
    print('🔍 Consultando active_streams con isActive=true');
    try {
      // Consulta simple sin orderBy para evitar problemas de índices
      return _firestore
          .collection('active_streams')
          .where('isActive', isEqualTo: true)
          .snapshots();
    } catch (e) {
      print('❌ Error en getActiveStreamsStream: $e');
      rethrow;
    }
  }

  /// Obtener streams activos (lista)
  Stream<List<Map<String, dynamic>>> getActiveStreams() {
    return _firestore
        .collection('active_streams')
        .where('isActive', isEqualTo: true)
        .orderBy('startedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  /// Obtener contador de viewers
  Future<int> getViewerCount(String streamId) async {
    try {
      final doc = await _firestore
          .collection('active_streams')
          .doc(streamId)
          .get();

      if (!doc.exists) return 0;

      final data = doc.data();
      return data?['viewerCount'] ?? 0;
    } catch (e) {
      print('Error al obtener viewer count: $e');
      return 0;
    }
  }

  /// Obtener información de canal de otro usuario (para ver su stream)
  Future<Map<String, String>?> getChannelInfoForUser(String userId) async {
    try {
      // Todos usan el mismo canal de AWS IVS
      return {'playbackUrl': AWSConfig.playbackUrl};
    } catch (e) {
      print('Error al obtener canal del usuario: $e');
      return null;
    }
  }

  /// Incrementar contador de viewers
  Future<void> incrementViewerCount(String streamId) async {
    try {
      await _firestore.collection('active_streams').doc(streamId).update({
        'viewerCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error al incrementar viewers: $e');
    }
  }

  /// Decrementar contador de viewers
  Future<void> decrementViewerCount(String streamId) async {
    try {
      await _firestore.collection('active_streams').doc(streamId).update({
        'viewerCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error al decrementar viewers: $e');
    }
  }
}
