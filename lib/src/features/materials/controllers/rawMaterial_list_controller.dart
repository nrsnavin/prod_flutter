import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:production/src/features/materials/models/materialList.dart';


class RawMaterialListController extends GetxController {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2:2701/api/v2/materials",
  ));

  RxList<RawMaterialListModel> materials = <RawMaterialListModel>[].obs;
  RxBool loading = false.obs;

  RxString search = "".obs;
  RxString category = "All".obs;
  RxBool lowStockOnly = false.obs;

  RxString tempCategory = "All".obs;
  RxBool tempLowStock = false.obs;


  final categories = [
    "All",
    "warp",
    "weft",
    "covering",
    "Rubber",
    "Chemicals",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMaterials();
    debounce(search, (_) => fetchMaterials(),
        time: const Duration(milliseconds: 400));
  }

  void applyFilters() {
    category.value = tempCategory.value;
    lowStockOnly.value = tempLowStock.value;
    fetchMaterials();
  }

  void resetFilters() {
    tempCategory.value = "All";
    tempLowStock.value = false;

    category.value = "All";
    lowStockOnly.value = false;

    fetchMaterials();
  }

  // Future<void> fetchMaterials() async {
  //   try {
  //     loading.value = true;
  //
  //     final res = await _dio.get(
  //       "/get-raw-materials",
  //       queryParameters: {
  //         "search": search.value,
  //         "category": category.value == "All" ? null : category.value,
  //       },
  //     );
  //
  //     materials.value = (res.data["materials"] as List)
  //         .map((e) => RawMaterialListModel.fromJson(e))
  //         .toList();
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to load raw materials");
  //   } finally {
  //     loading.value = false;
  //   }
  // }

  Future<void> fetchMaterials() async {
    try {
      loading.value = true;

      final Map<String, dynamic> query = {};

      // 🔍 Search
      if (search.value.trim().isNotEmpty) {
        query["search"] = search.value.trim();
      }

      // 🧵 Category
      if (category.value != "All") {
        query["category"] = category.value;
      }

      // ⚠️ Low stock filter
      if (lowStockOnly.value) {
        query["lowStock"] = true;
      }

      final res = await _dio.get(
        "/get-raw-materials",
        queryParameters: query,
      );

      materials.value = (res.data["materials"] as List)
          .map((e) => RawMaterialListModel.fromJson(e))
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Unable to load raw materials");
    } finally {
      loading.value = false;
    }
  }

}
