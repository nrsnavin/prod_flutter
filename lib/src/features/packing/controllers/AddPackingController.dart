import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../wastage/models/checkingJobModel.dart';
import '../models/JobPaking.dart';

class AddPackingController extends GetxController {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2/packing", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );


  final jobs = <PackingJobModel>[].obs;
  final checkingEmployees = <EmployeeModel>[].obs;
  final packingEmployees = <EmployeeModel>[].obs;

  final selectedJob = Rxn<PackingJobModel>();
  final selectedElastic = Rxn<String>();
  final selectedCheckedBy = Rxn<String>();
  final selectedPackedBy = Rxn<String>();

  final meterController = TextEditingController();
  final jointsController = TextEditingController();
  final tareController = TextEditingController();
  final netController = TextEditingController();
  final grossController = TextEditingController();
  final stretchController = TextEditingController();
  final sizeController = TextEditingController();

  @override
  void onInit() {
    fetchJobs();
    fetchEmployees();
    super.onInit();
  }

  Future<void> fetchJobs() async {
    final res = await _dio.get("/jobs-packing");
    jobs.value = (res.data["jobs"] as List)
        .map((e) => PackingJobModel.fromJson(e))
        .toList();
  }

  Future<void> fetchEmployees() async {
    final checking =
    await _dio.get("/employees-by-department/checking");
    final packing =
    await _dio.get("/employees-by-department/packing");

    checkingEmployees.value = (checking.data["employees"] as List)
        .map((e) => EmployeeModel.fromJson(e))
        .toList();

    packingEmployees.value = (packing.data["employees"] as List)
        .map((e) => EmployeeModel.fromJson(e))
        .toList();
  }

  Future<void> submit() async {
    await _dio.post("/create-packing", data: {
      "job": selectedJob.value!.id,
      "elastic": selectedElastic.value,
      "meter": int.parse(meterController.text),
      "joints": int.parse(jointsController.text),
      "tareWeight": double.parse(tareController.text),
      "netWeight": double.parse(netController.text),
      "grossWeight": double.parse(grossController.text),
      "stretch": stretchController.text,
      "size": sizeController.text,
      "checkedBy": selectedCheckedBy.value,
      "packedBy": selectedPackedBy.value,
    });

    Get.back();
    Get.snackbar("Success", "Packing Added");
  }
}
