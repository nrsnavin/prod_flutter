import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/features/Orders/controllers/api_service.dart';
import '../models/elasticLite.dart';
import '../models/order_elastic_row.dart';


class AddOrderController extends GetxController {
  final orderDate = DateTime.now().obs;
  final supplyDate = DateTime.now().obs;

  final poCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  final customers = <CustomerLite>[].obs;
  final elastics = <ElasticLite>[].obs;

  final selectedCustomer = RxnString();
  final elasticRows = <OrderElasticRow>[].obs;

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
    fetchElastics();
    addElasticRow();
  }

  Future<void> fetchCustomers() async {
    isLoading.value = true;
    try {
      final data = await ApiService.fetchCustomers();
      customers.assignAll(
        data.map((c) => CustomerLite(id: c["_id"], name: c["name"])),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchElastics() async {
    isLoading.value = true;
    try {
      final data = await ApiService.fetchElastics();
      elastics.assignAll(
        data.map((e) => ElasticLite(id: e["_id"], name: e["name"])),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addElasticRow() {
    elasticRows.add(OrderElasticRow());
  }

  void removeElasticRow(int index) {
    elasticRows[index].dispose();
    elasticRows.removeAt(index);
  }

  Map<String, dynamic> buildPayload() {
    return {
      "date": orderDate.value.toIso8601String(),
      "po": poCtrl.text,
      "customer": selectedCustomer.value,
      "supplyDate": supplyDate.value.toIso8601String(),
      "description": descCtrl.text,
      "elasticOrdered": elasticRows
          .where((r) => r.elasticId.value != null)
          .map((r) => {
        "elastic": r.elasticId.value,
        "quantity": int.tryParse(r.qtyCtrl.text) ?? 0,
      })
          .toList(),
    };
  }

  Future<void> submitOrder() async {
    isSubmitting.value = true;
    try {
      await ApiService.createOrder(buildPayload());
      Get.back();
      Get.snackbar("Success", "Order Created");
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    poCtrl.dispose();
    descCtrl.dispose();
    for (final r in elasticRows) {
      r.dispose();
    }
    super.onClose();
  }
}
