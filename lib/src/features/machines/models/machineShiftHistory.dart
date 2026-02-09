class MachineShiftHistory {
  final DateTime date;
  final String id;
  final String shiftType; // DAY / NIGHT
  final String operatorName;
  final int runtimeMinutes;
  final int outputMeters;
  final double efficiency;

  MachineShiftHistory({
    required this.id,
    required this.date,
    required this.shiftType,
    required this.operatorName,
    required this.runtimeMinutes,
    required this.outputMeters,
    required this.efficiency,
  });

  factory MachineShiftHistory.fromJson(Map<String, dynamic> json) {
    return MachineShiftHistory(
      id: json['id'],
      date: DateTime.parse(json['date']),
      shiftType: json['shift'],
      operatorName: json['employee'],
      runtimeMinutes: json['runtimeMinutes'],
      outputMeters: json['outputMeters'],
      efficiency: double.parse(json['efficiency'].toString()),
    );
  }
}
