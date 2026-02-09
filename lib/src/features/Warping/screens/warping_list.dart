import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/warping_list.dart';
import 'Warping_detail.dart';

class WarpingListPage extends StatelessWidget {
  final WarpingController c = Get.put(WarpingController());

  final List<String> statuses = [
    "open",
    "in_progress",
    "completed",
    "cancelled"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warping"),
      ),
      body: Column(
        children: [
          _statusTabs(),
          _searchBar(),
          Expanded(child: _list()),
        ],
      ),
    );
  }

  Widget _statusTabs() {
    return Obx(
          () => SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: statuses.map((s) {
            final isSelected = c.statusFilter.value == s;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ChoiceChip(
                label: Text(s.toUpperCase()),
                selected: isSelected,
                onSelected: (_) => c.changeStatus(s),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Search by Job Order No",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: c.onSearch,
      ),
    );
  }

  Widget _list() {
    return Obx(() {
      if (c.isLoading.value && c.warpings.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels >=
              scroll.metrics.maxScrollExtent - 200) {
            c.fetchWarpings();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: c.warpings.length + (c.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= c.warpings.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final w = c.warpings[index];

            return Card(
              child: ListTile(
                title: Text("Job #${w.job.jobOrderNo}"),
                subtitle: Text(
                  "Status: ${w.status}\nDate: ${_formatDate(w.date)}",
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(() => WarpingDetailPage(warpingId: w.id));
                },
              ),
            );
          },
        ),
      );
    });
  }

  String _formatDate(DateTime d) {
    return "${d.day}-${d.month}-${d.year}";
  }
}
