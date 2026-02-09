
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../models/warping_detail.dart';



class BeamSection {
  String? warpYarnId;
  int ends;

  BeamSection({
    this.warpYarnId,
    this.ends = 0,
  });


  Map<String, dynamic> toJson() {
    return {
      "warpYarn": warpYarnId, // ObjectId
      "ends": ends,
    };
  }
}

class BeamPlan {
  final int beamNo;
  final RxList<BeamSection> sections;

  BeamPlan({
    required this.beamNo,
    List<BeamSection>? sections,
  }) : sections = (sections ?? []).obs;

  int get totalEnds =>
      sections.fold(0, (sum, s) => sum + s.ends);


  Map<String, dynamic> toJson() {
    return {
      "beamNo": beamNo,
      "totalEnds": totalEnds,
      "sections": sections.map((s) => s.toJson()).toList(),
    };
  }
}

class WarpYarnModel {
  final String id;
  final String name;

  WarpYarnModel({
    required this.id,
    required this.name,
  });

  factory WarpYarnModel.fromJson(Map<String, dynamic> json) {
    return WarpYarnModel(
      id: json['id'],
      name: json['name'],
    );
  }
}



class WarpingApi {

}



class WarpingPlanController extends GetxController {

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:2701/api/v2/warping", // 🔁 CHANGE
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  /// Number of beams selected
  final RxInt beamCount = 1.obs;
  final RxBool isLoading = false.obs;
  final RxBool isContextLoaded = false.obs;
  final RxBool saving = false.obs;


  final RxList<WarpYarnModel> warpYarns = <WarpYarnModel>[].obs;


  /// All beams
  final RxList<BeamPlan> beams = <BeamPlan>[].obs;

  final String jobId;
  final String wId;

  WarpingPlanController(this.jobId,this.wId);

  @override
  void onInit() {
    super.onInit();
     fetchPlanContext();
    _initBeams();
  }

  /// -------------------------
  /// INIT DEFAULT BEAM
  /// -------------------------
  void _initBeams() {
    beams.assignAll([
      BeamPlan(
        beamNo: 1,
        sections: [BeamSection()],
      ),
    ]);
  }



  static Future<Map<String, dynamic>> createPlan(


      Map<String, dynamic> payload) async {
    final res = await _dio.post(
      "/warpingPlan/create",
      data: payload
    );
    return res.data;
  }

  static Future<Map<String, dynamic>> getWarpingDetail(String id) async {
    final res = await _dio.get("/warping/detail/$id");
    return res.data;
  }


  Future<void> submitWarpingPlan() async {
    saving.value = true;
    try {


      final payload = {
        "jobId": jobId,
        "warpingId":wId ,
        "beamCount": beamCount.value,
        "beams": beams.map((b) => b.toJson()).toList(),
      };

      await createPlan(payload);

      Get.back(); // close plan screen

      // 🔄 Refresh warping detail page
      final detailCtrl = Get.find<WarpingDetailController>();
      await detailCtrl.fetchDetail();

      Get.snackbar(
        "Success",
        "Warping plan saved",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      saving.value = false;
    }
  }



  Future<void> fetchPlanContext() async {
    try {
      isLoading.value = true;

      final res = await _dio.get(
        "/plan-context/$jobId",
      );

      final List list = res.data["warpYarns"] ?? [];

      warpYarns.assignAll(
        list.map((e) => WarpYarnModel.fromJson(e)).toList(),
      );

      isContextLoaded.value = true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load warp yarns",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  /// -------------------------
  /// UPDATE BEAM COUNT
  /// -------------------------
  void updateBeamCount(int count) {
    if (count <= 0) return;

    beamCount.value = count;

    beams.assignAll(
      List.generate(
        count,
            (i) => BeamPlan(
          beamNo: i + 1,
          sections: [BeamSection()],
        ),
      ),
    );
  }

  /// -------------------------
  /// ADD SECTION TO BEAM
  /// -------------------------
  void addSection(int beamIndex) {
    beams[beamIndex].sections.add(BeamSection());
  }

  /// -------------------------
  /// REMOVE SECTION
  /// -------------------------
  void removeSection(int beamIndex, int sectionIndex) {
    if (beams[beamIndex].sections.length > 1) {
      beams[beamIndex].sections.removeAt(sectionIndex);
    }
  }

  /// -------------------------
  /// UPDATE SECTION DATA
  /// -------------------------
  void updateWarpYarn(
      int beamIndex,
      int sectionIndex,
      String yarnId,
      ) {
    beams[beamIndex].sections[sectionIndex].warpYarnId = yarnId;
  }

  void updateEnds(
      int beamIndex,
      int sectionIndex,
      int ends,
      ) {
    beams[beamIndex].sections[sectionIndex].ends = ends;
  }

  /// -------------------------
  /// TOTAL ENDS (ALL BEAMS)
  /// -------------------------
  int get totalEnds =>
      beams.fold(0, (sum, b) => sum + b.totalEnds);
}
