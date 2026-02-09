import 'dart:async';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/elastic_list_model.dart';
import '../screens/elastic_detail_page.dart';

class ElasticListController extends GetxController {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:2701/api/v2/elastic"));

  RxList<ElasticListModel> elastics = <ElasticListModel>[].obs;

  RxBool loading = false.obs;
  RxBool hasMore = true.obs;

  RxString search = "".obs;

  int page = 1;
  final int limit = 20;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchElastics(reset: true);
  }

  // 🔁 FETCH
  Future<void> fetchElastics({bool reset = false}) async {
    if (loading.value) return;

    if (reset) {
      page = 1;
      hasMore.value = true;
      elastics.clear();
    }

    if (!hasMore.value) return;

    loading.value = true;

    final res = await dio.get(
      "/get-elastics",
      queryParameters: {
        "search": search.value,
        "page": page,
        "limit": limit,
      },
    );

    final List data = res.data["elastics"];

    final fetched =
    data.map((e) => ElasticListModel.fromJson(e)).toList();

    if (fetched.length < limit) {
      hasMore.value = false;
    }

    elastics.addAll(fetched);
    page++;

    loading.value = false;
  }

  // ⏳ DEBOUNCED SEARCH
  void onSearchChanged(String value) {
    search.value = value;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchElastics(reset: true);
    });
  }

  // 📜 LOAD MORE
  void loadMore() {
    if (!loading.value && hasMore.value) {
      fetchElastics();
    }
  }


}
