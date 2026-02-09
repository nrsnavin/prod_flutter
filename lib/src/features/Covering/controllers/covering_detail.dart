import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' hide Response;
import '../models/covering.dart';

class CoveringDetailController extends GetxController {
  final String coveringId;

  CoveringDetailController(this.coveringId);

  final isLoading = true.obs;
  final error = ''.obs;
  final covering = Rx<CoveringDetailModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCoveringDetail();
  }

  Future<void> fetchCoveringDetail() async {
    try {
      isLoading.value = true;
      error.value = '';

      final res = await ApiService.get(
        "/covering/detail",
        query: {"id": coveringId},
      );

      covering.value = CoveringDetailModel.fromJson(res["covering"]);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }





  final isCompleting = false.obs;

  Future<void> completeCovering() async {
    String? remarks;
    try {
      isCompleting.value = true;

      await ApiService.post(
        "/covering/complete",
        data: {
          "id": coveringId,
          if (remarks != null) "remarks": remarks,
        },
      );

      await fetchCoveringDetail();

      Get.snackbar(
        "Completed",
        "Covering process completed successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCompleting.value = false;
    }
  }


  final isActionLoading = false.obs;

  Future<void> moveToInProgress() async {
    try {
      isActionLoading.value = true;

      await ApiService.post(
        "/covering/start",
        data: {"id": coveringId},
      );

      // 🔄 Refresh page data
      await fetchCoveringDetail();

      Get.snackbar(
        "Success",
        "Covering moved to IN PROGRESS",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isActionLoading.value = false;
    }
  }
}



class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔴 change this
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  /// 🔐 Optional token setter (call after login)
  static void setToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  /// ❌ Remove token on logout
  static void clearToken() {
    _dio.options.headers.remove("Authorization");
  }

  // ======================
  // 🔹 GET
  // ======================
  static Future<Map<String, dynamic>> get(
      String path, {
        Map<String, dynamic>? query,
      }) async {
    try {
      final res = await _dio.get(path, queryParameters: query);
      return _handleResponse(res);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ======================
  // 🔹 POST
  // ======================
  static Future<Map<String, dynamic>> post(
      String path, {
        dynamic data,
      }) async {
    try {
      final res = await _dio.post(path, data: data);
      return _handleResponse(res);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ======================
  // 🔹 PUT
  // ======================
  static Future<Map<String, dynamic>> put(
      String path, {
        dynamic data,
      }) async {
    try {
      final res = await _dio.put(path, data: data);
      return _handleResponse(res);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ======================
  // 🔹 DELETE
  // ======================
  static Future<Map<String, dynamic>> delete(
      String path, {
        Map<String, dynamic>? query,
      }) async {
    try {
      final res = await _dio.delete(path, queryParameters: query);
      return _handleResponse(res);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ======================
  // 🔧 RESPONSE HANDLER
  // ======================
  static Map<String, dynamic> _handleResponse(Response res) {
    if (res.data is Map<String, dynamic>) {
      if (res.data["success"] == false) {
        throw Exception(res.data["message"] ?? "API Error");
      }
      return res.data;
    } else {
      throw Exception("Invalid API response format");
    }
  }

  // ======================
  // 🚨 ERROR HANDLER
  // ======================
  static Exception _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data["message"] != null) {
        return Exception(data["message"]);
      }
      return Exception("Server Error (${e.response?.statusCode})");
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return Exception("Connection timeout");
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return Exception("Receive timeout");
    }

    return Exception("Network error");
  }
}
