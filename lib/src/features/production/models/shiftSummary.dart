class ShiftSummaryModel {
  final String id;
  final String shift;
  final double totalProduction;
  final int machineCount;

  ShiftSummaryModel({
    required this.id,
    required this.shift,
    required this.totalProduction,
    required this.machineCount,
  });

  factory ShiftSummaryModel.fromJson(Map<String, dynamic> json) {
    return ShiftSummaryModel(
      id: json['id'],
      shift: json['shift'],
      totalProduction: (json['totalProduction'] ?? 0).toDouble(),
      machineCount: json['machineCount'] ?? 0,
    );
  }
}
