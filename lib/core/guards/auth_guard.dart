import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/auth_config.dart';

/// Guard para proteger rutas que requieren autenticación
class AuthGuard extends RouteGuard {
  final String? requiredType;

  AuthGuard({this.requiredType}) : super(redirectTo: '/auth/sign-in');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    if (!authenticationEnabled) {
      return true;
    }

    print(
      '🛡️ AuthGuard - canActivate para path: $path, requiredType: $requiredType',
    );

    // Verificar si hay un usuario autenticado
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('🛡️ AuthGuard - No hay usuario autenticado');
      return false;
    }

    print('🛡️ AuthGuard - Usuario autenticado: ${user.email}');

    // Permitir acceso a select-role para usuarios autenticados
    if (path.contains('/select-role')) {
      print('🛡️ AuthGuard - Permitiendo acceso a select-role');
      return true;
    }

    // Si se requiere un tipo específico, verificar
    if (requiredType != null) {
      try {
        // Intentar buscar por UID
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Si no existe por UID, buscar por email
        if (!userDoc.exists && user.email != null) {
          print(
            '🛡️ AuthGuard - Usuario no encontrado por UID, buscando por email: ${user.email}',
          );
          final querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: user.email)
              .limit(1)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            userDoc = querySnapshot.docs.first;
            print(
              '🛡️ AuthGuard - Usuario encontrado por email con UID: ${userDoc.id}',
            );
          }
        }

        if (!userDoc.exists) {
          print('🛡️ AuthGuard - Usuario no encontrado en Firestore');
          return false;
        }

        final userData = userDoc.data()!;
        final userType = (userData['type'] ?? userData['userType']) as String?;
        print('🛡️ AuthGuard - UserType encontrado: $userType');

        // Si el tipo es indefinido, redirigir a login
        if (userType == null || userType == 'indefinido') {
          print('🛡️ AuthGuard - UserType indefinido, redirigiendo a sign-in');
          Modular.to.navigate('/auth/sign-in');
          return false;
        }

        // Verificar si el tipo coincide con el requerido
        if (userType != requiredType) {
          // Redirigir al home correcto según su tipo
          final targetRoute = userType == 'female' ? '/female/' : '/male/';
          print(
            '🛡️ AuthGuard - UserType no coincide, redirigiendo a: $targetRoute',
          );
          Modular.to.navigate(targetRoute);
          return false;
        }

        print('🛡️ AuthGuard - Acceso permitido ✅');
        return true;
      } catch (e) {
        print('🛡️ AuthGuard - Error: $e');
        return false;
      }
    }

    print('🛡️ AuthGuard - No requiere tipo específico, acceso permitido');
    return true;
  }
}
