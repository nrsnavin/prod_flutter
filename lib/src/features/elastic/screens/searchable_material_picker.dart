import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/raw_material.dart';
import '../controllers/add_elastic_controller.dart';

void showMaterialPicker({
  required String title,
  required List<RawMaterialMini> materials,
  required Function(RawMaterialMini) onSelected,
}) {
  final c = Get.find<AddElasticController>();
  c.searchQuery.value = "";

  Get.bottomSheet(
    Container(
      height: Get.height * 0.75,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),

          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search material...",
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => c.searchQuery.value = v,
          ),

          const SizedBox(height: 12),

          Expanded(
            child: Obx(() {
              final filtered = c.filteredMaterials(materials);

              if (filtered.isEmpty) {
                return const Center(child: Text("No materials found"));
              }

              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final m = filtered[i];
                  return ListTile(
                    title: Text(m.name),
                    subtitle: Text("₹${m.price}/kg"),
                    onTap: () {
                      onSelected(m);
                      Get.back();
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
