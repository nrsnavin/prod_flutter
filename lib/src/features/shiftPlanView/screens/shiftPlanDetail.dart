import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:production/src/features/shiftPlanView/screens/pdf.dart';

import '../controllers/shift_plan_detail_controller.dart';
import '../models/shiftPlanDetail.dart';

class ShiftPlanDetailPage extends StatefulWidget {
  const ShiftPlanDetailPage({super.key});

  @override
  State<ShiftPlanDetailPage> createState() => _ShiftPlanDetailPageState();
}

class _ShiftPlanDetailPageState extends State<ShiftPlanDetailPage> {
  final controller = Get.put(ShiftPlanDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shift Plan Detail"),
        actions: [TextButton(onPressed: () {
          Get.to(()=>ShiftPlanSummaryPdf());
        }, child: Text("View PDF"))],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final shift = controller.shiftDetail.value!;
        return RefreshIndicator(
          onRefresh: controller.fetchShiftDetail,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _headerCard(shift),
              const SizedBox(height: 16),
              _machinesSection(shift),
            ],
          ),
        );
      }),
    );
  }

  Widget _headerCard(ShiftPlanDetailModel shift) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              shift.shift + " SHIFT",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Date: ${DateFormat('dd MMM yyyy').format(shift.date)}"),
            const SizedBox(height: 8),
            Text("Description: ${shift.description}"),
            const Divider(),
            Text(
              "Total Production: ${shift.totalProduction} m",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _machinesSection(ShiftPlanDetailModel shift) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Machines Running",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...shift.machines.map((machine) => _machineCard(machine)),
      ],
    );
  }

  Widget _machineCard(ShiftMachineDetail machine) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(machine.machineName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Job: #${machine.jobOrderNo}"),
            Text("Operator: ${machine.operatorName}"),
            Text("Production: ${machine.production} m"),
            Text("Run Time: ${machine.timer}"),
          ],
        ),
        trailing: Chip(
          label: Text(machine.status),
          backgroundColor: machine.status == "closed"
              ? Colors.green
              : Colors.orange,
        ),
      ),
    );
  }
}
