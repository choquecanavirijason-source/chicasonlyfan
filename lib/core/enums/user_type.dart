/// Tipo de usuario en la aplicación
enum UserType {
  /// Usuario hombre (suscriptor/consumidor de contenido)
  male,

  /// Usuario mujer (creadora de contenido)
  female;

  /// Convierte el enum a String para Firestore
  String toJson() => name;

  /// Crea el enum desde String de Firestore
  static UserType fromJson(String json) {
    return UserType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => UserType.male,
    );
  }

  /// Retorna si es creadora de contenido
  bool get isCreator => this == UserType.female;

  /// Retorna si es suscriptor
  bool get isSubscriber => this == UserType.male;
}
