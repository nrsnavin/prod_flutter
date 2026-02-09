import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../models/warping_list.dart';

class WarpingController extends GetxController {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:2701/api/v2"));

  final RxList<WarpingModel> warpings = <WarpingModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;

  final RxString statusFilter = "open".obs;
  final RxString searchQuery = "".obs;

  int page = 1;
  final int limit = 20;

  @override
  void onInit() {
    super.onInit();
    fetchWarpings(reset: true);
  }

  Future<void> fetchWarpings({bool reset = false}) async {
    if (isLoading.value) return;

    if (reset) {
      page = 1;
      hasMore.value = true;
      warpings.clear();
    }

    if (!hasMore.value) return;

    try {
      isLoading.value = true;

      final res = await dio.get(
        "/warping/list",
        queryParameters: {
          "status": statusFilter.value,
          "search": searchQuery.value,
          "page": page,
          "limit": limit,
        },
      );

      final List data = res.data['data'];
      final pagination = res.data['pagination'];

      warpings.addAll(
        data.map((e) => WarpingModel.fromJson(e)).toList(),
      );

      hasMore.value = pagination['hasMore'];
      page++;
    } catch (e) {
      Get.snackbar("Error", "Failed to load warpings");
    } finally {
      isLoading.value = false;
    }
  }

  void changeStatus(String status) {
    statusFilter.value = status;
    fetchWarpings(reset: true);
  }

  void onSearch(String value) {
    searchQuery.value = value;
    fetchWarpings(reset: true);
  }
}
