import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:production/src/features/Job/services/job_api.dart';

import '../models/Machine.dart';
import '../models/job_detail.dart';
import '../models/job_detail_mapper.dart';

class JobDetailController extends GetxController {
  Rx<JobDetailView?> job = Rx<JobDetailView?>(null);
  RxBool loading = true.obs;

  final String jobId;

  JobDetailController(this.jobId);

  @override
  void onInit() {
    fetchJob();
    super.onInit();
  }

  bool get isMachineAssigned => job.value?.machineName != null;

  // MachineAssignmentModel? get machineAssignment => job.machineAssignment;



  Future<void> updateStatus(String nextStatus) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Confirm"),
        content: Text("Move job to $nextStatus stage?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await JobApi.updateJobStatus(jobId, nextStatus);

    await fetchJob();
  }


  Future<void> fetchJob() async {
    loading.value = true;

    final res = await JobApi.fetchDetail(jobId);

    job.value = JobDetailViewMapper.fromApi(res as Map<String, dynamic>);
    loading.value = false;
  }

  bool get canPlanWeaving =>
      job.value?.status == "preparatory" &&
          job.value?.warping?.status == "completed" &&
          job.value?.covering?.status == "completed";
}

extension on Future<List<dynamic>> {
  void operator [](String other) {}
}
