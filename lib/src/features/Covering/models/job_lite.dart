class JobOrderSummary {
  final String id;
  final int jobOrderNo;
  final String status;
  final OrderSummary? order;
  final String? customerName;

  JobOrderSummary({
    required this.id,
    required this.jobOrderNo,
    required this.status,
    this.order,
    this.customerName,
  });

  factory JobOrderSummary.fromJson(Map<String, dynamic> json) {
    return JobOrderSummary(
      id: json['_id'],
      jobOrderNo: json['jobOrderNo'],
      status: json['status'],
      order: json['order'] != null
          ? OrderSummary.fromJson(json['order'])
          : null,
      customerName: json['customer']?['name'],
    );
  }
}


class OrderSummary {
  final int orderNo;
  final String po;
  final String status;

  OrderSummary({
    required this.orderNo,
    required this.po,
    required this.status,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      orderNo: json['orderNo'],
      po: json['po'],
      status: json['status'],
    );
  }
}
