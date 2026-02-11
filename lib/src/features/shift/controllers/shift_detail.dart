import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ShiftDetailController extends GetxController {
  final String shiftId;

  ShiftDetailController(this.shiftId);

  var productionController = TextEditingController();
  var timerController = TextEditingController(text: "00:00:00");
  var feedbackController = TextEditingController();
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );


  var isSaving = false.obs;

  Future<void> saveShift() async {
    try {
      isSaving.value = true;

      await _dio.post("/shift/update",data:  {
        "shiftId": shiftId,
        "production": double.parse(productionController.text),
        "timer": timerController.text,
        "feedback": feedbackController.text,
      });

      Get.snackbar("Success", "Shift Updated");
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Failed to update shift");
    } finally {
      isSaving.value = false;
    }
  }
}
