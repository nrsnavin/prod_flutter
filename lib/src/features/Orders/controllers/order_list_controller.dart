import 'package:get/get.dart';
import '../models/order_list_item.dart';
import '../services/order_api.dart';

class OrderListController extends GetxController {
  final orders = <OrderListItem>[].obs;

  final statuses = [
    "Open",
    "Approved",
    "InProgress",
    "Completed",
    "Cancelled",
  ];

  final selectedStatus = "Open".obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final data =
      await OrderApi.fetchOrders(selectedStatus.value);

      orders.assignAll(
        data.map((e) => OrderListItem.fromJson(e)).toList(),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to load orders");
    } finally {
      isLoading.value = false;
    }
  }

  void changeStatus(String status) {
    selectedStatus.value = status;
    fetchOrders();
  }

  /// ✅ APPROVE
  Future<void> approveOrder(String id) async {
    try {
      await OrderApi.approveOrder(id);
      Get.snackbar("Success", "Order approved");
      fetchOrders();
    } catch (e) {
      Get.snackbar("Error", "Approval failed");
    }
  }

  /// ❌ CANCEL
  Future<void> cancelOrder(String id) async {
    try {
      await OrderApi.cancelOrder(id);
      Get.snackbar("Success", "Order cancelled");
      fetchOrders();
    } catch (e) {
      Get.snackbar("Error", "Cancel failed");
    }
  }
}
