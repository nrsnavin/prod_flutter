class SupplierDropdownModel {
  final String id;
  final String name;

  SupplierDropdownModel({
    required this.id,
    required this.name,
  });

  factory SupplierDropdownModel.fromJson(Map<String, dynamic> json) {
    return SupplierDropdownModel(
      id: json['_id'],
      name: json['name'],
    );
  }
}
