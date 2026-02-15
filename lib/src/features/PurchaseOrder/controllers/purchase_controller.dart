import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../materials/models/model.dart';
import '../models/Supplier.dart';


class PurchaseController extends GetxController {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  var suppliers = <SupplierModel>[].obs;
  var rawMaterials = <RawMaterialModel>[].obs;

  var selectedSupplier = RxnString();
  var items = <PurchaseItemRow>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    fetchSuppliers();
    fetchRawMaterials();
    super.onInit();
  }

  Future<void> fetchSuppliers() async {
    final res = await _dio.get("/suppliers");
    suppliers.value = (res.data["data"] as List)
        .map((e) => SupplierModel.fromJson(e))
        .toList();
  }

  Future<void> fetchRawMaterials() async {
    final res = await _dio.get("/raw-materials");
    rawMaterials.value = (res.data["data"] as List)
        .map((e) => RawMaterialModel.fromJson(e))
        .toList();
  }

  void addItemRow() {
    items.add(PurchaseItemRow());
  }

  void removeItemRow(int index) {
    items.removeAt(index);
  }

  Future<void> createPO() async {
    if (selectedSupplier.value == null) {
      Get.snackbar("Error", "Select Supplier");
      return;
    }

    final body = {
      "supplier": selectedSupplier.value,
      "items": items.map((e) => e.toJson()).toList(),
    };

    isLoading.value = true;
    await _dio.post("/create-po", data:body);
    isLoading.value = false;

    Get.snackbar("Success", "Purchase Order Created");
    Get.back();
  }
}

class PurchaseItemRow {
  String? rawMaterialId;
  double price = 0;
  double quantity = 0;

  Map<String, dynamic> toJson() => {
    "rawMaterial": rawMaterialId,
    "price": price,
    "quantity": quantity,
  };
}
