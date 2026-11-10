import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/phone_auth_service.dart';
import '../../data/services/google_auth_service.dart';
import '../../../../shared/services/user_cache_service.dart';
import 'auth_state.dart';

part 'auth_controller.g.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(PhoneAuthService(), GoogleAuthService());
});

@riverpod
class AuthController extends _$AuthController {
  late AuthRepository _authRepository;
  final UserCacheService _cacheService = UserCacheService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return const AuthStateInitial();
  }

  Future<String> sendPhoneOTP(String phoneNumber) async {
    state = const AuthStateLoading();
    try {
      final phoneWithCode = phoneNumber.startsWith('+')
          ? phoneNumber
          : '+591$phoneNumber';
      final verificationId = await _authRepository.sendPhoneOTP(phoneWithCode);
      state = const AuthStateInitial();
      return verificationId;
    } catch (e) {
      state = AuthStateError(e.toString());
      rethrow;
    }
  }

  Future<void> signInWithoutPhoneVerification({
    required String userType,
    required bool isLogin,
  }) async {
    if (!kDebugMode) {
      throw StateError(
        'El acceso sin verificación solo está disponible en desarrollo.',
      );
    }

    state = const AuthStateLoading();
    try {
      final firebaseUser = await _authRepository.signInAnonymously();
      final demoUserType = isLogin ? userType : 'indefinido';

      await _firestore.collection('users').doc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
        'type': demoUserType,
        'userType': demoUserType,
        'isActive': true,
        'isVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _cacheService.saveUser(
        userId: firebaseUser.uid,
        userType: demoUserType,
      );
      state = const AuthStateInitial();
    } catch (e) {
      state = AuthStateError(e.toString());
      rethrow;
    }
  }

  Future<void> verifyPhoneOTP({
    required String verificationId,
    required String otp,
    required String phoneNumber,
  }) async {
    print('🟢 verifyPhoneOTP() llamado en AuthController');
    state = const AuthStateLoading();
    try {
      final phoneWithCode = phoneNumber.startsWith('+')
          ? phoneNumber
          : '+591$phoneNumber';

      final firebaseUser = await _authRepository.verifyPhoneOTP(
        verificationId: verificationId,
        otp: otp,
        phoneNumber: phoneWithCode,
      );

      if (firebaseUser == null) {
        state = const AuthStateError('Error en autenticación');
        return;
      }

      print('🟢 Firebase User UID: ${firebaseUser.uid}');
      print('🟢 Número de teléfono: $phoneWithCode');

      // Verificar si el usuario existe en Firestore por UID
      var userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      print('🔵 Buscando usuario por UID: ${firebaseUser.uid}');
      print('🔵 Usuario existe por UID: ${userDoc.exists}');

      // Si no existe por UID, buscar por número de teléfono
      if (!userDoc.exists) {
        print('🟡 Buscando usuario por teléfono: $phoneWithCode');
        final querySnapshot = await _firestore
            .collection('users')
            .where('phoneNumber', isEqualTo: phoneWithCode)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          userDoc = querySnapshot.docs.first;
          print('🟢 Usuario encontrado por teléfono con UID: ${userDoc.id}');
        } else {
          print('🔴 No se encontró usuario por teléfono');
        }
      }

      if (userDoc.exists) {
        // ✅ USUARIO EXISTENTE → Login directo
        print('🟢 Usuario existente encontrado en Firestore');
        final userData = userDoc.data();
        final userType =
            userData?['userType'] ?? userData?['type'] ?? 'indefinido';

        print('🟢 UserType del usuario: $userType');

        // Si el tipo es indefinido, necesita completar registro
        if (userType == 'indefinido') {
          print('🟡 Usuario con tipo indefinido, debe completar registro');
          state = const AuthStateInitial();
          return;
        }

        // Convertir Timestamps a String antes de guardar en cache
        final userDataForCache = <String, dynamic>{};
        userData?.forEach((key, value) {
          if (value is Timestamp) {
            userDataForCache[key] = value.toDate().toIso8601String();
          } else if (value != null) {
            userDataForCache[key] = value;
          }
        });

        // Guardar en cache
        await _cacheService.saveUser(
          userId: userDoc.id,
          userType: userType,
          userData: userDataForCache,
        );

        // Intentar actualizar lastLogin
        try {
          await _firestore.collection('users').doc(userDoc.id).update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          print('⚠️ No se pudo actualizar lastLogin: $e');
        }

        // Parsear birthDate de forma segura
        DateTime birthDate = DateTime.now();
        try {
          if (userData?['birthDate'] != null) {
            final birthDateValue = userData!['birthDate'];
            if (birthDateValue is Timestamp) {
              birthDate = birthDateValue.toDate();
            } else if (birthDateValue is String) {
              birthDate = DateTime.parse(birthDateValue);
            }
          }
        } catch (e) {
          print('⚠️ Error parseando birthDate: $e');
        }

        print('🟢 Creando objeto User...');
        final user = User(
          id: userDoc.id,
          phone: userData?['phone'] ?? phoneWithCode,
          name: userData?['name'] ?? '',
          email: userData?['email'],
          birthDate: birthDate,
          isVerified: true,
        );

        print('🟢 Seteando estado AuthStateAuthenticated...');
        state = AuthStateAuthenticated(user);
        print('✅ Estado seteado correctamente');

        // Navegar directamente según el tipo de usuario
        final targetRoute = userType == 'female'
            ? '/female/contenido'
            : '/male/home';
        print('🔵 Navegando directamente a: $targetRoute');
        Modular.to.navigate(targetRoute);
      } else {
        // ❌ USUARIO NUEVO → Dejar estado inicial para que la pantalla maneje
        print('🟡 Usuario nuevo, debe completar registro');
        state = const AuthStateInitial();
      }
    } catch (e, stackTrace) {
      print('🔴 Error en verifyPhoneOTP: $e');
      print('🔴 Stack trace: $stackTrace');
      state = AuthStateError(e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.signOut();
      await _cacheService.clearUser();
      state = const AuthStateUnauthenticated();
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> saveUserType(String userType) async {
    try {
      final user = _authRepository.getCurrentUser();
      if (user != null) {
        await _authRepository.saveUserType(
          userId: user.uid,
          userType: userType,
        );
        // Actualizar en cache
        await _cacheService.updateUserType(userType);
      }
    } catch (e) {
      state = AuthStateError(e.toString());
      rethrow;
    }
  }

  String? getCurrentUserId() {
    return _authRepository.getCurrentUser()?.uid;
  }

  Future<bool> checkUserExistsInFirestore(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.exists;
    } catch (e) {
      print('❌ Error verificando usuario: $e');
      return false;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String username,
    required DateTime birthDate,
    String? email,
    String? photoUrl,
  }) async {
    try {
      final user = _authRepository.getCurrentUser();
      if (user != null) {
        // Verificar si el usuario existe en Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // Usuario existente → actualizar
          await _authRepository.updateUserProfile(
            userId: user.uid,
            name: name,
            username: username,
            birthDate: birthDate,
            email: email,
            photoUrl: photoUrl,
          );
        } else {
          // Usuario nuevo de Google → crear documento completo
          print('🟢 Creando documento para usuario de Google');
          await _authRepository.createGoogleUserDocument(
            uid: user.uid,
            name: name,
            username: username,
            phone: user.phoneNumber ?? '',
            birthDate: birthDate,
            userType: 'indefinido', // Se actualizará después
            photoUrl: photoUrl ?? user.photoURL,
          );
        }
      }
    } catch (e) {
      print('🔴 Error en updateProfile: $e');
      state = AuthStateError(e.toString());
      rethrow;
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    print('🟢 signInWithGoogle() llamado en AuthController');
    state = const AuthStateLoading();
    try {
      final firebaseUser = await _authRepository.signInWithGoogle();
      print('🟢 Firebase User UID: ${firebaseUser?.uid ?? "null"}');
      print('🟢 Firebase User Email: ${firebaseUser?.email ?? "null"}');

      if (firebaseUser == null) {
        // Usuario canceló el login
        state = const AuthStateInitial();
        return;
      }

      // Verificar si el usuario existe en Firestore por UID
      var userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      print('🔵 Buscando usuario por UID: ${firebaseUser.uid}');
      print('🔵 Usuario existe por UID: ${userDoc.exists}');

      // Si no existe por UID, buscar por email
      if (!userDoc.exists && firebaseUser.email != null) {
        print('🟡 Buscando usuario por email: ${firebaseUser.email}');
        final querySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: firebaseUser.email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          userDoc = querySnapshot.docs.first;
          print('🟢 Usuario encontrado por email con UID: ${userDoc.id}');
        } else {
          print('🔴 No se encontró usuario por email');
        }
      }

      if (userDoc.exists) {
        // ✅ USUARIO EXISTENTE → Login directo
        print('🟢 Usuario existente encontrado en Firestore');
        final userData = userDoc.data();
        final userType =
            userData?['userType'] ?? userData?['type'] ?? 'indefinido';

        print('🟢 UserType del usuario: $userType');

        // Convertir Timestamps a String antes de guardar en cache
        final userDataForCache = <String, dynamic>{};
        userData?.forEach((key, value) {
          if (value is Timestamp) {
            userDataForCache[key] = value.toDate().toIso8601String();
          } else if (value != null) {
            userDataForCache[key] = value;
          }
        });

        // Guardar en cache
        await _cacheService.saveUser(
          userId: userDoc.id,
          userType: userType,
          userData: userDataForCache,
        );

        // Intentar actualizar lastLogin (puede fallar si los UIDs no coinciden)
        try {
          await _firestore.collection('users').doc(userDoc.id).update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          print('⚠️ No se pudo actualizar lastLogin (permisos): $e');
          // No es crítico, continuar con el login
        }

        // Parsear birthDate de forma segura
        DateTime birthDate = DateTime.now();
        try {
          if (userData?['birthDate'] != null) {
            final birthDateValue = userData!['birthDate'];
            if (birthDateValue is Timestamp) {
              birthDate = birthDateValue.toDate();
            } else if (birthDateValue is String) {
              birthDate = DateTime.parse(birthDateValue);
            }
          }
        } catch (e) {
          print('⚠️ Error parseando birthDate: $e');
        }

        print('🟢 Creando objeto User...');
        final user = User(
          id: userDoc.id,
          phone: userData?['phone'] ?? '',
          name: userData?['name'] ?? firebaseUser.displayName ?? '',
          email: firebaseUser.email,
          birthDate: birthDate,
          isVerified: true,
        );

        print('🟢 Seteando estado AuthStateAuthenticated...');
        state = AuthStateAuthenticated(user);
        print('✅ Estado seteado correctamente');

        // Navegar directamente según el tipo de usuario
        final targetRoute = userType == 'female'
            ? '/female/contenido'
            : '/male/home';
        print('🔵 Navegando directamente a: $targetRoute');
        Modular.to.navigate(targetRoute);
      } else {
        // ❌ USUARIO NUEVO → Necesita completar registro
        print('🔴 Usuario nuevo, debe completar registro');
        print('🔴 UID de Firebase Auth: ${firebaseUser.uid}');
        print('🔴 Email: ${firebaseUser.email}');
        state = AuthStateNeedsProfileCompletion(
          User(
            id: firebaseUser.uid,
            phone: '',
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email,
            birthDate: DateTime.now(),
            isVerified: false,
          ),
        );
      }
    } catch (e, stackTrace) {
      print('🔴 Error en signInWithGoogle: $e');
      print('🔴 Stack trace: $stackTrace');
      state = AuthStateError(e.toString());
      rethrow;
    }
  }

  // Obtener userType desde cache
  Future<String?> getUserType() async {
    return await _cacheService.getUserType();
  }

  // Verificar si hay usuario autenticado en cache
  Future<bool> isAuthenticated() async {
    return await _cacheService.isAuthenticated();
  }
}
