class PackingJobModel {
  final String id;
  final int jobNo;
  final List<ElasticItem> elastics;

  PackingJobModel({
    required this.id,
    required this.jobNo,
    required this.elastics,
  });

  factory PackingJobModel.fromJson(Map<String, dynamic> json) {
    return PackingJobModel(
      id: json["_id"],
      jobNo: json["jobOrderNo"],
      elastics: (json["elastics"] as List)
          .map((e) => ElasticItem.fromJson(e))
          .toList(),
    );
  }
}

class ElasticItem {
  final String elasticId;
  final String name;

  ElasticItem({required this.elasticId, required this.name});

  factory ElasticItem.fromJson(Map<String, dynamic> json) {
    return ElasticItem(
      elasticId: json["elastic"]["_id"],
      name: json["elastic"]["name"],
    );
  }
}
