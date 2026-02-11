class MachineRunningModel {
  final String machineId;
  final String machineCode;
  final String jobOrderNo;

  MachineRunningModel({
    required this.machineId,
    required this.machineCode,
    required this.jobOrderNo,
  });

  factory MachineRunningModel.fromJson(Map<String, dynamic> json) {
    return MachineRunningModel(
      machineId: json['machineId'],
      machineCode: json['machineCode'],
      jobOrderNo: json['jobOrderNo'].toString(),
    );
  }
}
