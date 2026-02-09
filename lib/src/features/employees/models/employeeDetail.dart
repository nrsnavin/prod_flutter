

class ShiftHistory {
  final String id;
  final DateTime date;
  final String shiftType;
  final String machineName;
  final String description;
  final String feedback;

  final int runtimeMinutes;
  final int outputMeters;
  final double efficiency;

  ShiftHistory({
    required this.id,
    required this.date,
    required this.shiftType,
    required this.machineName,
    required this.runtimeMinutes,
    required this.outputMeters,
    required this.efficiency,
    required this.description,
    required this.feedback
  });

  factory ShiftHistory.fromJson(Map<String, dynamic> json) {
    return ShiftHistory(
      id: json['id'],
      date: DateTime.parse(json['date']),
      shiftType: json['shift'],
      machineName: json['machine'],
      runtimeMinutes: json['runtimeMinutes'],
      outputMeters: json['outputMeters'],
      efficiency: double.parse(json['efficiency'].toString()),
      feedback: json['feedback'],
      description: json['description'],
    );
  }
}


