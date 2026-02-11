import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/shiftPlan_controller.dart';

class CreateShiftPlanPage extends StatelessWidget {
  CreateShiftPlanPage({super.key});

  final controller = Get.put(CreateShiftPlanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Shift Plan")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _headerSection(),
            const Divider(),
            Expanded(child: _machineList()),
            _saveButton(),
          ],
        );
      }),
    );
  }

  // =========================
  // HEADER
  // =========================

  Widget _headerSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text("Date"),
                  subtitle: Obx(() => Text(
                    controller.formattedDate,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: Get.context!,
                      initialDate: controller.selectedDate.value,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      controller.selectedDate.value = picked;
                    }
                  },
                ),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.shiftType.value,
                  decoration: const InputDecoration(labelText: "Shift Type"),
                  items: const [
                    DropdownMenuItem(value: "DAY", child: Text("DAY")),
                    DropdownMenuItem(value: "NIGHT", child: Text("NIGHT")),
                  ],
                  onChanged: (v) => controller.shiftType.value = v!,
                ),
              ),
            ],
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: "Description",
            ),
            onChanged: (v) => controller.description.value = v,
          ),
        ],
      ),
    );
  }

  // =========================
  // MACHINE LIST
  // =========================

  Widget _machineList() {
    return ListView.builder(
      itemCount: controller.runningMachines.length,
      itemBuilder: (_, index) {
        final m = controller.runningMachines[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text("Machine ${m.machineCode}"),
            subtitle: Text("Job Order #${m.jobOrderNo}"),
            trailing: SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                decoration:
                const InputDecoration(labelText: "Operator"),
                value: controller.machineOperatorMap[m.machineId],
                items: controller.operators
                    .map(
                      (o) => DropdownMenuItem(
                    value: o.id,
                    child: Text(o.name),
                  ),
                )
                    .toList(),
                onChanged: (val) =>
                    controller.setOperator(m.machineId, val,m.jobOrderNo),
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================
  // SAVE BUTTON
  // =========================

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
           controller.saveShiftPlan();

            // 🔜 POST API here
            Get.snackbar("Success", "Shift Plan Created");
          },
          child: const Text("Save Shift Plan"),
        ),
      ),
    );
  }
}
