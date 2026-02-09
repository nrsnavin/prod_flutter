import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/elastic_list_controller.dart';
import 'addElastic.dart';
import 'elastic_detail_page.dart';

class ElasticListPage extends StatelessWidget {
  final c = Get.put(ElasticListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddElasticPage());
        },
        icon: const Icon(Icons.edit),
        label: const Text("Add Elastic"),
      ),
      appBar: AppBar(title: const Text("Elastics")),
      body: Column(
        children: [
          // 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search elastic...",
                border: OutlineInputBorder(),
              ),
              onChanged: c.onSearchChanged,
            ),
          ),

          // 📋 LIST
          Expanded(
            child: Obx(() {
              if (c.elastics.isEmpty && c.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (c.elastics.isEmpty) {
                return const Center(child: Text("No elastics found"));
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scroll) {
                  if (scroll.metrics.pixels ==
                      scroll.metrics.maxScrollExtent) {
                    c.loadMore();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: c.elastics.length +
                      (c.hasMore.value ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == c.elastics.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: CircularProgressIndicator()),
                      );
                    }

                    final e = c.elastics[i];

                    return ListTile(
                      title: Text(e.name),
                      subtitle: Text("Weave: ${e.weaveType}"),

                      onTap: () {
                        Get.to(() => ElasticDetailPage(elasticId: e.id));
                      },
                    );

                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
