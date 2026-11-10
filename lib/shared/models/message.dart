/// Modelo de mensaje dentro de una conversación
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String type; // "text", "image", "gift", "system"
  final String text;
  final String? imageUrl;
  final MessageGift? gift;
  final bool isRead;
  final DateTime? readAt;
  final DateTime sentAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.type = 'text',
    required this.text,
    this.imageUrl,
    this.gift,
    this.isRead = false,
    this.readAt,
    required this.sentAt,
  });

  /// Crea una copia con campos modificados
  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? type,
    String? text,
    String? imageUrl,
    MessageGift? gift,
    bool? isRead,
    DateTime? readAt,
    DateTime? sentAt,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      type: type ?? this.type,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      gift: gift ?? this.gift,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  /// Convierte a Map para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'type': type,
      'text': text,
      'imageUrl': imageUrl,
      'gift': gift?.toJson(),
      'isRead': isRead,
      'readAt': readAt?.toIso8601String(),
      'sentAt': sentAt.toIso8601String(),
    };
  }

  /// Crea desde Map de Firestore
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      type: json['type'] as String? ?? 'text',
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String?,
      gift: json['gift'] != null
          ? MessageGift.fromJson(json['gift'] as Map<String, dynamic>)
          : null,
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, type: $type, text: $text)';
  }
}

/// Información de regalo enviado en mensaje
class MessageGift {
  final String type;
  final int value;
  final String imageUrl;

  MessageGift({
    required this.type,
    required this.value,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {'type': type, 'value': value, 'imageUrl': imageUrl};
  }

  factory MessageGift.fromJson(Map<String, dynamic> json) {
    return MessageGift(
      type: json['type'] as String,
      value: json['value'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
