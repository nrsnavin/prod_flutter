import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<T?> showSearchablePicker<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required String Function(T) label,
}) {
  final searchCtrl = TextEditingController();
  final filtered = items.obs;

  return Get.bottomSheet<T>(
    Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 12),

          TextField(
            controller: searchCtrl,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search...",
              border: OutlineInputBorder(),
            ),
            onChanged: (v) {
              filtered.value = items
                  .where((e) =>
                  label(e).toLowerCase().contains(v.toLowerCase()))
                  .toList();
            },
          ),

          const SizedBox(height: 12),

          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final item = filtered[i];
                return ListTile(
                  title: Text(label(item)),
                  onTap: () => Get.back(result: item),
                );
              },
            )),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
