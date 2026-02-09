import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/detail_model.dart';
import '../models/model.dart';
// import '../models/raw_material_detail_model.dart';

class RawMaterialDetailController extends GetxController {


  final Dio dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2:2701/api/v2/materials",
  ));

  RxBool isLoading = false.obs;
  Rxn<RawMaterialModel> material = Rxn();

  @override
  void onInit() {
    super.onInit();

  }

  Future<void> fetchMaterialDetail(String id) async {
    try {
      isLoading.value = true;

      final res = await dio.get("/get-raw-material-detail",queryParameters: {
        "id":id
      });

      material.value =
          RawMaterialModel.fromJson(res.data["material"]);
    } catch (e) {
      Get.snackbar("Error", "Failed to load material");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMaterial(String id) async {
    await dio.delete(
      "/delete-raw-material",
      queryParameters: {"id": id},
    );
    Get.back(result: true);
  }
}
