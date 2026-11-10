/// Modelo de billetera de usuario para gestionar minutos disponibles
class Wallet {
  final String userId;
  final int availableMinutes;
  final int totalPurchased;
  final int totalSpent;
  final double totalAmount;
  final LastPurchase? lastPurchase;
  final int pendingCharges;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Wallet({
    required this.userId,
    this.availableMinutes = 0,
    this.totalPurchased = 0,
    this.totalSpent = 0,
    this.totalAmount = 0.0,
    this.lastPurchase,
    this.pendingCharges = 0,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  /// Agrega minutos a la billetera
  Wallet addMinutes(int minutes, double amount) {
    return copyWith(
      availableMinutes: availableMinutes + minutes,
      totalPurchased: totalPurchased + minutes,
      totalAmount: totalAmount + amount,
      lastPurchase: LastPurchase(
        amount: amount,
        minutes: minutes,
        date: DateTime.now(),
      ),
      updatedAt: DateTime.now(),
    );
  }

  /// Descuenta minutos de la billetera
  Wallet deductMinutes(int minutes) {
    if (availableMinutes < minutes) {
      throw Exception('Minutos insuficientes');
    }
    return copyWith(
      availableMinutes: availableMinutes - minutes,
      totalSpent: totalSpent + minutes,
      updatedAt: DateTime.now(),
    );
  }

  /// Verifica si tiene minutos suficientes
  bool hasEnoughMinutes(int requiredMinutes) {
    return availableMinutes >= requiredMinutes;
  }

  /// Crea una copia con los campos modificados
  Wallet copyWith({
    String? userId,
    int? availableMinutes,
    int? totalPurchased,
    int? totalSpent,
    double? totalAmount,
    LastPurchase? lastPurchase,
    int? pendingCharges,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Wallet(
      userId: userId ?? this.userId,
      availableMinutes: availableMinutes ?? this.availableMinutes,
      totalPurchased: totalPurchased ?? this.totalPurchased,
      totalSpent: totalSpent ?? this.totalSpent,
      totalAmount: totalAmount ?? this.totalAmount,
      lastPurchase: lastPurchase ?? this.lastPurchase,
      pendingCharges: pendingCharges ?? this.pendingCharges,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convierte a Map para Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'availableMinutes': availableMinutes,
      'totalPurchased': totalPurchased,
      'totalSpent': totalSpent,
      'totalAmount': totalAmount,
      'lastPurchase': lastPurchase?.toJson(),
      'pendingCharges': pendingCharges,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Crea desde Map de Firestore
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      userId: json['userId'] as String,
      availableMinutes: json['availableMinutes'] as int? ?? 0,
      totalPurchased: json['totalPurchased'] as int? ?? 0,
      totalSpent: json['totalSpent'] as int? ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      lastPurchase: json['lastPurchase'] != null
          ? LastPurchase.fromJson(json['lastPurchase'] as Map<String, dynamic>)
          : null,
      pendingCharges: json['pendingCharges'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Wallet(userId: $userId, availableMinutes: $availableMinutes, status: $status)';
  }
}

/// Información de la última compra
class LastPurchase {
  final double amount;
  final int minutes;
  final DateTime date;

  LastPurchase({
    required this.amount,
    required this.minutes,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'minutes': minutes,
      'date': date.toIso8601String(),
    };
  }

  factory LastPurchase.fromJson(Map<String, dynamic> json) {
    return LastPurchase(
      amount: (json['amount'] as num).toDouble(),
      minutes: json['minutes'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
