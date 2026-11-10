import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Inicia sesión con Google (solo autenticación, NO crea usuario en Firestore)
  Future<User?> signInWithGoogle() async {
    try {
      print('🟡 GoogleAuthService.signInWithGoogle() iniciado');
      // Trigger el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print(
        '🟡 GoogleSignInAccount: ${googleUser?.email ?? "null (usuario canceló)"}',
      );

      if (googleUser == null) {
        // El usuario canceló el login
        return null;
      }

      // Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crear credencial de Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión en Firebase con la credencial de Google
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      print('🟡 Usuario autenticado con Google: ${user?.email}');

      // NO creamos el usuario aquí, solo autenticamos
      // El AuthController se encargará de verificar si existe y tomar acción

      return user;
    } catch (e) {
      print('🔴 ERROR en GoogleAuthService: $e');
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  /// Guarda o actualiza el usuario de Google en Firestore
  Future<void> _saveOrUpdateGoogleUser(
    User user,
    GoogleSignInAccount googleUser,
  ) async {
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        // Usuario existente - actualizar lastLogin
        await _firestore.collection('users').doc(user.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Usuario nuevo - crear documento
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName ?? '',
          'username': _generateUsername(user.displayName ?? 'user'),
          'photoUrl': user.photoURL,
          'type': 'indefinido',
          'userType': 'indefinido',
          'authProvider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'isActive': true,
          'isVerified': true, // Google accounts are pre-verified
        });
      }
    } catch (e) {
      throw Exception('Error guardando usuario de Google: $e');
    }
  }

  /// Crea el documento del usuario en Firestore después del registro
  /// (se llama después de que el usuario complete todo el flujo de registro)
  Future<void> createUserDocument({
    required String uid,
    required String name,
    required String username,
    required String phone,
    required DateTime birthDate,
    required String userType,
    String? photoUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': user?.email ?? '',
        'name': name,
        'username': username,
        'phone': phone,
        'birthDate': Timestamp.fromDate(birthDate),
        'photoUrl': photoUrl ?? user?.photoURL,
        'type': userType,
        'userType': userType,
        'authProvider': 'google',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'isActive': true,
        'isVerified': true,
      });
      print('🟢 Usuario creado en Firestore: $uid');
    } catch (e) {
      print('🔴 Error creando usuario: $e');
      throw Exception('Error creando usuario: $e');
    }
  }

  /// Genera un username único basado en el nombre
  String _generateUsername(String name) {
    final cleanName = name.toLowerCase().replaceAll(' ', '_');
    final timestamp = DateTime.now().millisecondsSinceEpoch % 10000;
    return '$cleanName$timestamp';
  }

  /// Cierra sesión de Google
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  /// Obtiene el usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Verifica si el usuario existe en Firestore
  Future<bool> checkUserExists(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
