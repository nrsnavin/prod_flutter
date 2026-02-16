import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/PackinglistController.dart';
import 'PackingDetail.dart';

class PackingListByJobPage extends StatelessWidget {
  final controller = Get.put(PackingListController());
  final String jobNo = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.fetchPackingByJob(jobNo);

    return Scaffold(
      appBar: AppBar(title: Text("Job #$jobNo Boxes")),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.packingList.length,
          itemBuilder: (_, index) {
            final pack = controller.packingList[index];

            return Card(
              child: ListTile(
                title: Text(pack.elasticName),
                subtitle: Text("Meters: ${pack.meters}"),
                trailing: Text(pack.serialNo),
                onTap: () {
                  Get.to(() => PackingDetailPage(),
                      arguments: pack.id);
                },
              ),
            );
          },
        );
      }),
    );
  }
}

