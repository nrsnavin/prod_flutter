import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:production/src/features/production/models/productionBrief.dart';
import 'package:production/src/features/production/models/productionDetail.dart';
import 'package:production/src/features/production/models/productionSummary.dart';

import '../../shiftProgram/models/shiftPlanlModel.dart';

class ProductionViewController extends GetxController {
  RxList<ProductionBrief> productionBriefs = (List<ProductionBrief>.of([])).obs;
  RxList<ProductionSummary> productionSum = (List<ProductionSummary>.of(
    [],
  )).obs;

  var isLoading = true.obs;

  Rx<ShiftPlanModel> dayShiftPLanRX = ShiftPlanModel(


    description: "open",

    shift: "12",
    date: DateTime.now().toString(),
    id: "test",

    production: 0, plan: [],
  ).obs;
  Rx<ShiftPlanModel> nightShiftPLanRX = ShiftPlanModel(

    plan: [],
    description: "open",

    shift: "12",
    date: DateTime.now().toString(),
    id: "test",

    production: 0,
  ).obs;


  static ProductionViewController get find => Get.find();

  void getProductionDetailsInRange(String start, String end) async {
    var url = Uri.parse(
      "http://13.233.117.153:2701/api/v2/shift/get-in-range?start=$start&less=$end",
    );
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    final Map<String, dynamic> body = json.decode(response.body);

    var x = body['array']
        .map<ProductionBrief>((e) => ProductionBrief.fromJson(e))
        .toList();

    productionBriefs.value = x;
  }


  Future<void> getProductionDetailsInDate(String date) async {
    try {
      isLoading.value = true;

      var url = Uri.parse(
        "http://13.233.117.153:2701/api/v2/shift/shiftPlanOnDate?date=$date",
      );
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      final Map<String, dynamic> body = json.decode(response.body);

      final data = body['shift'];

      List<dynamic> x = data
          .map<ShiftPlanModel>((e) => ShiftPlanModel.fromJson(e))
          .toList();

      for (ShiftPlanModel ele in x) {
        if(ele.shift=="DAY"){
          dayShiftPLanRX.value= ele;
        }

        if(ele.shift=="NIGHT"){
          nightShiftPLanRX.value=ele;
        }
      }

      // nightShift.value = data['NIGHT'];

    } catch (e) {
      Get.snackbar('Error', 'Failed to load shift plans');
    } finally {
      isLoading.value = false;
    }
  }
}
