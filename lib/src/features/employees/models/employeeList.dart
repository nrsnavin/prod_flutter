import 'dart:ffi';

class Emplist {
  String id;
  String name;
  String department;
  String role;
  double performance;


  Emplist({
    required this.id,
    required this.name,
    required this.department,
    required this.role,
    required this.performance,

  });

  factory Emplist.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        '_id': String id,
        'name': String name,
        'department': String department,
        'role': String role,
        'performance': var performance,

      } =>
        Emplist(
          id: id,
       department: department,
          name: name,
          performance:double.parse(performance.toString()) ,
          role: role
        ),
      _ => throw const FormatException('Failed to load Job.'),
    };
  }
}
