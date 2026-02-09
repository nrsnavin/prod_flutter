import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:production/src/features/shiftProgram/screens/shiftDetailScreen.dart';
import '../controllers/empViewController.dart';
import '../models/employeeDetail.dart';


class EmployeeDetailPage extends StatefulWidget {
  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPage();
}


class _EmployeeDetailPage extends State<EmployeeDetailPage> {

  final empController = Get.put(EmpViewController());

  void initState() {
    // TODO: implement initState

    empController.fetchEmployeeDetails(Get.arguments[0]);

    
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(title: const Text('Employee Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          ()=> Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileHeader(),
              const SizedBox(height: 16),
              _infoCard(),
              const SizedBox(height: 16),
              _performanceCard(),
              const SizedBox(height: 16),
              const Text(
                'Last 30 Days Shift History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...empController.shifts.map(_shiftCard).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.blue,
          child: Text(
            empController.employee.value.name.substring(0, 1),
            style: const TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              empController.employee.value.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Chip(
              label: Text(empController.employee.value.role),
              backgroundColor: Colors.blue.shade100,
            ),
          ],
        )
      ],
    );
  }

  Widget _infoCard() {
    return Card(
      child: Column(
        children: [
          _infoRow('Phone', empController.employee.value.phone),
          _infoRow('UIDAI', empController.employee.value.aadhar),
          _infoRow('Department', empController.employee.value.department),
          _infoRow('Role', empController.employee.value.role),
          _infoRow('Employee ID', empController.employee.value.id),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget  _performanceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          children: const [
            _Metric(title: 'Avg Efficiency', value: '82%'),
            _Metric(title: 'Total Shifts', value: '24'),
            _Metric(title: 'Avg Output', value: '980 m'),
            _Metric(title: 'Avg Runtime', value: '7h 30m'),
          ],
        ),
      ),
    );
  }

  Widget _shiftCard(ShiftHistory shift) {
    final color = shift.efficiency >= 80
        ? Colors.green
        : shift.efficiency >= 60
        ? Colors.orange
        : Colors.red;

    return Card(
      child: ListTile(
        onTap: () {
          Get.to(ShiftDetailScreen(),arguments: [shift.id]);
        },
        title: Text(
          '${DateFormat('dd MMM yyyy').format(shift.date)} · ${shift.shiftType} SHIFT',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Machine: ${shift.machineName}'),
            Text('Runtime: ${shift.runtimeMinutes ~/ 60}h ${shift.runtimeMinutes % 60}m'),
            Text('Output: ${shift.outputMeters} m'),
          ],
        ),
        trailing: Chip(
          label: Text('${shift.efficiency}%'),
          backgroundColor: color.withOpacity(0.15),
          labelStyle: TextStyle(color: color),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String title;
  final String value;

  const _Metric({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
