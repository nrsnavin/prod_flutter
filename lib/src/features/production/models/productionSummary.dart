class ProductionSummary {
  String date;
  int production;
  String machine;
  String orderNo;
  String employee;
  String shift;
  String id;

  ProductionSummary(
      {required this.date,
      required this.id,
      required this.production,
      required this.employee,
      required this.shift,
      required this.machine,
      required this.orderNo});

  factory ProductionSummary.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'date': String date,
        '_id': String id,
        'production': int production,
        'machine': Map machine,
        'order': Map order,
        'employee': Map emp,
        'shift': String shift
      } =>
        ProductionSummary(
            date: date,
            production: production,
            machine: machine['ID'],
            orderNo: order['orderNo'].toString(),
            employee: emp['name'],
            id: id,
            shift: shift),
      _ => throw const FormatException('Failed to load Job.'),
    };
  }
}
