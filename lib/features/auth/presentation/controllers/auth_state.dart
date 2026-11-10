import '../../domain/entities/user.dart';

// Estados de autenticación usando sealed classes (Dart 3+)
sealed class AuthState {
  const AuthState();
}

// Estado inicial
class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

// Estado de carga
class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

// Estado autenticado con usuario
class AuthStateAuthenticated extends AuthState {
  final User user;

  const AuthStateAuthenticated(this.user);
}

// Estado no autenticado
class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

// Estado de error
class AuthStateError extends AuthState {
  final String message;

  const AuthStateError(this.message);
}

// Estado cuando el usuario necesita completar su perfil
class AuthStateNeedsProfileCompletion extends AuthState {
  final User user;

  const AuthStateNeedsProfileCompletion(this.user);
}

// Extension para mantener compatibilidad con la sintaxis anterior
extension AuthStateFactories on AuthState {
  static AuthState initial() => const AuthStateInitial();
  static AuthState loading() => const AuthStateLoading();
  static AuthState authenticated(User user) => AuthStateAuthenticated(user);
  static AuthState unauthenticated() => const AuthStateUnauthenticated();
  static AuthState error(String message) => AuthStateError(message);
}
