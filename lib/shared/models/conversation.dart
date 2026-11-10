/// Modelo de conversación entre dos usuarios
class Conversation {
  final String id;
  final List<String> participantIds;
  final Map<String, ConversationParticipant> participants;
  final LastMessage? lastMessage;
  final bool isActive;
  final bool isBlocked;
  final String? blockedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.participantIds,
    required this.participants,
    this.lastMessage,
    this.isActive = true,
    this.isBlocked = false,
    this.blockedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea una copia con campos modificados
  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    Map<String, ConversationParticipant>? participants,
    LastMessage? lastMessage,
    bool? isActive,
    bool? isBlocked,
    String? blockedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      blockedBy: blockedBy ?? this.blockedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convierte a Map para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'participants': participants.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'lastMessage': lastMessage?.toJson(),
      'isActive': isActive,
      'isBlocked': isBlocked,
      'blockedBy': blockedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Crea desde Map de Firestore
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participants: (json['participants'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          ConversationParticipant.fromJson(value as Map<String, dynamic>),
        ),
      ),
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      isBlocked: json['isBlocked'] as bool? ?? false,
      blockedBy: json['blockedBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Conversation(id: $id, participants: $participantIds)';
  }
}

/// Información de participante en la conversación
class ConversationParticipant {
  final String name;
  final String avatar;
  final String role;
  final int unreadCount;

  ConversationParticipant({
    required this.name,
    required this.avatar,
    required this.role,
    this.unreadCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'role': role,
      'unreadCount': unreadCount,
    };
  }

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) {
    return ConversationParticipant(
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      role: json['role'] as String,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }
}

/// Último mensaje de la conversación
class LastMessage {
  final String text;
  final String senderId;
  final DateTime sentAt;
  final String type;

  LastMessage({
    required this.text,
    required this.senderId,
    required this.sentAt,
    this.type = 'text',
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'senderId': senderId,
      'sentAt': sentAt.toIso8601String(),
      'type': type,
    };
  }

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      text: json['text'] as String,
      senderId: json['senderId'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      type: json['type'] as String? ?? 'text',
    );
  }
}
