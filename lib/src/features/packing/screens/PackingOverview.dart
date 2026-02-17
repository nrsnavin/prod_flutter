import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:production/src/features/packing/screens/AddPacking.dart';

import '../controllers/PackingController.dart';
import 'PackingListByJob.dart';

class PackagingOverviewPage extends StatelessWidget {
  final controller = Get.put(PackagingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Text("+"),
          
          onPressed: (){Get.to(AddPackingPage());}),
      appBar: AppBar(title: const Text("Packaging Overview")),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.groupedJobs.length,
          itemBuilder: (_, index) {
            final job = controller.groupedJobs[index];

            return Card(
              child: ListTile(
                title: Text("Job #${job["jobOrderNo"]}"),
                subtitle: Text(
                    "Total Boxes: ${job["totalBoxes"]}"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(() => PackingListByJobPage(),
                      arguments: job["id"]);
                },
              ),
            );
          },
        );
      }),
    );
  }
}


