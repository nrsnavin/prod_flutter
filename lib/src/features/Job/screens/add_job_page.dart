import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/add_job_controller.dart';
import '../models/order_model.dart';

class AddJobOrderPage extends StatelessWidget {
  final OrderModel order;

  AddJobOrderPage({required this.order});

  final controller = Get.put(AddJobOrderController());

  @override
  Widget build(BuildContext context) {
    controller.initFromOrder(order);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Job Order")),
      body: Obx(() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Elastic Quantity Planning",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...controller.elasticInputs.map((e) {
            return Card(
              child: ListTile(
                title: Text(e.elasticName),
                subtitle: Text(
                    "Pending: ${e.maxQty.toStringAsFixed(0)}"),
                trailing: SizedBox(
                  width: 100,
                  child: TextField(
                    controller: e.qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Qty",
                    ),
                  ),
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: controller.submitJobOrder,
            child: const Text("Create Job Order"),
          )
        ],
      )),
    );
  }
}
