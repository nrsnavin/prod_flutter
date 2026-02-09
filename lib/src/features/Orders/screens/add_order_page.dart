import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:production/src/features/Orders/screens/searchable_picker.dart';

import '../controllers/add_order_controller.dart';
import '../models/elasticLite.dart';


class AddOrderPage extends StatelessWidget {
  AddOrderPage({super.key});
  final c = Get.put(AddOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Order")),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _section("Order Info"),
            _dateTile(context, "Order Date", c.orderDate),
            TextField(
              controller: c.poCtrl,
              decoration: const InputDecoration(labelText: "PO Number"),
            ),
            _dateTile(context, "Supply Date", c.supplyDate),

            const SizedBox(height: 16),

            _section("Customer"),
            _searchField<CustomerLite>(
              context,
              label: "Select Customer",
              value: c.selectedCustomer,
              items: c.customers,
              display: (c) => c.name,
            ),

            const SizedBox(height: 16),

            _section("Elastics"),
            Obx(() => Column(
              children: List.generate(c.elasticRows.length, (i) {
                final row = c.elasticRows[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _searchField<ElasticLite>(
                          context,
                          label: "Elastic",
                          value: row.elasticId,
                          items: c.elastics,
                          display: (e) => e.name,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: row.qtyCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: "Quantity"),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                                c.removeElasticRow(i),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            )),
            TextButton.icon(
              onPressed: c.addElasticRow,
              icon: const Icon(Icons.add),
              label: const Text("Add Elastic"),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: c.isSubmitting.value ? null : c.submitOrder,
              child: const Text("Create Order"),
            ),
          ],
        ),
      )),
    );
  }

  Widget _section(String title) => Text(
    title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  Widget _dateTile(
      BuildContext ctx, String label, Rx<DateTime> date) {
    return ListTile(
      title: Text(label),
      subtitle:
      Obx(() => Text(DateFormat("dd MMM yyyy").format(date.value))),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final d = await showDatePicker(
          context: ctx,
          initialDate: date.value,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (d != null) date.value = d;
      },
    );
  }

  Widget _searchField<T>(
      BuildContext context, {
        required String label,
        required RxnString value,
        required List<T> items,
        required String Function(T) display,
      }) {
    return InkWell(
      onTap: () async {
        final selected = await showSearchablePicker<T>(
          context: context,
          title: label,
          items: items,
          label: display,
        );
        if (selected != null) {
          value.value = (selected as dynamic).id;
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Obx(() {
          final sel = items
              .cast<dynamic>()
              .firstWhereOrNull((e) => e.id == value.value);
          return Text(sel != null ? display(sel) : "Tap to select");
        }),
      ),
    );
  }
}
