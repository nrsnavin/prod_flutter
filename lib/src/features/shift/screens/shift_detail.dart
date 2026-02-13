import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../controllers/shift_detail.dart';
import '../models/shift_detail_view_model.dart';

class ShiftDetailPage extends StatelessWidget {
  final String shiftId;

  ShiftDetailPage({super.key, required this.shiftId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShiftDetailController(shiftId));

    Widget _entryForm() {
      return Column(
        children: [
          TextField(
            controller: controller.productionController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Production (meters)"),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: controller.timerController,
            decoration: const InputDecoration(labelText: "Run Time (HH:MM:SS)"),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: controller.feedbackController,
            decoration: const InputDecoration(labelText: "Feedback"),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              controller.saveShift();
            },
            child: const Text("Submit Production"),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Shift Entry")),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16),
          child: controller.shift.value != null
              ? Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "${controller.shift.value!.shift} Shift",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Date: ${DateFormat.yMMMEd().format(DateTime.parse(controller.shift.value!.date))}",
                        ),
                        Text(
                          "Operator: ${controller.shift.value!.employeeName}",
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                    controller.shift.value != null
                        ? _machineInfo(controller.shift.value!)
                        : CircularProgressIndicator(),
                    controller.shift.value!.status == "open"
                        ? _entryForm()
                        : _summaryCard(controller.shift.value!),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _machineInfo(ShiftDetailViewModel shift) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Machine: ${shift.machineName}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Job No: ${shift.jobNo}"),
            const SizedBox(height: 10),
            const Text(
              "Running Elastics:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...shift.runningElastics.map((e) => Text("• $e")),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(ShiftDetailViewModel s) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Shift Completed",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 12),

            Text("Production: ${s.production} meters"),
            Text("Run Time: ${s.timer}"),
            Text("Feedback: ${s.feedback}"),
          ],
        ),
      ),
    );
  }
}
