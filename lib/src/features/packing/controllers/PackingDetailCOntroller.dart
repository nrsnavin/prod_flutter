import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/PackingModel.dart';
import '../screens/pdf.dart';

class PackingDetailController
    extends GetxController {
  var packing =
      PackingModel(
        id: "",
        jobOrderNo: "",
        elasticName: "",
        customerName: "",
        po: "",
        joints: 0,
        meters: 0,
        stretch: 0,
        netWeight: 0,
        tareWeight: 0,
        grossWeight: 0,
        checkedBy: "",
        packedBy: "",
        serialNo: "",
      ).obs;

  Future<void> fetchDetail(String id) async {
    final res =
    await ApiService.getPackingDetail(id);
    packing.value =
        PackingModel.fromJson(res);
  }

  void openPdf() {
    PackingSlipPdf.generate(
      packingId: packing.value.id,
      elasticName: packing.value.elasticName,
      customerName: packing.value.customerName,
      po: packing.value.po,
      jobOrderNo: packing.value.jobOrderNo,
      joints: packing.value.joints,
      checkedBy: packing.value.checkedBy,
      packedBy: packing.value.packedBy,
      meters: packing.value.meters,
      stretch: packing.value.stretch,
      netWeight: packing.value.netWeight,
      tareWeight: packing.value.tareWeight,
      grossWeight: packing.value.grossWeight,
    );
  }

  void printPdf() {
    openPdf();
  }
}
