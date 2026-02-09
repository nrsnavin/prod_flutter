import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:production/src/features/machines/models/machineDetail.dart';

// import 'package:production/src/features/job/models/Machine.dart';

import '../models/machine.dart';
import '../models/machineShiftHistory.dart';

class MachineViewController extends GetxController {
  static MachineViewController get find => Get.find();

  RxList<MachineList> machinesList = (List<MachineList>.of([])).obs;

  var isLoading = true.obs;
  Rx<Machine> machine = Machine(
    machineId: "machineId",
    manufacturer: "manufacturer",
    noOfHeads: 6,
    noOfHooks: 6,
    currentOrder: "currentOrder",
    status: "status",
  ).obs;
  var shifts = <MachineShiftHistory>[].obs;

  void getMachines() async {
    var url = Uri.parse("http://13.233.117.153:2701/api/v2/machine/get-machines");
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    final Map<String, dynamic> body = json.decode(response.body);

    var x = body['machines']
        .map<MachineList>((e) => MachineList.fromJson(e))
        .toList();

    machinesList.value = x;
  }

  void updateOrder(String order,String id) async {
    // var url = Uri.parse("http://10.0.2.2:2701/api/v2/machine/u");

    try{
      final response = await Dio().put(
        'http://13.233.117.153:2701/api/v2/machine/updateOrder',
        data: {
          'id': id,
          'elastics': order
        },
      );
      // final Map<String, dynamic> body =await json.decode(response.data);
      if(response.statusCode==201){
        Get.snackbar("Success", "message");
        fetchMachineDetails(response.data['data']);
        getMachines();
      }
    }
    catch(e){
      Get.snackbar("erroe", e.toString());
    }
    finally{}

  }

  Future<void> fetchMachineDetails(String mId) async {
    try {
      isLoading.value = true;

      var url = Uri.parse("http://13.233.117.153:2701/api/v2/machine/get-machine-detail?id=$mId");

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      final Map<String, dynamic> body = json.decode(response.body);

      machine.value = Machine(
        status: body['machine']['status'] ,
        currentOrder: body['machine']['elastics'],
        machineId: body['machine']['id'] ,
        manufacturer: body['machine']['manufacturer'] ,
        noOfHeads: body['machine']['heads'] ,
        noOfHooks:  body['machine']['hooks'],

      );
      shifts.value = (body['machine']['result'] as List)
          .map((e) => MachineShiftHistory.fromJson(e))
          .toList();
    } finally {
      isLoading.value = false;
    }
  }
}
