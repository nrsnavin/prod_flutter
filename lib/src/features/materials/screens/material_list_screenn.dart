import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/features/materials/screens/material_detail_screen.dart';
import '../controllers/rawMaterial_list_controller.dart';
import 'add_materials_page.dart';
// import '../controllers/raw_material_list_controller.dart';

class RawMaterialListPage extends StatelessWidget {
  RawMaterialListPage({super.key});

  final controller = Get.put(RawMaterialListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Raw Materials"), actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _openFilterSheet(),
        )
      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddRawMaterialPage());
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(child: _list()),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Search material...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (v) => controller.search.value = v,
      ),
    );
  }

  Widget _categoryFilter() {
    return  SizedBox(
      height: 48,

      child: Obx(
        ()=> ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: controller.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (_, i) {

            final cat = controller.categories[i];
            final selected = controller.category.value == cat;

            return ChoiceChip(
              label: Text(controller.categories[i]),
              selected: selected,
              onSelected: (_) {
                controller.category.value = cat;
                controller.fetchMaterials();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _list() {
    return Obx(() {
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.materials.isEmpty) {
        return const Center(child: Text("No materials found"));
      }

      return ListView.builder(
        itemCount: controller.materials.length,
        itemBuilder: (_, i) {
          final m = controller.materials[i];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(m.name),
              subtitle: Text(
                "Stock: ${m.stock} kg • Min: ${m.minStock}",
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("₹${m.price}/kg"),
                  if (m.isLowStock)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "LOW",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    )
                ],
              ),
              onTap: () {
                // 🔜 Navigate to detail/edit page
                Get.to(RawMaterialDetailPage(materialId: m.id),arguments: {"id":m.id});
              },
            ),
          );
        },
      );
    });
  }

  void _openFilterSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Filter Materials",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _categoryDropdown(),

            const SizedBox(height: 12),

            Obx(() => CheckboxListTile(
              title: const Text("Show Low Stock Only"),
              value: controller.tempLowStock.value,
              onChanged: (v) =>
              controller.tempLowStock.value = v ?? false,
            )),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.resetFilters();
                      Get.back();
                    },
                    child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.applyFilters();
                      Get.back();
                    },
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _categoryDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.tempCategory.value,
      decoration: const InputDecoration(
        labelText: "Category",
        border: OutlineInputBorder(),
      ),
      items: controller.categories
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (v) => controller.tempCategory.value = v!,
    ));
  }
}


