import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:production/src/features/authentication/screens/home.dart';
import '../models/employee_create.dart';


class EmployeeController extends GetxController {
  var isSaving = false.obs;

  /// 🔹 Add Employee
  Future<void> addEmployee(EmployeeCreate employee) async {
    try {
      isSaving.value = true;

      final response = await Dio().post(
        'http://13.233.117.153:2701/api/v2/employee/create-employee',
        data: employee.toJson(),
      );

      if (response.statusCode == 201 ||
          response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Employee added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Go back to employee list
       Get.to(Home());
      } else {
        Get.snackbar(
          'Error',
          'Failed to add employee',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
