/// Enums para transacciones
enum TransactionType {
  purchase, // Compra de minutos
  spent, // Gasto de minutos
  refund; // Reembolso

  String toJson() => name;

  static TransactionType fromJson(String json) {
    return TransactionType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => TransactionType.purchase,
    );
  }
}

enum PaymentMethod {
  creditCard,
  debitCard,
  paypal,
  manual;

  String toJson() => name;

  static PaymentMethod fromJson(String json) {
    return PaymentMethod.values.firstWhere(
      (method) => method.name == json,
      orElse: () => PaymentMethod.creditCard,
    );
  }
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded;

  String toJson() => name;

  static PaymentStatus fromJson(String json) {
    return PaymentStatus.values.firstWhere(
      (status) => status.name == json,
      orElse: () => PaymentStatus.pending,
    );
  }
}
