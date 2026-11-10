import '../../../../core/enums/user_type.dart';
import '../../../../core/enums/user_role.dart';

/// Modelo de usuario de la aplicación
class User {
  final String id;
  final String phone;
  final String? username;
  final String? name;
  final String? email;
  final String? profileImageUrl;
  final String? bio;
  final DateTime? birthDate;

  /// Tipo de usuario: male (hombre/suscriptor) o female (mujer/creadora)
  final UserType userType;

  /// Rol del usuario: subscriber, creator, premium, admin
  final UserRole role;

  final bool isVerified;
  final bool isOnline;
  final DateTime? lastSeen;
  final List<String> interests;
  final List<String> followers;
  final List<String> following;
  final List<String> blockedUsers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.phone,
    this.username,
    this.name,
    this.email,
    this.profileImageUrl,
    this.bio,
    this.birthDate,
    this.userType = UserType.male,
    this.role = UserRole.subscriber,
    this.isVerified = false,
    this.isOnline = false,
    this.lastSeen,
    this.interests = const [],
    this.followers = const [],
    this.following = const [],
    this.blockedUsers = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// Crea una copia del usuario con los campos especificados modificados
  User copyWith({
    String? id,
    String? phone,
    String? username,
    String? name,
    String? email,
    String? profileImageUrl,
    String? bio,
    DateTime? birthDate,
    UserType? userType,
    UserRole? role,
    bool? isVerified,
    bool? isOnline,
    DateTime? lastSeen,
    List<String>? interests,
    List<String>? followers,
    List<String>? following,
    List<String>? blockedUsers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      userType: userType ?? this.userType,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      interests: interests ?? this.interests,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convierte el usuario a Map para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'username': username,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'birthDate': birthDate?.toIso8601String(),
      'userType': userType.toJson(),
      'role': role.toJson(),
      'isVerified': isVerified,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
      'interests': interests,
      'followers': followers,
      'following': following,
      'blockedUsers': blockedUsers,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Crea un usuario desde Map de Firestore
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      phone: json['phone'] as String,
      username: json['username'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'] as String)
          : null,
      userType: json['userType'] != null
          ? UserType.fromJson(json['userType'] as String)
          : UserType.male,
      role: json['role'] != null
          ? UserRole.fromJson(json['role'] as String)
          : UserRole.subscriber,
      isVerified: json['isVerified'] as bool? ?? false,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      interests:
          (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      followers:
          (json['followers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      following:
          (json['following'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      blockedUsers:
          (json['blockedUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.id == id && other.phone == phone;
  }

  @override
  int get hashCode => id.hashCode ^ phone.hashCode;

  @override
  String toString() {
    return 'User(id: $id, phone: $phone, username: $username, name: $name, userType: $userType, role: $role)';
  }

  /// Helper: Retorna si es creadora de contenido
  bool get isCreator => userType == UserType.female && role == UserRole.creator;

  /// Helper: Retorna si es suscriptor
  bool get isSubscriber =>
      userType == UserType.male && role == UserRole.subscriber;
}
