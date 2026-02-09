class WarpingModel {
  final String id;
  final String status;
  final DateTime date;
  final DateTime? completedDate;
  final JobRefModel job;

  WarpingModel({
    required this.id,
    required this.status,
    required this.date,
    this.completedDate,
    required this.job,
  });

  factory WarpingModel.fromJson(Map<String, dynamic> json) {
    return WarpingModel(
      id: json['_id'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
      job: JobRefModel.fromJson(json['job']),
    );
  }
}

class JobRefModel {
  final String id;
  final int jobOrderNo;
  final String status;

  JobRefModel({
    required this.id,
    required this.jobOrderNo,
    required this.status,
  });

  factory JobRefModel.fromJson(Map<String, dynamic> json) {
    return JobRefModel(
      id: json['_id'],
      jobOrderNo: json['jobOrderNo'],
      status: json['status'],
    );
  }
}
