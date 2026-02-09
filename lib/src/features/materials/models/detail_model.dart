class RawMaterialDetailModel {
  final String id;
  final String name;
  final String category;
  final double stock;
  final double minStock;
  final double price;

  final SupplierMiniModel supplier;
  final DateTime createdAt;
  final DateTime updatedAt;

  RawMaterialDetailModel({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.minStock,
    required this.price,
    required this.supplier,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RawMaterialDetailModel.fromJson(Map<String, dynamic> json) {
    return RawMaterialDetailModel(
      id: json["_id"],
      name: json["name"],
      category: json["category"],
      stock: (json["stock"] ?? 0).toDouble(),
      minStock: (json["minStock"] ?? 0).toDouble(),
      price: (json["price"] ?? 0).toDouble(),
      supplier: SupplierMiniModel.fromJson(json["supplier"]),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  bool get isLowStock => stock <= minStock;
}

class SupplierMiniModel {
  final String id;
  final String name;

  SupplierMiniModel({
    required this.id,
    required this.name,
  });

  factory SupplierMiniModel.fromJson(Map<String, dynamic> json) {
    return SupplierMiniModel(
      id: json["_id"],
      name: json["name"],
    );
  }
}
