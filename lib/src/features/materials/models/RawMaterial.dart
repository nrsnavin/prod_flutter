class StockMovementModel {
  final DateTime date;
  final String type; // ORDER_APPROVAL, PO_INWARD, ADJUSTMENT
  final String? orderId;
  final int? orderNo;
  final double quantity;
  final double balance;

  StockMovementModel({
    required this.date,
    required this.type,
    this.orderId,
    this.orderNo,
    required this.quantity,
    required this.balance,
  });

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    return StockMovementModel(
      date: DateTime.parse(json['date']),
      type: json['type'],
      orderId: json['order'] is Map
          ? json['order']['_id']
          : json['order'],
      orderNo: json['order'] is Map
          ? json['order']['orderNo']
          : null,
      quantity: (json['quantity'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}

