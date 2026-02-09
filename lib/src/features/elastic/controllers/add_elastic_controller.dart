import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/cost.dart';
import '../models/raw_material.dart';
import '../models/warp_yarn_input.dart';
// import '../models/raw_material_mini.dart';
// import '../models/warp_yarn_row.dart';

class AddElasticController extends GetxController {
  final Dio dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2:2701/api/v2",
  ));


  final nameCtrl = TextEditingController();
  final weaveTypeCtrl = TextEditingController();
  final pickCtrl = TextEditingController();
  final noOfHookCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final spandexEndsCtrl = TextEditingController();

  @override
  void onClose() {
    nameCtrl.dispose();
    weaveTypeCtrl.dispose();
    pickCtrl.dispose();
    noOfHookCtrl.dispose();
    weightCtrl.dispose();
    spandexEndsCtrl.dispose();

    super.onClose();
    super.onClose();
  }


  RxList<RawMaterialMini> selected_warpMaterials = <RawMaterialMini>[].obs;

  RxBool rawMaterialsLoaded = false.obs;

  Rx<RawMaterialMini?> selectedWarpSpandex =
  Rx<RawMaterialMini?>(null);

  // ─── FORM FIELDS ──────────────────────────────
  RxString name = "".obs;
  RxString weaveType = "8".obs;
  RxInt pick = 0.obs;
  RxInt noOfHook = 0.obs;
  RxDouble weight = 0.0.obs;
  RxInt spandexEnds = 0.obs;
  RxList<CostItem> costBreakdown = <CostItem>[].obs;

  RxString searchQuery = "".obs;


  RxBool isLoading=true.obs;


  // ─── RAW MATERIALS ────────────────────────────
  RxList<RawMaterialMini> allMaterials = <RawMaterialMini>[].obs;
  RxList<RawMaterialMini> warpMaterials = <RawMaterialMini>[].obs;

  RxList<RawMaterialMini> weftMaterials = <RawMaterialMini>[].obs;
  RxList<RawMaterialMini> coveringMaterials = <RawMaterialMini>[].obs;

  Rx<RawMaterialMini?> warpSpandex=Rx<RawMaterialMini?>(null);
  double warpSpandexWeight = 0;

  Rx<RawMaterialMini?> weftYarn= Rx<RawMaterialMini?>(null);
  double weftWeight = 0;

  Rx<RawMaterialMini?> spandexCovering= Rx<RawMaterialMini?>(null);
  double coveringWeight = 0;

  RxList<WarpYarnRow> warpYarns = <WarpYarnRow>[].obs;

  RxDouble totalCost = 0.0.obs;

  Map<String, dynamic>? pendingCloneData;

  void setPendingClone(Map<String, dynamic> data) {
    pendingCloneData = data;
  }

  @override
  void onInit() {
    super.onInit();
    fetchRawMaterials();
    addWarpYarnRow();
    ever(rawMaterialsLoaded, (loaded) {
      if (loaded == true && pendingCloneData != null) {
        prefillFromElastic(pendingCloneData!);
        pendingCloneData = null; // 🔥 apply only once
      }
    });

  }

  // ─── FETCH RAW MATERIALS ──────────────────────
  Future<void> fetchRawMaterials() async {

    try{
      isLoading.value=true;
      final res = await dio.get("/materials/get-raw-materials");

    allMaterials.assignAll(
      (res.data["materials"] as List)
          .map((e) => RawMaterialMini.fromJson(e))
          .toList(),
    );

    warpMaterials.value =
        allMaterials.where((m) => m.category == "warp").toList();
    weftMaterials.value =
        allMaterials.where((m) => m.category == "weft").toList();
    coveringMaterials.value =
        allMaterials.where((m) => m.category == "covering").toList();

    // 🔥 If clone data exists, prefill AFTER materials load
    if (pendingCloneData != null) {
      prefillFromElastic(pendingCloneData!);
      pendingCloneData = null;
    }
    }catch(e){}finally{
      isLoading.value=false;
      rawMaterialsLoaded.value = true;
    }


  }


  List<RawMaterialMini> filteredMaterials(List<RawMaterialMini> source) {
    if (searchQuery.value.isEmpty) return source;

    return source
        .where((m) =>
        m.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  // ─── WARP YARN ROWS ───────────────────────────
  void addWarpYarnRow() {
    warpYarns.add(WarpYarnRow());
  }

  void removeWarpYarnRow(int index) {

    warpYarns.removeAt(index);
    calculateCost();
  }

  // ─── COST CALCULATION ─────────────────────────
  void calculateCost() {
    double total = 0;
    final List<CostItem> breakdown = [];

    void addItem(
        RawMaterialMini material,
        double weight,
        String category,
        ) {
      final cost = material.price * weight / 1000;
      total += cost;

      breakdown.add(CostItem(
        name: material.name,
        category: category,
        weight: weight,
        rate: material.price,
        cost: cost,
      ));
    }

    if (warpSpandex != null && warpSpandexWeight > 0) {
      addItem(warpSpandex.value!, warpSpandexWeight, "Spandex");
    }

    if (spandexCovering != null && coveringWeight > 0) {
      addItem(spandexCovering.value!, coveringWeight, "Covering");
    }

    if (weftYarn != null && weftWeight > 0) {
      addItem(weftYarn.value!, weftWeight, "Weft");
    }

    for (final w in warpYarns) {
      if (w.material != null && w.weight > 0) {
        addItem(w.material!, w.weight, "Warp Yarn");
      }
    }

    totalCost.value = total;
    costBreakdown.assignAll(breakdown);
  }




  // ─── SUBMIT ───────────────────────────────────
  Future<void> submitElastic() async {
    final payload = {
      "name": name.value,
      "weaveType": weaveType.value,
      "pick": pick.value,
      "noOfHook": noOfHook.value,
      "weight": weight.value,
      "spandexEnds": spandexEnds.value,
      "warpSpandex": {
        "id": warpSpandex.value!.id,
        "weight": warpSpandexWeight,
      },
      "weftYarn": {
        "id": weftYarn.value!.id,
        "weight": weftWeight,
      },
      "spandexCovering": {
        "id": spandexCovering.value!.id,
        "weight": coveringWeight,
      },
      "warpYarn": warpYarns
          .where((w) => w.material != null)
          .map((w) => {
        "id": w.material!.id,
        "weight": w.weight,
        "ends": w.ends,
        "type":w.type
      })
          .toList(),
    };

    await dio.post("/elastic/create-elastic", data: payload);

    Get.back();
    Get.snackbar("Success", "Elastic created successfully");
  }

  void prefillFromElastic(Map<String, dynamic> e) {
    nameCtrl.text = "${e["name"]} (Clone)";
    weaveTypeCtrl.text = e["weaveType"] ?? "";
    pickCtrl.text = e["pick"]?.toString() ?? "";
    noOfHookCtrl.text = e["noOfHook"]?.toString() ?? "";
    weightCtrl.text = e["weight"]?.toString() ?? "";
    spandexEndsCtrl.text = e["spandexEnds"]?.toString() ?? "";

    // Warp Spandex
    if (e["warpSpandex"] != null) {
      warpSpandex.value = warpMaterials.firstWhereOrNull(
            (m) => m.id == e["warpSpandex"]["id"]["_id"],
      );
      warpSpandexWeight = (e["warpSpandex"]["weight"] ?? 0).toDouble();
    }

    // Spandex Covering
    if (e["spandexCovering"] != null) {
      spandexCovering.value = coveringMaterials.firstWhereOrNull(
            (m) => m.id == e["spandexCovering"]["id"]["_id"],
      );
      coveringWeight =
          (e["spandexCovering"]["weight"] ?? 0).toDouble();
    }

    // Weft Yarn
    if (e["weftYarn"] != null) {
      weftYarn.value = weftMaterials.firstWhereOrNull(
            (m) => m.id == e["weftYarn"]["id"]["_id"],
      );
      weftWeight = (e["weftYarn"]["weight"] ?? 0).toDouble();
    }

    // Warp Yarns (dynamic)
    warpYarns.clear();
    for (final w in e["warpYarn"] ?? []) {
      final row = WarpYarnRow();
      row.material = warpMaterials.firstWhereOrNull(
            (m) => m.id == w["id"]["_id"],
      );
      row.weight = (w["weight"] ?? 0).toDouble();
      row.ends = w["ends"] ?? 0;
      warpYarns.add(row);
    }

    calculateCost();
  }

}
