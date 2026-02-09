import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:production/src/features/Job/services/job_api.dart';

import '../models/order_model.dart';

class ElasticInput {
  final String elasticId;
  final String elasticName;
  final int maxQty;
  final TextEditingController qtyController = TextEditingController();

  ElasticInput({
    required this.elasticId,
    required this.elasticName,
    required this.maxQty,
  });
}

class AddJobOrderController extends GetxController {
  final elasticInputs = <ElasticInput>[].obs;
  late OrderModel order;

  void initFromOrder(OrderModel o) {
    order = o;
    elasticInputs.clear();

    for (final e in o.pendingElastic) {
      if (e.quantity > 0) {
        elasticInputs.add(
          ElasticInput(
            elasticId: e.elasticId,
            elasticName: e.elasticName,
            maxQty: e.quantity,
          ),
        );
      }
    }
  }

  Future<void> submitJobOrder() async {
    final elastics = <Map<String, dynamic>>[];

    for (final e in elasticInputs) {
      final qty = double.tryParse(e.qtyController.text) ?? 0;
      if (qty > 0) {
        if (qty > e.maxQty) {
          Get.snackbar("Error", "Qty exceeds pending for ${e.elasticName}");
          return;
        }
        elastics.add({"elastic": e.elasticId, "quantity": qty});
      }
    }

    if (elastics.isEmpty) {
      Get.snackbar("Error", "Enter at least one elastic quantity");
      return;
    }

    await JobApi.createOrder({
      "orderId": order.id,
      "date": DateTime.now().toIso8601String().split('T')[0],
      "elastics": elastics,
    });



    Get.back();
    Get.snackbar("Success", "Job Order created");
  }
}
