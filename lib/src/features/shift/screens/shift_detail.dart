import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/shift_detail.dart';

class ShiftDetailPage extends StatelessWidget {
  final String shiftId;

  ShiftDetailPage({super.key, required this.shiftId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShiftDetailController(shiftId));

    return Scaffold(
      appBar: AppBar(title: const Text("Shift Entry")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: controller.productionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Production (Meters)",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: controller.timerController,
              decoration: const InputDecoration(
                labelText: "Timer (HH:mm:ss)",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: controller.feedbackController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Feedback",
              ),
            ),

            const SizedBox(height: 30),

            Obx(() => ElevatedButton(
              onPressed: controller.isSaving.value
                  ? null
                  : controller.saveShift,
              child: controller.isSaving.value
                  ? const CircularProgressIndicator(
                  color: Colors.white)
                  : const Text("Submit Production"),
            ))
          ],
        ),
      ),
    );
  }
}
