import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/PackingModel.dart';

class PackingListController extends GetxController {
  var packingList = <PackingModel>[].obs;

  Future<void> fetchPackingByJob(String jobNo) async {
    final res =
    await ApiService.getPackingByJob(jobNo);

    packingList.value = res
        .map<PackingModel>(
            (e) => PackingModel.fromJson(e))
        .toList();
  }
}
