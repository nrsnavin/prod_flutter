import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:production/src/features/shift/models/shift_detail_view_model.dart';
import 'package:production/src/features/shift/screens/shift_list_page.dart';

class ShiftDetailController extends GetxController {
  final String shiftId;

  ShiftDetailController(this.shiftId);


  @override
  void onInit() {
    fetchDetail();
    super.onInit();
  }

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

  var shift = Rxn<ShiftDetailViewModel>();

  var isSaving = false.obs;

  var isLoading = false.obs;



  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;

      final response = await _dio.get("/shift/shiftDetail?id=$shiftId");

      shift.value =  ShiftDetailViewModel.fromJson(response.data["shift"]);
    } catch (e) {
      Get.snackbar("Error", "Failed to load shifts");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveShift() async {
    try {
      isSaving.value = true;

      await _dio.post(
        "/shift/enter-shift-production",
        data: {
          "id": shiftId,
          "production": int.parse(productionController.text),
          "timer": timerController.text,
          "feedback": feedbackController.text,
        },
      );

      Get.snackbar("Success", "Shift Updated");
      Get.to(ShiftListPage());
    } catch (e) {
      Get.snackbar("Error", "Failed to update shift");
    } finally {
      isSaving.value = false;
    }
  }
}
