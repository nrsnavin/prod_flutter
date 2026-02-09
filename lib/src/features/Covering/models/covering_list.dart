class CoveringModel {
  final String id;
  final String status;
  final DateTime date;
  final int jobOrderNo;

  CoveringModel({
    required this.id,
    required this.status,
    required this.date,
    required this.jobOrderNo,
  });

  factory CoveringModel.fromJson(Map<String, dynamic> json) {
    return CoveringModel(
      id: json['_id'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      jobOrderNo: json['job']['jobOrderNo'],
    );
  }
}
