import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Verifica si un usuario existe en Firestore por su UID
  Future<bool> checkUserExists(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<String> sendOTP(String phoneNumber) async {
    final Completer<String> completer = Completer<String>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Autenticación automática en algunos dispositivos Android
          await _auth.signInWithCredential(credential);
          if (!completer.isCompleted) {
            completer.complete('auto-verified');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!completer.isCompleted) {
            completer.completeError(
              Exception('Error de verificación: ${e.message}'),
            );
          }
        },
        codeSent: (String verId, int? resendToken) {
          if (!completer.isCompleted) {
            completer.complete(verId);
          }
        },
        codeAutoRetrievalTimeout: (String verId) {
          // Timeout alcanzado, si no se completó antes, completar ahora
          if (!completer.isCompleted) {
            completer.complete(verId);
          }
        },
        timeout: const Duration(seconds: 60),
      );

      return await completer.future;
    } catch (e) {
      throw Exception('Error al enviar OTP: $e');
    }
  }

  Future<User> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;
      if (user == null) {
        throw StateError('Firebase no devolvió un usuario anónimo.');
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'operation-not-allowed' ||
          e.code == 'admin-restricted-operation') {
        throw StateError(
          'Activa el proveedor Anónimo en Firebase Console > Authentication > '
          'Sign-in method para usar el código de prueba 000000.',
        );
      }
      rethrow;
    }
  }

  Future<User?> verifyOTP({
    required String verificationId,
    required String otp,
    required String phoneNumber,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _saveOrUpdateUser(user, phoneNumber);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Código inválido o expirado: ${e.message}');
    } catch (e) {
      throw Exception('Error al verificar código: $e');
    }
  }

  Future<void> _saveOrUpdateUser(User user, String phoneNumber) async {
    try {
      final phoneWithCode = phoneNumber.startsWith('+')
          ? phoneNumber
          : '+591$phoneNumber';

      final existingQuery = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneWithCode)
          .limit(1)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        final existingDoc = existingQuery.docs.first;
        final oldUid = existingDoc.id;

        if (oldUid != user.uid) {
          final existingData = existingDoc.data();

          await _firestore.collection('users').doc(user.uid).set({
            ...existingData,
            'uid': user.uid,
            'lastLogin': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'phoneNumber': phoneWithCode,
          });

          await _firestore.collection('users').doc(oldUid).delete();
        } else {
          await _firestore.collection('users').doc(user.uid).update({
            'lastLogin': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      } else {
        // Usuario completamente nuevo - guardar con tipo indefinido
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'phoneNumber': phoneWithCode,
          'type': 'indefinido',
          'userType': 'indefinido',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'isActive': true,
          'isVerified': false,
        });
      }
    } catch (e) {
      throw Exception('Error guardando usuario: $e');
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String username,
    required DateTime birthDate,
    String? email,
    String? photoUrl,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': name,
        'username': username,
        'birthDate': birthDate.toIso8601String(),
        'email': email,
        'photoUrl': photoUrl,
        'isVerified': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error actualizando perfil: $e');
    }
  }

  /// Guarda el tipo de usuario (male o female) en Firestore
  Future<void> saveUserType({
    required String userId,
    required String userType,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'type': userType,
        'userType': userType,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error guardando tipo de usuario: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
