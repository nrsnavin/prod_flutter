class EmployeeCreate {
  final String name;
  final String phoneNumber;
  final String role;
  final String department;
  final String aadhaar;

  EmployeeCreate({
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.department,
    required this.aadhaar,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'role': role,
      'department': department,
      'aadhaar': aadhaar,
    };
  }
}
