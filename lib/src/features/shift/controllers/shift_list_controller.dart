import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/shiftModel.dart';

class ShiftControllerView extends GetxController {
  var shifts = <ShiftModel>[].obs;
  var isLoading = false.obs;
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  void onInit() {
    fetchOpenShifts();
    super.onInit();
  }

  Future<void> fetchOpenShifts() async {
    try {
      isLoading.value = true;

      final response = await _dio.get("/shift/open");

      shifts.value = (response.data["shifts"] as List)
          .map((e) => ShiftModel.fromJson(e))
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to load shifts");
    } finally {
      isLoading.value = false;
    }
  }
}
