import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/MachineCreate.dart';


class MachineController extends GetxController {
  var isSaving = false.obs;

  /// 🔹 Add Machine
  Future<void> addMachine(MachineCreate machine) async {
    try {
      isSaving.value = true;
      final response = await Dio().post(
        'http://13.233.117.153:2701/api/v2/machine/create-machine',
        data: machine.toJson(),
      );

      if (response.statusCode == 201 ||
          response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Machine added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Go back to machine list
        Get.back(result: true);
      } else {
        Get.snackbar(
          'Error',
          'Failed to add machine',
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
