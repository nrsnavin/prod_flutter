import 'package:production/src/features/Warping/controllers/warp_detail.dart';

class WarpingDetailModel {
  final String id;
  final String status;
  final DateTime date;
  final int jobOrderNo;
  final String jid;
  final List<ElasticWarpDetailModel> elastics;

  WarpingDetailModel({
    required this.id,
    required this.status,
    required this.date,
    required this.jobOrderNo,
    required this.elastics,
    required this.jid
  });

  factory WarpingDetailModel.fromJson(Map<String, dynamic> json) {
    return WarpingDetailModel(
      id: json['_id'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      jobOrderNo: json['job']['jobOrderNo'],
      jid: json['job']['_id'],
      elastics: (json['elasticOrdered'] as List)
          .map((e) => ElasticWarpDetailModel.fromJson(e))
          .toList(),
    );
  }
}
