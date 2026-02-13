import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/checkingJobModel.dart';

class AddWastageController extends GetxController {
  final jobs = <CheckingJobModel>[].obs;
  final operators = <EmployeeModel>[].obs;

  final selectedJob = Rxn<CheckingJobModel>();
  final selectedElastic = Rxn<String>();
  final selectedEmployee = Rxn<String>();

  final quantityController = TextEditingController();
  final penaltyController = TextEditingController();
  final reasonController = TextEditingController();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  void onInit() {
    fetchJobs();
    super.onInit();
  }

  Future<void> fetchJobs() async {
    final res = await _dio.get("/job/jobs-checking");
    jobs.value = (res.data["jobs"] as List)
        .map((e) => CheckingJobModel.fromJson(e))
        .toList();
  }

  Future<void> fetchOperators(String jobId) async {
    final res = await _dio.get("/job/job-operators/$jobId");
    operators.value = (res.data["operators"] as List)
        .map((e) => EmployeeModel.fromJson(e))
        .toList();
  }

  Future<void> submitWastage() async {
    await _dio.post(
      "/create-wastage",
      data: {
        "job": selectedJob.value!.id,
        "elastic": selectedElastic.value,
        "employee": selectedEmployee.value,
        "quantity": int.parse(quantityController.text),
        "penalty": double.parse(penaltyController.text),
        "reason": reasonController.text,
      },
    );

    Get.back();
    Get.snackbar("Success", "Wastage Added");
  }
}
