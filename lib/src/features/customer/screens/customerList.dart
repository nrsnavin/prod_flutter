import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customerController.dart';
import 'AddCustomer.dart';
import 'customerDetail.dart';


class CustomerListPage extends StatelessWidget {
  CustomerListPage({super.key});

  final CustomerListController controller =
  Get.put(CustomerListController());

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_onScroll);

    return Scaffold(
      appBar: AppBar(title: const Text("Customers")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddCustomerPage()),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(child: _customerList()),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: "Search by name / phone / GSTIN",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _customerList() {
    return Obx(() {
      if (controller.loading.value && controller.customers.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.customers.isEmpty) {
        return const Center(child: Text("No customers found"));
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchCustomers(reset: true),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          itemCount: controller.customers.length +
              (controller.isMoreLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < controller.customers.length) {
              return _CustomerCard(
                customer: controller.customers[index],
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      );
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.fetchCustomers();
    }
  }
}


class _CustomerCard extends StatelessWidget {
  final Map<String, dynamic> customer;

  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    final bool active = customer['status'] == "Active";

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          customer['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Contact: ${customer['contactName']}"),
            Text("Phone: ${customer['phoneNumber']}"),
            Text("Payment: ${customer['paymentTerms']} Days"),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: active ? Colors.green.shade100 : Colors.red.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            customer['status'],
            style: TextStyle(
              color: active ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          later: Get.to(() => CustomerDetailPage(customerId: customer['_id']));
        },
      ),
    );
  }
}
