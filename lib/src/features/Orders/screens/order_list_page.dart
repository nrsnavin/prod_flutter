import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:production/src/features/Orders/screens/add_order_page.dart';
import '../controllers/order_list_controller.dart';
import 'order_detail_page.dart';

class OrderListPage extends StatelessWidget {
  OrderListPage({super.key});
  final c = Get.put(OrderListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() =>  AddOrderPage());
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("Orders")),
      body: Column(
        children: [
          _statusFilter(),
          Expanded(child: _orderList()),
        ],
      ),
    );
  }

  Widget _statusFilter() {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: c.statuses.map((s) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(s),
              selected: c.selectedStatus.value == s,
              onSelected: (_) => c.changeStatus(s),
            ),
          );
        }).toList(),
      ),
    ));
  }

  Widget _orderList() {
    return Obx(() {
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (c.orders.isEmpty) {
        return const Center(child: Text("No orders found"));
      }

      return ListView.builder(
        itemCount: c.orders.length,
        itemBuilder: (_, i) {
          final o = c.orders[i];
          return Card(

            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Order #${o.orderNo}",
                    style:
                    const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${o.customerName}\n"
                        "Order: ${DateFormat('dd MMM yyyy').format(o.date)} | "
                        "Delivery: ${DateFormat('dd MMM yyyy').format(o.supplyDate)}",
                  ),
                  isThreeLine: true,
                  trailing: _statusBadge(o.status),
                  onTap: () {
                    // Get.toNamed("/order-detail", arguments: o.id);
                    Get.to(
                          () => OrderDetailPage(),
                      arguments: {
                        "orderId": o.id,
                      },
                    );
                  },
                ),

                /// 🔘 ACTIONS (ONLY FOR OPEN)
                if (o.status == "Open")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                _confirmCancel(o.id),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                c.approveOrder(o.id),
                            child: const Text("Approve"),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case "Open":
        color = Colors.grey;
        break;
      case "Approved":
        color = Colors.blue;
        break;
      case "InProgress":
        color = Colors.orange;
        break;
      case "Completed":
        color = Colors.green;
        break;
      case "Cancelled":
        color = Colors.red;
        break;
      default:
        color = Colors.black;
    }

    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color),
    );
  }

  void _confirmCancel(String orderId) {
    Get.dialog(
      AlertDialog(
        title: const Text("Cancel Order"),
        content:
        const Text("Are you sure you want to cancel this order?"),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              c.cancelOrder(orderId);
            },
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
