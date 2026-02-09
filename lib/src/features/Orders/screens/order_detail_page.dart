import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/features/Job/models/order_model.dart';
import 'package:production/src/features/Job/screens/job_detail.dart';
import '../../Job/models/ElasticQtyModel.dart';
import '../../Job/screens/add_job_page.dart';
import '../controllers/order_detail_controller.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final controller = Get.put(OrderDetailController(args["orderId"]));

    return Scaffold(
      appBar: AppBar(title: const Text("Order Detail")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = controller.order.value!;
        final rawMaterials = order["rawMaterialRequired"] ?? [];
        final elastics = order["elastics"] as List<dynamic>;

        return RefreshIndicator(
          onRefresh: controller.fetchOrderDetail,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _header(order),
              const SizedBox(height: 12),
              _elasticTable(elastics),
              _rawMaterialRequired(rawMaterials),
              const SizedBox(height: 16),

              _actionButtons(order["status"], controller),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Job Order"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: order["status"] == "InProgress"
                    ? () {
                        Get.to(
                          () => AddJobOrderPage(
                            order: OrderModel.fromJson(order),
                          ),
                        );
                      }
                    : null,
              ),

              _jobOrders(order["jobs"]),
            ],
          ),
        );
      }),
    );
  }

  /// 🔹 HEADER
  Widget _header(Map order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order #${order["orderNo"]}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Status: ${order["status"]}"),
            Text("PO: ${order["po"]}"),
            Text("Delivery: ${order["deliveryDate"]}"),
          ],
        ),
      ),
    );
  }

  /// 🔹 ELASTIC TABLE
  Widget _elasticTable(List elastics) {
    return Card(
      child: Column(
        children: elastics.map((e) {
          return ListTile(
            title: Text(e["name"]),
            subtitle: Text(
              "Ordered: ${e["ordered"]} | Produced: ${e["produced"]}",
            ),
            trailing: Text("Pending: ${e["pending"]}"),
          );
        }).toList(),
      ),
    );
  }

  /// 🔹 ACTION BUTTONS
  Widget _actionButtons(String status, OrderDetailController c) {
    if (status == "Approved") {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: c.startProduction,
              child: const Text("Start Production"),
            ),
          ),
        ],
      );
    }
    if (status != "Open") return const SizedBox();

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: c.approveOrder,
            child: const Text("Approve"),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  /// 🔹 JOB ORDERS
  Widget _jobOrders(List jobs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Job Orders",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        ...jobs.map(
          (j) => Card(
            child: ListTile(
              title: Text("Job #${j["no"]}"),
              subtitle: Text("ID: ${j["job"]}"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),

              onTap: () {
                Get.to(
                      () => JobDetailPage(),
                  arguments: j["job"]["_id"], // 👈 pass JobOrder _id
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _rawMaterialRequired(List materials) {
    if (materials.isEmpty) {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Raw Material Required",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            ...materials.map((m) {
              final double required = (m["requiredWeight"] ?? 0).toDouble();
              final double inStock = (m["inStock"] ?? 0).toDouble();

              final bool lowStock = inStock < required;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: lowStock ? Colors.red.shade50 : Colors.green.shade50,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m["name"] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("Required: ${required.toStringAsFixed(2)} kg"),
                          Text("In Stock: ${inStock.toStringAsFixed(2)} kg"),
                        ],
                      ),
                    ),

                    if (lowStock)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "LOW",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
