import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/PackingModel.dart';

class PackingListController extends GetxController {
  var packingList = <PackingModel>[].obs;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<void> fetchPackingByJob(String jobNo) async {
    final res =
    await _dio.get("/packing/job/"+jobNo);
    


    packingList.value = res.data['data']
        .map<PackingModel>(
            (e) => PackingModel.fromJson(e))
        .toList();
  }
}
