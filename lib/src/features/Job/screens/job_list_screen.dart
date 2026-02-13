import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/job_list_controller.dart';
import 'LiveDot.dart';
import 'job_detail.dart';

class JobListPage extends StatelessWidget {
  final controller = Get.put(JobListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jobs")),
      body: Column(
        children: [
          /// 🔎 Search
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller.searchController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Search Job Number",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: controller.searchJob,
            ),
          ),

          /// 🔘 Status Filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _statusChip("all"),
                _statusChip("preparatory"),
                _statusChip("weaving"),
                _statusChip("finishing"),
                _statusChip("checking"),
                _statusChip("packing"),
                _statusChip("completed"),
              ],
            ),
          ),

          /// 📋 Job List
          Expanded(
            child: Obx(() {
              if (controller.jobs.isEmpty) {
                return const Center(child: Text("No Jobs Found"));
              }

              return ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.jobs.length,
                itemBuilder: (_, index) {
                  final job = controller.jobs[index];

                  return GestureDetector(
                    onDoubleTap: () {
                      Get.to(() => JobDetailPage(), arguments: job.id);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text("Job #${job.jobNo}"),
                        subtitle: Text(job.customerName),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _statusBadge(job.status),
                            const SizedBox(height: 4),
                            if (job.machineId != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Machine ${job.machineId}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          /// Loading Indicator
          Obx(
            () => controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: ChoiceChip(
          label: Text(status),
          selected: controller.selectedStatus.value == status,
          onSelected: (_) => controller.changeStatus(status),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    bool isLive = false;

    switch (status) {
      case "weaving":
        color = Colors.blue;
        isLive = true;
        break;
      case "finishing":
        color = Colors.orange;
        isLive = true;
        break;
      case "checking":
        color = Colors.purple;
        isLive = true;
        break;
      case "packing":
        color = Colors.teal;
        isLive = true;
        break;
      case "completed":
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLive) ...[LiveDot(color: color), const SizedBox(width: 6)],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(status, style: TextStyle(color: color)),
        ),
      ],
    );
  }
}
