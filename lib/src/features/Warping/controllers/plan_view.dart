import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/warping_plan_model.dart';
import '../screens/pdf.dart';

class WarpingPlanControllerView extends GetxController {
  /// Reactive loading flag
  final isLoading = false.obs;

  /// Warping Plan (nullable)View
   Rx<WarpingPlanModel> plan = Rx<WarpingPlanModel>(
    WarpingPlanModel(id: "",beams:List.empty(),createdAt: DateTime.now(),jobId: "ads",noOfBeams: 12,warpingId: "asd",remarks: "sad")
  );

  final String warpingId;

  WarpingPlanControllerView(this.warpingId);

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2/warping", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );




  @override
  void onInit() {
    super.onInit();
   loadDate();
  }



  void loadDate() async{
    plan.value=(await fetchPlan(warpingId))!;
  }

  static Future<WarpingPlanModel?> fetchPlan(String warpingId) async {
    final res = await _dio.get("/warpingPlan?id=$warpingId");

    if (res.data["exists"] == true) {
      return WarpingPlanModel.fromJson(res.data["plan"]);
    }
    return null;
  }


  /// 🔹 SAMPLE DATA LOADER
  void loadSamplePlan() {
    isLoading.value = true;

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      plan.value = WarpingPlanModel(
        id: "wp_001",
        warpingId: "warping_123",
        jobId: "JOB-2026-014",
        noOfBeams: 2,
        remarks: "Use same yarn tension across all sections",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        beams: [
          WarpingBeam(
            beamNo: 1,
            totalEnds: 320,
            sections: [
              WarpingBeamSection(
                // sectionNo: 1,
                warpYarnId: "rm_001",
                warpYarnName: "Nylon 70D",
                ends: 120,
              ),
              WarpingBeamSection(
                // sectionNo: 2,
                warpYarnId: "rm_002",
                warpYarnName: "Polyester 150D",
                ends: 200,
              ),
            ],
          ),
          WarpingBeam(
            beamNo: 2,
            totalEnds: 280,
            sections: [
              WarpingBeamSection(
                // sectionNo: 1,
                warpYarnId: "rm_001",
                warpYarnName: "Nylon 70D",
                ends: 160,
              ),
              WarpingBeamSection(
                // sectionNo: 2,
                warpYarnId: "rm_003",
                warpYarnName: "Polyester 100D",
                ends: 120,
              ),
            ],
          ),
        ],
      );

      isLoading.value = false;
    });
  }

  /// 📄 Placeholder for PDF export
  void exportPdf() {
    BeamPlanPdfService.generatePdf(jobOrderNo: plan.value.jobId, beams: plan.value.beams );
    Get.snackbar(
      "PDF",
      "Warping Plan PDF export triggered",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
