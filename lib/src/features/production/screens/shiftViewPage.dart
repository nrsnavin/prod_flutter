import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../shiftPlanView/screens/shiftPlanDetail.dart';
import '../controllers/productionController.dart';

class ShiftDayViewPage extends StatelessWidget {
  final controller = Get.put(ProductionController());
  final String date = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.fetchShifts(date);

    return Scaffold(
      appBar: AppBar(title: Text("Shifts - $date")),
      body: Obx(() => ListView.builder(
        itemCount: controller.shifts.length,
        itemBuilder: (_, index) {
          final shift = controller.shifts[index];

          return Card(
            child: ListTile(
              title: Text("${shift.shift} SHIFT"),
              subtitle: Text(
                "Production: ${shift.production} m\n"
                    "Machines: ${shift.runningMachines}",
              ),
              onTap: () {
                Get.to(
                      () => ShiftPlanDetailPage(),
                  arguments: shift.id,
                );
              },
            ),
          );
        },
      )),
    );
  }
}
