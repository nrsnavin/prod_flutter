import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/shiftPlanDetail.dart';

class ShiftPlanDetailController extends GetxController {
  var isLoading = true.obs;
  var shiftDetail = Rxn<ShiftPlanDetailModel>();

  late String shiftId;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );


  void onInit() {

    shiftId = Get.arguments;
    fetchShiftDetail();
  }

  Future<void> fetchShiftDetail() async {
    try {
      isLoading.value = true;

      final res=await _dio.get("/shift/shiftPlanById/?id=$shiftId");


     final data= ShiftPlanDetailModel.fromJson(res.data['data']);


      shiftDetail.value = data;
    } catch (e) {
      Get.snackbar("Error", "Failed to load shift detail");
    } finally {
      isLoading.value = false;
    }
  }
}
