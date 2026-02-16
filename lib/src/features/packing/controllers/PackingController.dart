import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PackagingController extends GetxController {
  var groupedJobs = [].obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchGrouped();
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<void> fetchGrouped() async {
    final res = await _dio.get('/packing/grouped');
    

    groupedJobs.value = res.data;
  }
}
