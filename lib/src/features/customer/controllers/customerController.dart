import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:production/src/features/authentication/screens/home.dart';

class CustomerController extends GetxController {
  // Basic
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final gstinCtrl = TextEditingController();
  final contactNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // Purchase
  final purchaseNameCtrl = TextEditingController();
  final purchaseMobileCtrl = TextEditingController();
  final purchaseEmailCtrl = TextEditingController();

  // Accounts
  final accountNameCtrl = TextEditingController();
  final accountMobileCtrl = TextEditingController();
  final accountEmailCtrl = TextEditingController();

  // Merchandiser
  final merchantNameCtrl = TextEditingController();
  final merchantMobileCtrl = TextEditingController();
  final merchantEmailCtrl = TextEditingController();

  final status = "Inactive".obs;
  final paymentTerms = "30".obs;

  final loading = false.obs;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://13.233.117.153:2701/api/v2/customer",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<void> submitCustomer() async {
    try {
      loading.value = true;

      final payload = {
        "name": nameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "gstin": gstinCtrl.text.trim(),
        "status": status.value,
        "contactName": contactNameCtrl.text.trim(),
        "phoneNumber": phoneCtrl.text.trim(),
        "paymentTerms": paymentTerms.value,
        "purchase": {
          "name": purchaseNameCtrl.text.trim(),
          "mobile": purchaseMobileCtrl.text.trim(),
          "email": purchaseEmailCtrl.text.trim(),
        },
        "accountant": {
          "name": accountNameCtrl.text.trim(),
          "mobile": accountMobileCtrl.text.trim(),
          "email": accountEmailCtrl.text.trim(),
        },
        "merchandiser": {
          "name": merchantNameCtrl.text.trim(),
          "mobile": merchantMobileCtrl.text.trim(),
          "email": merchantEmailCtrl.text.trim(),
        },
      };

    final response=await dio.post("/create", data: payload);

    if(response.statusCode==201){
      Get.snackbar("Success", "Customer created successfully");
      Get.to(Home());
    }


    } catch (e) {
      Get.snackbar("Error", "Failed to create customer");
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    gstinCtrl.dispose();
    contactNameCtrl.dispose();
    phoneCtrl.dispose();
    purchaseNameCtrl.dispose();
    purchaseMobileCtrl.dispose();
    purchaseEmailCtrl.dispose();
    accountNameCtrl.dispose();
    accountMobileCtrl.dispose();
    accountEmailCtrl.dispose();
    merchantNameCtrl.dispose();
    merchantMobileCtrl.dispose();
    merchantEmailCtrl.dispose();
    super.onClose();
  }
}




class CustomerListController extends GetxController {
  final customers = <Map<String, dynamic>>[].obs;

  final loading = false.obs;
  final isMoreLoading = false.obs;

  final searchText = "".obs;

  int page = 1;
  final int limit = 20;
  bool hasMore = true;

  Timer? _debounce;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://13.233.117.153:2701/api/v2/customer",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  void onInit() {
    super.onInit();
    fetchCustomers(reset: true);
  }

  void onSearchChanged(String value) {
    searchText.value = value;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      fetchCustomers(reset: true);
    });
  }

  Future<void> fetchCustomers({bool reset = false}) async {
    if (loading.value || isMoreLoading.value) return;

    if (reset) {
      page = 1;
      hasMore = true;
      customers.clear();
    }

    if (!hasMore) return;

    try {
      page == 1 ? loading.value = true : isMoreLoading.value = true;

      final res = await dio.get(
        "/all-customers",
        queryParameters: {
          "page": page,
          "limit": limit,
          "search": searchText.value,
        },
      );

      final List list = res.data['customers'];

      if (list.length < limit) hasMore = false;

      customers.addAll(
        List<Map<String, dynamic>>.from(list),
      );

      page++;
    } catch (e) {
      Get.snackbar("Error", "Failed to load customers");
    } finally {
      loading.value = false;
      isMoreLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
