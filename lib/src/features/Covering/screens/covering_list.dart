import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/covering_list.dart';
import 'covering_detail.dart';

class CoveringListPage extends StatelessWidget {
  final c = Get.put(CoveringController());

  final statuses = ["open", "in_progress", "completed", "cancelled"];

  @override
  Widget build(BuildContext context) {
    c.fetch(reset: true);

    return Scaffold(
      appBar: AppBar(title: const Text("Covering")),
      body: Column(
        children: [
          _filters(),
          Expanded(child: _list()),
        ],
      ),
    );
  }

  Widget _filters() {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: "Search Job Order No",
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (v) {
            c.search.value = v;
            c.fetch(reset: true);
          },
        ),
        Obx(() => Wrap(
          spacing: 8,
          children: statuses.map((s) {
            return ChoiceChip(
              label: Text(s.toUpperCase()),
              selected: c.status.value == s,
              onSelected: (_) {
                c.status.value = s;
                c.fetch(reset: true);
              },
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _list() {
    return Obx(() => ListView.builder(
      itemCount: c.list.length + (c.hasMore.value ? 1 : 0),
      itemBuilder: (_, i) {
        if (i >= c.list.length) {
          c.fetch();
          return const Center(child: CircularProgressIndicator());
        }

        final item = c.list[i];
        return Card(
          child: ListTile(
            title: Text("Job #${item.jobOrderNo}"),
            subtitle: Text("Status: ${item.status}"),
            onTap: () => Get.to(() => CoveringDetailPage( coveringId: item.id,)),
          ),
        );
      },
    ));
  }
}
