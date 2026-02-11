import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../../shiftProgram/models/machine_model.dart';

class CreateShiftPlanController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final shiftType = "DAY".obs;
  final description = "".obs;

  final runningMachines = <MachineRunningModel>[].obs;
  final operators = <OperatorModel>[].obs;
  final machineOperatorMap = <String, String?>{}.obs;

  /// machineId -> jobId
  final RxMap<String, String?> jobMap = <String, String>{}.obs;

  final isLoading = false.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;

    runningMachines.value = await ShiftApiService.fetchRunningMachines();

    for (var m in runningMachines) {
      machineOperatorMap[m.machineId] = null;
      jobMap[m.machineId]=null;
    }

    operators.value = await ShiftApiService.fetchOperators();
    isLoading.value = false;
  }

  Future<void> saveShiftPlan() async {


    isSaving.value = true;

    try {
      await ShiftApiService.createShiftPlan({
        "date": DateUtils.dateOnly(selectedDate.value).toIso8601String(),
        "shiftType": shiftType.value,
        "description": description.value,
        "machines": machineOperatorMap.entries.map((e) {
          final m = runningMachines.firstWhere((x) => x.machineId == e.key);
          return {
            "machine": e.key,
            "jobOrderNo": int.parse(m.jobOrderNo),
            "operator": e.value,
          };
        }).toList(),
      });

      Get.back();
      Get.snackbar("Success", "Shift plan created");
    } catch (e) {
      if (e.toString().contains("409")) {
        Get.snackbar(
          "Duplicate Shift",
          "Shift already exists for selected date & shift",
        );
      } else {
        Get.snackbar("Error", "Failed to create shift plan");
      }
    } finally {
      isSaving.value = false;
    }
  }

  String get formattedDate =>
      DateFormat("dd MMM yyyy").format(selectedDate.value);

  void setOperator(String machineId, String? operatorId, String jobNo) {
    machineOperatorMap[machineId] = operatorId;
    jobMap[machineId] = jobNo;
  }

  bool validate() {
    return !(machineOperatorMap.values.any((e) => e == null) ||
        jobMap.values.any((e) => e == null));
  }
}

class ShiftApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<List<MachineRunningModel>> fetchRunningMachines() async {
    final res = await dio.get("/machine/running-machines");
    return (res.data["data"] as List)
        .map((e) => MachineRunningModel.fromJson(e))
        .toList();
  }

  static Future<List<OperatorModel>> fetchOperators() async {
    final res = await dio.get("/employee/get-employee-weave");
    return (res.data["employees"] as List)
        .map((e) => OperatorModel.fromJson(e))
        .toList();
  }

  static Future<void> createShiftPlan(Map<String, dynamic> body) async {
    await dio.post("/shift/create-shift-plan", data: body);
  }
}
