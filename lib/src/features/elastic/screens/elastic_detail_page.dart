import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/elastic_detail_controller.dart';
import 'addElastic.dart';

class ElasticDetailPage extends StatelessWidget {
  final String elasticId;

  const ElasticDetailPage({super.key, required this.elasticId});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ElasticDetailController(elasticId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Elastic Detail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Get.to(() => AddElasticPage(
                cloneData: c.elastic.value,
              ));
            },
          )

        ],
      ),
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final e = c.elastic;
        final costing = c.costing;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _section("Basic Info", [
                _row("Name", e["name"]),
                _row("Weave Type", e["weaveType"]),
                _row("Pick", e["pick"].toString()),
                _row("Hooks", e["noOfHook"].toString()),
                _row("Weight", "${e["weight"]} gm"),
              ]),

              _section("Spandex", [
                _row("Warp Spandex",
                    e["warpSpandex"]?["id"]?["name"] ?? ""),
                _row("Covering",
                    e["spandexCovering"]?["id"]?["name"] ?? ""),
              ]),

              _section("Warp Yarn", [
                ...(e["warpYarn"] as List).map((w) {
                  return _row(
                    w["id"]["name"],
                    "${w["weight"]} gm",
                  );
                }).toList(),
              ]),

              _section("Weft Yarn", [
                _row(
                  e["weftYarn"]?["id"]?["name"] ?? "",
                  "${e["weftYarn"]?["weight"]} gm",
                ),
              ]),

              _section("Testing Parameters", [
                _row("Width", e["testingParameters"]?["width"]?.toString()),
                _row("Elongation",
                    e["testingParameters"]?["elongation"]?.toString()),
                _row("Recovery",
                    e["testingParameters"]?["recovery"]?.toString()),
              ]),

              _section("Costing", [
                _row("Material Cost",
                    "₹${costing["materialCost"] ?? 0}"),
                _row("Conversion Cost",
                    "₹${costing["conversionCost"] ?? 0}"),
                _row("Total Cost",
                    "₹${costing["totalCost"] ?? 0}"),
              ]),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Get.to(() => AddElasticPage(editData: c.elastic));
        },
        icon: const Icon(Icons.edit),
        label: const Text("Edit"),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value ?? "-", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
