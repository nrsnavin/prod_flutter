import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/add_wastage_controller.dart';
import '../models/checkingJobModel.dart';

class AddWastagePage extends StatelessWidget {
  final controller = Get.put(AddWastageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Wastage")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => SingleChildScrollView(
          child: Column(
            children: [

              /// 🔹 Job Dropdown
              DropdownButtonFormField<CheckingJobModel>(
                decoration: const InputDecoration(labelText: "Select Job"),
                items: controller.jobs
                    .map((job) => DropdownMenuItem(
                  value: job,
                  child: Text("Job #${job.jobNo}"),
                ))
                    .toList(),
                onChanged: (job) {
                  controller.selectedJob.value = job;
                  controller.fetchOperators(job!.id);
                },
              ),

              const SizedBox(height: 15),

              /// 🔹 Elastic Dropdown
              if (controller.selectedJob.value != null)
                DropdownButtonFormField<String>(
                  decoration:
                  const InputDecoration(labelText: "Select Elastic"),
                  items: controller.selectedJob.value!.elastics
                      .map((e) => DropdownMenuItem(
                    value: e.elasticId,
                    child: Text("Elastic ID: ${e.elasticId}"),
                  ))
                      .toList(),
                  onChanged: (val) =>
                  controller.selectedElastic.value = val,
                ),

              const SizedBox(height: 15),

              /// 🔹 Employee Dropdown
              DropdownButtonFormField<String>(
                decoration:
                const InputDecoration(labelText: "Select Operator"),
                items: controller.operators
                    .map((e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                ))
                    .toList(),
                onChanged: (val) =>
                controller.selectedEmployee.value = val,
              ),

              const SizedBox(height: 15),

              /// 🔹 Quantity
              TextField(
                controller: controller.quantityController,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: "Wastage Quantity"),
              ),

              const SizedBox(height: 15),

              /// 🔹 Penalty
              TextField(
                controller: controller.penaltyController,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: "Penalty Amount"),
              ),

              const SizedBox(height: 15),

              /// 🔹 Reason
              TextField(
                controller: controller.reasonController,
                decoration:
                const InputDecoration(labelText: "Reason"),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: controller.submitWastage,
                child: const Text("Submit Wastage"),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
