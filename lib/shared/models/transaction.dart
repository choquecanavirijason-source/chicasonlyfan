import '../../core/enums/transaction_enums.dart';

/// Modelo de transacción para compras y gastos de minutos
class Transaction {
  final String id;
  final String userId;
  final TransactionType type;
  final int minutes;
  final double amount;
  final String currency;
  final String description;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final RelatedTo? relatedTo;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.minutes,
    required this.amount,
    this.currency = 'BOB',
    required this.description,
    required this.paymentMethod,
    this.paymentStatus = PaymentStatus.pending,
    this.relatedTo,
    this.metadata,
    required this.createdAt,
  });

  /// Crea una copia con campos modificados
  Transaction copyWith({
    String? id,
    String? userId,
    TransactionType? type,
    int? minutes,
    double? amount,
    String? currency,
    String? description,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    RelatedTo? relatedTo,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      minutes: minutes ?? this.minutes,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      relatedTo: relatedTo ?? this.relatedTo,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convierte a Map para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toJson(),
      'minutes': minutes,
      'amount': amount,
      'currency': currency,
      'description': description,
      'paymentMethod': paymentMethod.toJson(),
      'paymentStatus': paymentStatus.toJson(),
      'relatedTo': relatedTo?.toJson(),
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Crea desde Map de Firestore
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: TransactionType.fromJson(json['type'] as String),
      minutes: json['minutes'] as int,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'BOB',
      description: json['description'] as String,
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod'] as String),
      paymentStatus: PaymentStatus.fromJson(
        json['paymentStatus'] as String? ?? 'pending',
      ),
      relatedTo: json['relatedTo'] != null
          ? RelatedTo.fromJson(json['relatedTo'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, type: $type, amount: $amount, minutes: $minutes)';
  }
}

/// Información relacionada a la transacción (para gastos)
class RelatedTo {
  final String type; // "live", "post", "message"
  final String id; // ID del live/post
  final String creatorId; // Creadora que recibió el pago
  final double creatorEarnings; // Ganancia de la creadora
  final double platformFee; // Comisión de la plataforma

  RelatedTo({
    required this.type,
    required this.id,
    required this.creatorId,
    required this.creatorEarnings,
    required this.platformFee,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'creatorId': creatorId,
      'creatorEarnings': creatorEarnings,
      'platformFee': platformFee,
    };
  }

  factory RelatedTo.fromJson(Map<String, dynamic> json) {
    return RelatedTo(
      type: json['type'] as String,
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      creatorEarnings: (json['creatorEarnings'] as num).toDouble(),
      platformFee: (json['platformFee'] as num).toDouble(),
    );
  }
}
