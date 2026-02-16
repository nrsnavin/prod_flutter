import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class PackingDetailPage extends StatelessWidget {
  final controller = Get.put(PackingDetailController());
  final String packingId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.fetchDetail(packingId);

    return Scaffold(
      appBar: AppBar(title: const Text("Packing Detail")),
      body: Obx(() {
        final p = controller.packing.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              _row("Elastic", p.elasticName),
              _row("Customer", p.customerName),
              _row("PO", p.po),
              _row("Job Order", p.jobOrderNo),
              _row("Serial", p.serialNo),

              const Divider(),

              _row("Meters", p.meters.toString()),
              _row("Joints", p.joints.toString()),
              _row("Stretch", "${p.stretch}%"),

              const Divider(),

              _row("Net Weight",
                  "${p.netWeight} kg"),
              _row("Tare Weight",
                  "${p.tareWeight} kg"),
              _row("Gross Weight",
                  "${p.grossWeight} kg"),

              const Divider(),

              _row("Checked By", p.checkedBy),
              _row("Packed By", p.packedBy),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.openPdf();
                      },
                      child:
                      const Text("Open PDF"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.printPdf();
                      },
                      child:
                      const Text("Print"),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight:
                  FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
