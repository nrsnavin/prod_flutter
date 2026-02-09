import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/covering_list.dart';

class CoveringController extends GetxController {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:2701/api/v2"));
  RxList<CoveringModel> list = <CoveringModel>[].obs;
  RxBool loading = false.obs;
  RxBool hasMore = true.obs;

  RxString status = "open".obs;
  RxString search = "".obs;

  int page = 1;
  final int limit = 20;

  Future<void> fetch({bool reset = false}) async {
    if (loading.value) return;

    if (reset) {
      page = 1;
      list.clear();
      hasMore.value = true;
    }

    if (!hasMore.value) return;

    try {
      loading.value = true;

      final res = await dio.get(
        "/covering/list",
        queryParameters: {
          "status": status.value,
          "search": search.value,
          "page": page,
          "limit": limit,
        },
      );

      final List<dynamic> raw = res.data['data'];
      final pagination = res.data['pagination'];

      final models = raw
          .map((e) => CoveringModel.fromJson(e))
          .toList();

      list.addAll(models);

      hasMore.value = pagination['hasMore'] == true;
      page++;
    } catch (e) {
      debugPrint("Covering fetch error: $e");
    } finally {
      loading.value = false;
    }
  }
}
