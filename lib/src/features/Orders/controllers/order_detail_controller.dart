import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class OrderDetailController extends GetxController {
  final String orderId;
  OrderDetailController(this.orderId);

  final Dio dio = Dio();

  /// STATE
  var isLoading = true.obs;
  var order = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    fetchOrderDetail();
    super.onInit();
  }

  /// 📦 FETCH ORDER DETAIL
  Future<void> fetchOrderDetail() async {
    try {
      isLoading.value = true;

      final res = await dio.get(
        "http://10.0.2.2:2701/api/v2/order/get-orderDetail",
        queryParameters: {"id": orderId},
      );

      order.value = res.data["data"];

    } catch (e) {
      Get.snackbar("Error", "Failed to load order");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ APPROVE ORDER
  Future<void> approveOrder() async {
    try {
      isLoading.value = true;
      await dio.post(
        "http://10.0.2.2:2701/api/v2/order/approve",
        data: {"orderId": orderId},
      );

      Get.snackbar(
        "Order Approved",
        "Raw materials consumed successfully",
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      await fetchOrderDetail();
    } catch (e) {
      Get.snackbar("Error", "Approval failed");
    }finally {
      isLoading.value = false;
    }
  }

  /// ❌ CANCEL ORDER
  Future<void> startProduction() async {
    try {

      await dio.post(
        "http://10.0.2.2:2701/api/v2/order/startProduction",
        data: {"orderId": orderId},
      );

      Get.snackbar("Order", "Inprogress");
      await fetchOrderDetail();
    } catch (e) {
      Get.snackbar("Error", "Cancel failed");
    }
  }
}
