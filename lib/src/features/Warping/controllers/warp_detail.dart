import 'package:production/src/features/Warping/controllers/warp_material_model.dart';

class ElasticWarpDetailModel {
  final String elasticName;
  final int plannedQty;
  final WarpMaterialModel? warpSpandex;
  final List<WarpMaterialModel> warpYarns;

  ElasticWarpDetailModel({
    required this.elasticName,
    required this.plannedQty,
    this.warpSpandex,
    required this.warpYarns,
  });

  factory ElasticWarpDetailModel.fromJson(Map<String, dynamic> json) {
    final elastic = json['elastic'];

    return ElasticWarpDetailModel(
      elasticName: elastic['name'],
      plannedQty: json['quantity'],
      warpSpandex: elastic['warpSpandex']?['id'] != null
          ? WarpMaterialModel.fromJson(elastic['warpSpandex'])
          : null,
      warpYarns: (elastic['warpYarn'] as List)
          .map((e) => WarpMaterialModel.fromJson(e))
          .toList(),
    );
  }
}
