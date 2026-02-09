import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/raw_material_detail_controller.dart';
import '../models/RawMaterial.dart';

class RawMaterialDetailPage extends StatelessWidget {
  final String materialId;

  RawMaterialDetailPage({super.key, required this.materialId});

  final controller = Get.put(RawMaterialDetailController());

  @override
  Widget build(BuildContext context) {
    controller.fetchMaterialDetail(materialId);

    return Scaffold(
      appBar: AppBar(title: const Text("Raw Material Detail")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final material = controller.material.value;
        if (material == null) {
          return const Center(child: Text("No data"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoTile("Name", material.name),
              _infoTile("Category", material.category),
              _infoTile("Stock", material.stock.toString()),
              _infoTile("Min Stock", material.minStock.toString()),
              _infoTile("Price", "₹${material.price}"),

              const SizedBox(height: 24),

              const Text(
                "Stock Movements (Last 30)",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              ...material.stockMovements.map(_movementCard).toList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _movementCard(StockMovementModel m) {
    Color color;
    if (m.type == "ORDER_APPROVAL") {
      color = Colors.red.shade50;
    } else {
      color = Colors.green.shade50;
    }

    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(m.type),
        subtitle: Text(
          "${_fmtDate(m.date)} | Qty: ${m.quantity}",
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Balance"),
            Text(
              m.balance.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) {
    return "${d.day}/${d.month}/${d.year}";
  }
}
