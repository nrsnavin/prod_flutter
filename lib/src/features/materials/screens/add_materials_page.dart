import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rawMaterial_controller.dart';
import 'dropdown.dart';

class AddRawMaterialPage extends StatefulWidget {
  const AddRawMaterialPage({super.key});

  @override
  State<AddRawMaterialPage> createState() => _AddRawMaterialPageState();
}

class _AddRawMaterialPageState extends State<AddRawMaterialPage> {
  final RawMaterialController controller = Get.put(RawMaterialController());
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final stockCtrl = TextEditingController(text: "0");
  final minStockCtrl = TextEditingController(text: "0");
  final priceCtrl = TextEditingController();

  String category = "warp";
  String? supplierId;

  final categories = [
    "warp",
    "weft",
    "covering",
    "Rubber",
    "Chemicals",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Raw Material")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field("Material Name", nameCtrl),
              const SizedBox(height: 12),

              DropdownButtonFormField(
                value: category,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => category = v!,
              ),

              const SizedBox(height: 12),

              SearchableSupplierDropdown(
                onSelected: (id) => supplierId = id,
              ),

              const SizedBox(height: 12),
              _number("Opening Stock (Kg)", stockCtrl),
              const SizedBox(height: 12),
              _number("Minimum Stock (Kg)", minStockCtrl),
              const SizedBox(height: 12),
              _number("Price / Kg", priceCtrl),

              const SizedBox(height: 24),

              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : _submit,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save"),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }

  Widget _number(String label, TextEditingController c) {
    return TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || supplierId == null) {
      Get.snackbar("Error", "Fill all fields");
      return;
    }

    controller.createRawMaterial({
      "name": nameCtrl.text.trim(),
      "category": category,
      "stock": double.parse(stockCtrl.text),
      "minStock": double.parse(minStockCtrl.text),
      "supplier": supplierId,
      "price": double.parse(priceCtrl.text),
    });
  }
}
