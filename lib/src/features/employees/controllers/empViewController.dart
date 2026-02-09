import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// import 'package:production/src/features/job/models/Machine.dart';

import '../../shiftProgram/models/employee.dart';
import '../models/employee.dart';
import '../models/employeeDetail.dart';
import '../models/employeeList.dart';

class EmpViewController extends GetxController {
  static EmpViewController get find => Get.find();

  RxList<Emplist> empList = (List<Emplist>.of([])).obs;

  var isLoading = true.obs;
   Rx<EmployeeD> employee=EmployeeD(id: "id", name: "name", phone: "phone", department: "department", role: "role",aadhar:"").obs;
  var shifts = <ShiftHistory>[].obs;

  Future<void> fetchEmployeeDetails(String employeeId) async {
    try {
      isLoading.value = true;

      var url = Uri.parse("http://13.233.117.153:2701/api/v2/employee/get-employee-detail?id=$employeeId");
      // var url = Uri.parse("http://10.0.2.2:2701/api/v2/employee/get-employee-detail?id=$employeeId");
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      final Map<String, dynamic> body = json.decode(response.body);

      employee.value = EmployeeD(
        name: body['employee']['name'],
        department: body['employee']['department'],
        id: body['employee']['id'],
        role: body['employee']['role'],
        phone: body['employee']['phoneNumber'],
        aadhar: body['employee']['aadhar']!=null?body['employee']['aadhar']:"Not Found",
      );
      shifts.value = (body['employee']['result'] as List)
          .map((e) => ShiftHistory.fromJson(e))
          .toList();
    } finally {
      isLoading.value = false;
    }
  }

  void getEmps() async {
    var url = Uri.parse("http://13.233.117.153:2701/api/v2/employee/get-employees");
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    final Map<String, dynamic> body = json.decode(response.body);

    var x = body['employees'].map<Emplist>((e) => Emplist.fromJson(e)).toList();

    empList.value = x;
  }
}
