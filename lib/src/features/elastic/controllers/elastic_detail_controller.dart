import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../screens/elastic_detail_page.dart';

class ElasticDetailController extends GetxController {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:2701/api/v2/elastic"));

  final String elasticId;

  ElasticDetailController(this.elasticId);

  RxBool loading = true.obs;
  RxMap<String, dynamic> elastic = <String, dynamic>{}.obs;
  RxMap<String, dynamic> costing = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      loading.value = true;

      final res = await dio.get(
        "/get-elastic-detail",
        queryParameters: {"id": elasticId},
      );

      elastic.value = res.data["elastic"];
      costing.value = res.data["elastic"]["costing"] ?? {};
    } finally {
      loading.value = false;
    }
  }

  Future<void> cloneElastic() async {
    final res = await dio.post(
      "/clone-elastic",
      data: {"id": elasticId},
    );

    Get.to(() => ElasticDetailPage(
      elasticId: res.data["elastic"]["_id"],
    ));
  }
}
