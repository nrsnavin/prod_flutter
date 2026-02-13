class CheckingJobModel {
  final String id;
  final int jobNo;
  final List<JobElasticModel> elastics;

  CheckingJobModel({
    required this.id,
    required this.jobNo,
    required this.elastics,
  });

  factory CheckingJobModel.fromJson(Map<String, dynamic> json) {
    return CheckingJobModel(
      id: json["_id"],
      jobNo: json["jobOrderNo"],
      elastics: (json["elastics"] as List)
          .map((e) => JobElasticModel.fromJson(e))
          .toList(),
    );
  }
}

class JobElasticModel {
  final String elasticId;
  final int quantity;

  JobElasticModel({
    required this.elasticId,
    required this.quantity,
  });

  factory JobElasticModel.fromJson(Map<String, dynamic> json) {
    return JobElasticModel(
      elasticId: json["elastic"],
      quantity: json["quantity"],
    );
  }
}


class EmployeeModel {
  final String id;
  final String name;

  EmployeeModel({required this.id, required this.name});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json["_id"],
      name: json["name"],
    );
  }
}
