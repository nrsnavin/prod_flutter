import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:production/src/features/Warping/models/warping_plan_model.dart';

import '../controllers/warping_detail.dart';

class WarpingDetailController extends GetxController {
  final String warpingId;
  WarpingDetailController(this.warpingId);

  final Dio dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:2701/api/v2"));

  final Rx<WarpingDetailModel?> warping = Rx<WarpingDetailModel?>(null);
  final RxBool loading = false.obs;

  RxBool hasPlan = false.obs;
  WarpingPlanModel? plan;


  @override
  void onInit() {
    super.onInit();
    fetchDetail();
  }

  Future<void> startWarping() async {
    await dio.put("/warping/start?id=$warpingId");
    fetchDetail();
  }

  Future<void> completeWarping() async {
    await dio.put("/warping/complete?id=$warpingId");
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      loading.value = true;
      final res = await dio.get("/warping/detail/$warpingId");
      warping.value = WarpingDetailModel.fromJson(res.data['warping']);
    } catch (e) {
      Get.snackbar("Error", "Failed to load warping details");
    } finally {
      loading.value = false;
    }
  }
}
