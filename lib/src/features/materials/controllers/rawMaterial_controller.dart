import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:production/src/features/materials/screens/material_list_screenn.dart';

class RawMaterialController extends GetxController {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2:2701/api/v2/materials",
    headers: {
      "Content-Type": "application/json",
    },
  ));

  RxBool isLoading = false.obs;

  Future<void> createRawMaterial(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;

      final res = await _dio.post(
        "/create-raw-material",
        data: payload,
      );

      if (res.data["success"] == true) {
        Get.snackbar("Success", "Raw Material added");
       Get.off(RawMaterialListPage());
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to add Raw Material");
    } finally {
      isLoading.value = false;
    }
  }
}
