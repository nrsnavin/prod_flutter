class RawMaterialListModel {
  final String id;
  final String name;
  final String category;
  final double stock;
  final double minStock;
  final double price;

  RawMaterialListModel({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.minStock,
    required this.price,
  });

  factory RawMaterialListModel.fromJson(Map<String, dynamic> json) {
    return RawMaterialListModel(
      id: json['_id'],
      name: json['name'],
      category: json['category'],
      stock: (json['stock'] ?? 0).toDouble(),
      minStock: (json['minStock'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  bool get isLowStock => stock <= minStock;
}
