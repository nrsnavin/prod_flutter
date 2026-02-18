class ProductionDayModel {
  final String date;
  final double totalProduction;

  ProductionDayModel({
    required this.date,
    required this.totalProduction,
  });

  factory ProductionDayModel.fromJson(Map<String, dynamic> json) {
    return ProductionDayModel(
      date: json['date'],
      totalProduction: (json['totalProduction'] ?? 0).toDouble(),
    );
  }
}
