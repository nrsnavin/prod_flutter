import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/AddPackingController.dart';
import '../models/JobPaking.dart';

class AddPackingPage extends StatelessWidget {
  final controller = Get.put(AddPackingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Packing Details")),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Job Dropdown
            DropdownButtonFormField<PackingJobModel>(
              decoration: const InputDecoration(labelText: "Select Job"),
              items: controller.jobs
                  .map((job) => DropdownMenuItem(
                value: job,
                child: Text("Job #${job.jobNo}"),
              ))
                  .toList(),
              onChanged: (val) =>
              controller.selectedJob.value = val,
            ),

            const SizedBox(height: 15),

            /// Elastic Dropdown
            if (controller.selectedJob.value != null)
              DropdownButtonFormField<String>(
                decoration:
                const InputDecoration(labelText: "Select Elastic"),
                items: controller.selectedJob.value!.elastics
                    .map((e) => DropdownMenuItem(
                  value: e.elasticId,
                  child: Text(e.name),
                ))
                    .toList(),
                onChanged: (val) =>
                controller.selectedElastic.value = val,
              ),

            const SizedBox(height: 20),

            _field("Meter", controller.meterController),
            _field("Joints", controller.jointsController),
            _field("Tare Weight", controller.tareController),
            _field("Net Weight", controller.netController),
            _field("Gross Weight", controller.grossController),
            _field("Stretch", controller.stretchController),
            _field("Size", controller.sizeController),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              decoration:
              const InputDecoration(labelText: "Checked By"),
              items: controller.checkingEmployees
                  .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text(e.name),
              ))
                  .toList(),
              onChanged: (val) =>
              controller.selectedCheckedBy.value = val,
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              decoration:
              const InputDecoration(labelText: "Packed By"),
              items: controller.packingEmployees
                  .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text(e.name),
              ))
                  .toList(),
              onChanged: (val) =>
              controller.selectedPackedBy.value = val,
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: controller.submit,
              child: const Text("Submit Packing"),
            )
          ],
        ),
      )),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
