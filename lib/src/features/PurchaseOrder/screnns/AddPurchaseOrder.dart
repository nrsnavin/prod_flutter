import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/purchase_controller.dart';

class AddPurchaseOrderPage extends StatelessWidget {
  final controller = Get.put(PurchaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Purchase Order")),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Supplier Dropdown
            DropdownButtonFormField<String>(
              decoration:
              const InputDecoration(labelText: "Select Supplier"),
              items: controller.suppliers
                  .map((s) => DropdownMenuItem(
                value: s.id,
                child: Text(s.name),
              ))
                  .toList(),
              onChanged: (val) =>
              controller.selectedSupplier.value = val,
            ),

            const SizedBox(height: 20),

            /// Dynamic Raw Material Rows
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (_, index) {
                  final item = controller.items[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                                labelText: "Raw Material"),
                            items: controller.rawMaterials
                                .map((rm) => DropdownMenuItem(
                              value: rm.id,
                              child: Text(rm.name),
                            ))
                                .toList(),
                            onChanged: (val) =>
                            item.rawMaterialId = val,
                          ),

                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Price"),
                            keyboardType:
                            TextInputType.number,
                            onChanged: (val) =>
                            item.price =
                                double.parse(val),
                          ),

                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Quantity (Kg)"),
                            keyboardType:
                            TextInputType.number,
                            onChanged: (val) =>
                            item.quantity =
                                double.parse(val),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),

            ElevatedButton(
              onPressed: controller.addItemRow,
              child: const Text("Add Item"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: controller.createPO,
              child: const Text("Create PO"),
            ),
          ],
        ),
      )),
    );
  }
}
