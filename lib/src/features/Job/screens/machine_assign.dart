import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:production/src/features/Job/models/machineSelect.dart';

import '../controllers/weavingPlan_controller.dart';
import '../models/jobElastic.dart';

class WeavingPlanPage extends StatelessWidget {
  final String jobId;
  final controller = Get.put(WeavingPlanController(Get.arguments));

  WeavingPlanPage({
    super.key,
    required List<JobElasticModel> jobElastics,
    required this.jobId,
  }) {
    controller.setJobElastics(jobElastics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weaving Plan")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.machines.isEmpty) {
          return const Center(child: Text("No free machines available"));
        }

        return Column(
          children: [
            _machineDropdown(),
            SizedBox(height: 16,),
            Expanded(child: _headWiseElasticSelection()),

            _saveButton(),
          ],
        );
      }),
    );
  }

  Widget _machineDropdown() {
    return (Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Machine",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<MachineSelectModel>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Machine",
          ),
          items: controller.machines
              .map(
                (m) => DropdownMenuItem<MachineSelectModel>(
                  value: m,
                  child: Text(m.manufacturer),
                ),
              )
              .toList(),
          onChanged: (v) => controller.selectMachine(v!),
        ),
      ],
    ));
  }

  Widget _headWiseElasticSelection() {
    return Obx(() {
      final machine = controller.selectedMachine.value;

      if (machine == null) {
        return const Center(child: Text("Select a machine"));
      }

      if (controller.headElasticMap.length != int.parse(machine.NoOfHeads)) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        itemCount: int.parse(machine.NoOfHeads),
        itemBuilder: (_, index) {
          return DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Select Elastic"),
                items: controller.jobElastics.map((e) {
                  return DropdownMenuItem(value: e.id, child: Text(e.name));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.selectElasticForHead(index, val);
                  }
                },

          );
        },
      );
    });
  }

  /// 🔹 SAVE BUTTON
  Widget _saveButton() {
    return ElevatedButton(
      onPressed: () {
        final payload = controller.buildWeavingPlanPayload();
        print(payload); // send to backend
        controller.submitWeavingPlan();
      },
      child: const Text("Save Weaving Plan"),
    );
  }
}
