import 'covering_detail.dart';

class CoveringDetailModel {
  final String id;
  final String status;
  final DateTime date;
  final DateTime? completedDate;

  final JobSummary job;
  final List<CoveringElasticDetail> elasticPlanned;

  CoveringDetailModel({
    required this.id,
    required this.status,
    required this.date,
    this.completedDate,
    required this.job,
    required this.elasticPlanned,
  });

  factory CoveringDetailModel.fromJson(Map<String, dynamic> json) {
    return CoveringDetailModel(
      id: json["_id"],
      status: json["status"],
      date: DateTime.parse(json["date"]),
      completedDate: json["completedDate"] != null
          ? DateTime.parse(json["completedDate"])
          : null,
      job: JobSummary.fromJson(json["job"]),
      elasticPlanned: (json["elasticPlanned"] as List)
          .map<CoveringElasticDetail>(
              (e) => CoveringElasticDetail.fromJson(e))
          .toList(),
    );
  }
}
