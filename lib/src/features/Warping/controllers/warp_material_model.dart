class WarpMaterialModel {
  final String name;
  final int ends;
  final double weight;

  WarpMaterialModel({
    required this.name,
    required this.ends,
    required this.weight,
  });

  factory WarpMaterialModel.fromJson(Map<String, dynamic> json) {
    return WarpMaterialModel(
      name: json['id']['name'],
      ends: json['ends'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
    );
  }
}
