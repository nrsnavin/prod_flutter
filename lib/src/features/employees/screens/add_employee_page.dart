import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/features/employees/controllers/employee_controller.dart';
import '../models/employee_create.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {

  final employeeController = Get.put(EmployeeController());
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _aadhaarCtrl = TextEditingController();

  String? _selectedDepartment;

  final List<String> departments = [
    'weaving',
    'warping',
    'covering',
    'general',
    'finishing',
    'packing',
    'checking',
    'admin',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _roleCtrl.dispose();
    _aadhaarCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final employee = EmployeeCreate(
      name: _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      role: _roleCtrl.text.trim(),
      department: _selectedDepartment!,
      aadhaar: _aadhaarCtrl.text.trim(),
    );

    employeeController.addEmployee(employee);

    // 🔌 API call goes here
    // Get.find<EmployeeController>().addEmployee(employee);


    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Employee')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _textField(
                controller: _nameCtrl,
                label: 'Employee Name',
                hint: 'Ramesh Kumar',
              ),
              _phoneField(),
              _textField(
                controller: _roleCtrl,
                label: 'Role',
                hint: 'Loom Operator',
              ),
              _departmentDropdown(),
              _aadhaarField(),
              const SizedBox(height: 24),

            Obx(() {


              return ElevatedButton(
                onPressed: employeeController.isSaving.value ? null : _submit,
                child: employeeController.isSaving.value
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text(
                  'ADD EMPLOYEE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }),



            ],
          ),
        ),
      ),
    );
  }

  // 🔹 TEXT FIELD
  Widget _textField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
        value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }

  // 🔹 PHONE FIELD
  Widget _phoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _phoneCtrl,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        decoration: const InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(),
          counterText: '',
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          if (value.length != 10) {
            return 'Enter valid 10-digit number';
          }
          return null;
        },
      ),
    );
  }

  // 🔹 DEPARTMENT DROPDOWN
  Widget _departmentDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedDepartment,
        decoration: const InputDecoration(
          labelText: 'Department',
          border: OutlineInputBorder(),
        ),
        items: departments
            .map(
              (d) => DropdownMenuItem(
            value: d,
            child: Text(d),
          ),
        )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedDepartment = value;
          });
        },
        validator: (value) =>
        value == null ? 'Please select department' : null,
      ),
    );
  }

  // 🔹 AADHAAR FIELD
  Widget _aadhaarField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _aadhaarCtrl,
        keyboardType: TextInputType.number,
        maxLength: 12,
        decoration: const InputDecoration(
          labelText: 'Aadhaar Number',
          border: OutlineInputBorder(),
          counterText: '',
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          if (value.length != 12) {
            return 'Aadhaar must be 12 digits';
          }
          return null;
        },
      ),
    );
  }
}
