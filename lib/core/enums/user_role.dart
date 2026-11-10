/// Rol del usuario en la plataforma
enum UserRole {
  /// Usuario regular (hombre que consume contenido)
  subscriber,

  /// Creadora de contenido (mujer que genera contenido)
  creator,

  /// Usuario premium con beneficios adicionales
  premium,

  /// Administrador de la plataforma
  admin;

  /// Convierte el enum a String para Firestore
  String toJson() => name;

  /// Crea el enum desde String de Firestore
  static UserRole fromJson(String json) {
    return UserRole.values.firstWhere(
      (role) => role.name == json,
      orElse: () => UserRole.subscriber,
    );
  }

  /// Retorna si puede crear contenido
  bool get canCreateContent =>
      this == UserRole.creator || this == UserRole.admin;

  /// Retorna si tiene privilegios de admin
  bool get isAdmin => this == UserRole.admin;

  /// Retorna si es premium
  bool get isPremium => this == UserRole.premium;
}
