import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:production/src/features/shift/screens/shift_detail.dart';

import '../controllers/shift_list_controller.dart';



class ShiftListPage extends StatelessWidget {
  final controller = Get.put(ShiftControllerView());

  ShiftListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Open Shifts")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.shifts.isEmpty) {
          return const Center(child: Text("No open shifts"));
        }

        return ListView.builder(
          itemCount: controller.shifts.length,
          itemBuilder: (_, index) {
            final shift = controller.shifts[index];

            return Card(
              child: ListTile(
                title: Text("Machine: ${shift.machineName}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Operator: ${shift.operatorName}"),
                    Text("Job: ${shift.jobNo}"),
                    Text("Date: ${DateFormat.yMMMEd().format(shift.date)}"),
                    Text("Shift: ${shift.shift}"),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(() => ShiftDetailPage(shiftId: shift.id));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
