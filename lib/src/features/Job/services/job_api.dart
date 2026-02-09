import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class JobApi {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<void> createOrder(Map<String, dynamic> payload) async {
   final res= await _dio.post("/job/create", data: payload);
   if(res.statusCode==201){
     Get.snackbar("Success", "Job Created");
     Get.back();
   }

  }

  static Future<Map<String,dynamic>> fetchDetail(String id) async {
    final res = await _dio.get(
      "/job/detail",
      queryParameters: {"id": id},
    );
    return res.data["job"];
  }
}
