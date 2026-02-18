import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:dio/dio.dart';
import 'package:production/src/features/Job/models/machineSelect.dart';
import 'package:production/src/features/Job/screens/job_list_screen.dart';

import '../models/jobElastic.dart';

class WeavingPlanController extends GetxController {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  final String jobId;
  WeavingPlanController(this.jobId);

  final isLoading = false.obs;
  var isSubmitting = false.obs;
  final errorMessage = "".obs;
  final machines = <MachineSelectModel>[].obs;
  final selectedMachineId = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchFreeMachines();
  }

  Future<void> fetchFreeMachines() async {
    isLoading.value = true;
    final res = await dio.get("/machine/free");
    machines.value = (res.data["machines"] as List)
        .map((e) => MachineSelectModel.fromJson(e))
        .toList();
    isLoading.value = false;
  }


  Rxn<MachineSelectModel> selectedMachine = Rxn<MachineSelectModel>();
  RxList<JobElasticModel> jobElastics = <JobElasticModel>[].obs;

  /// headIndex → selected elasticId
  RxMap<int, String?> headElasticMap = <int, String?>{}.obs;

  /// INIT WITH JOB DATA
  void setJobElastics(List<JobElasticModel> elastics) {
    jobElastics.assignAll(elastics);
  }

  /// ON MACHINE SELECT
  void selectMachine(MachineSelectModel machine) {
    selectedMachine.value = machine;

    /// reset head mapping
    headElasticMap.clear();

    for (int i = 0; i < int.parse(machine.NoOfHeads); i++) {
      headElasticMap[i] = null;
    }
  }

  /// SELECT ELASTIC FOR HEAD
  void selectElasticForHead(int headIndex, String elasticId) {
    headElasticMap[headIndex] = elasticId;
  }

  /// PAYLOAD FOR API
  Map<String, dynamic> buildWeavingPlanPayload() {
    return {
      "machine": selectedMachine.value!.id,
      "headPlan": headElasticMap.entries
          .map((e) => {"head": e.key + 1, "elastic": e.value})
          .toList(),
    };
  }

  Future<void> submitWeavingPlan() async {
    try {
      isSubmitting.value = true;

      final payload = {
        "jobId": jobId,
        "machineId": selectedMachine.value!.id,
        "headElasticMap": headElasticMap.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      };

      final response = await dio.post(
        "/job/plan-weaving",
        data: payload,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Weaving planned successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.to(JobListPage()); // 🔙 go back & refresh
      }
    } catch (e) {
      errorMessage.value = "Failed to plan weaving";
      Get.snackbar(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
