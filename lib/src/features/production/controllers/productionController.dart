import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:production/src/features/production/models/productionDayModek.dart';

import '../../shiftPlanView/models/shiftSummary.dart';

class ProductionController extends GetxController {
  RxList<ProductionDayModel> days = <ProductionDayModel>[].obs;
  RxList<ShiftSummaryModel> shifts = <ShiftSummaryModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchDateRange(String from, String to) async {
    isLoading.value = true;

    var url = Uri.parse(
      "http://10.0.2.2:2701/api/v2/production/date-range?from=$from&to=$to",
    );
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    final Map<String, dynamic> body = json.decode(response.body);


    days.value = (body["data"] as List)
        .map((e) => ProductionDayModel.fromJson(e))
        .toList();

    isLoading.value = false;
  }

  Future<void> fetchShifts(String date) async {
    isLoading.value = true;


    var url = Uri.parse(
      "http://10.0.2.2:2701/api/v2/production/date?date="+date,
    );
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    final Map<String, dynamic> body = json.decode(response.body);


    shifts.value = (body["data"] as List)
        .map((e) => ShiftSummaryModel.fromJson(e))
        .toList();

    isLoading.value = false;
  }
}
