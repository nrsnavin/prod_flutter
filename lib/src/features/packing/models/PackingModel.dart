
class PackingModel {
  final String id;
  final String jobOrderNo;
  final String elasticName;
  final String customerName;
  final String po;
  final int joints;
  final double meters;
  final double stretch;
  final double netWeight;
  final double tareWeight;
  final double grossWeight;
  final String checkedBy;
  final String packedBy;
  final String serialNo;

  PackingModel({
    required this.id,
    required this.jobOrderNo,
    required this.elasticName,
    required this.customerName,
    required this.po,
    required this.joints,
    required this.meters,
    required this.stretch,
    required this.netWeight,
    required this.tareWeight,
    required this.grossWeight,
    required this.checkedBy,
    required this.packedBy,
    required this.serialNo,
  });

  factory PackingModel.fromJson(Map<String, dynamic> json) {
    return PackingModel(
      id: json["_id"],
      jobOrderNo: json["jobOrderNo"].toString(),
      elasticName: json["elastic"]??"",
      customerName: json["customerName"]??"",
      po: json["po"]??"",
      joints: json["joints"]??0,
      meters: (json["meter"] ?? 0).toDouble(),
      stretch: (int.parse(json["stretch"]) ?? 0).toDouble(),
      netWeight: (json["netWeight"] ?? 0).toDouble(),
      tareWeight: (json["tareWeight"] ?? 0).toDouble(),
      grossWeight: (json["grossWeight"] ?? 0).toDouble(),
      checkedBy: json["checkedBy"]??"test",
      packedBy: json["packedBy"]??"test",
      serialNo: json["serialNo"]??"test",
    );
  }
}
