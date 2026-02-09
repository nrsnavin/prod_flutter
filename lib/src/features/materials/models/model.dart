
import 'RawMaterial.dart';

class RawMaterialModel {
  final String? id;
  final String name;
  final String category;
  final double stock;
  final double minStock;
  final String supplierId;
  final double price;

  /// 🔥 NEW
  final List<StockMovementModel> stockMovements;

  RawMaterialModel({
    this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.minStock,
    required this.supplierId,
    required this.price,
    this.stockMovements = const [],
  });

  factory RawMaterialModel.fromJson(Map<String, dynamic> json) {
    return RawMaterialModel(
      id: json['_id'],
      name: json['name'],
      category: json['category'],
      stock: (json['stock'] ?? 0).toDouble(),
      minStock: (json['minStock'] ?? 0).toDouble(),
      supplierId: json['supplier'] ?? "",
      price: (json['price'] ?? 0).toDouble(),

      /// 🔥 SAFE PARSING
      stockMovements: (json['stockMovements'] as List<dynamic>?)
          ?.map((e) => StockMovementModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "category": category,
      "stock": stock,
      "minStock": minStock,
      "supplier": supplierId,
      "price": price,
    };
  }
}
