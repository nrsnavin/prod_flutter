class ProductionDetail {
  String date;
  int production;
  String machine;
  String orderNo;
  String employee;
  String shift;
  String id;
  List elastics;
  String machineManufacturer;
  int noOfHeads;

  ProductionDetail(
      {required this.date,
      required this.id,
      required this.production,
      required this.employee,
      required this.shift,
      required this.machine,
      required this.orderNo,
      required this.elastics,
      required this.machineManufacturer,
      required this.noOfHeads});

  factory ProductionDetail.fromJson(Map<String, dynamic> json) {
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
        ProductionDetail(
            date: date,
            production: production,
            machine: machine['ID'],
            orderNo: order['orderNo'].toString(),
            employee: emp['name'],
            id: id,
            shift: shift,
            noOfHeads: machine['NoOfHead'],
            elastics: machine['elastics'].map((e) => e['name']).toList(),
            machineManufacturer: machine['manufacturer']),
      _ => throw const FormatException('Failed to load Job.'),
    };
  }
}
