import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:production/src/features/machines/controllers/machineViewController.dart';
import 'package:production/src/features/shiftProgram/screens/shiftDetailScreen.dart';
import '../models/machineDetail.dart';
import '../models/machineShiftHistory.dart';


class MachineDetailPage extends StatefulWidget {
  const MachineDetailPage({super.key});

  @override
  State<MachineDetailPage> createState() => _MachineDetailPage();
}



class _MachineDetailPage extends State<MachineDetailPage> {


  final machineController = Get.put(MachineViewController());

  void initState() {
    // TODO: implement initState

    machineController.fetchMachineDetails(Get.arguments[0]);


    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(title: const Text('Machine Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          ()=> Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _machineHeader(),
              const SizedBox(height: 16),
              _machineInfoCard(context),
              const SizedBox(height: 16),
              const Text(
                'Previous 20 Shifts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...machineController.shifts.map(_shiftCard).toList(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 HEADER
  Widget _machineHeader() {
    final isRunning = machineController.machine.value.status == 'RUNNING';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.precision_manufacturing, size: 40),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  machineController.machine.value.machineId,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Chip(
                  label: Text(machineController.machine.value.status),
                  backgroundColor:
                  isRunning ? Colors.green.shade100 : Colors.grey.shade300,
                  labelStyle: TextStyle(
                    color: isRunning ? Colors.green : Colors.grey.shade700,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 🔹 MACHINE INFO
  Widget _machineInfoCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _infoRow('Manufacturer', machineController.machine.value.manufacturer),
          _infoRow('No. of Heads', machineController.machine.value.noOfHeads.toString()),
          _infoRow('No. of Hooks', machineController.machine.value.noOfHooks.toString()),

          // 🔴 Editable Order Row
          ListTile(
            title: const Text('Current Order'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  machineController.machine.value.currentOrder,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditOrderSheet(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showEditOrderSheet(BuildContext context) {
    final controller = TextEditingController(text: machineController.machine.value.currentOrder);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update Current Order',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Order Name',
                  hintText: machineController.machine.value.currentOrder,
                ),
                textCapitalization: TextCapitalization.characters,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        machineController.updateOrder(controller.text,machineController.machine.value.machineId);

                        Navigator.pop(context);
                      },
                      child: const Text('SAVE'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
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

  // 🔹 SHIFT CARD
  Widget _shiftCard(MachineShiftHistory shift) {
    final effColor = shift.efficiency >= 80
        ? Colors.green
        : shift.efficiency >= 60
        ? Colors.orange
        : Colors.red;

    return Card(
      child: ListTile(
        title: Text(
          '${DateFormat('dd MMM yyyy').format(shift.date)} · ${shift.shiftType} SHIFT',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Operator: ${shift.operatorName}'),
            Text(
                'Runtime: ${shift.runtimeMinutes ~/ 60}h ${shift.runtimeMinutes % 60}m'),
            Text('Output: ${shift.outputMeters} m'),

          ],
        ),
        trailing: Chip(
          label: Text('${shift.efficiency}%'),
          backgroundColor: effColor.withOpacity(0.15),
          labelStyle: TextStyle(color: effColor),
        ),
        onTap: () {
          Get.to(ShiftDetailScreen(),arguments:[ shift.id]);
          // Future: Navigate to Shift Detail Page
        },
      ),
    );
  }
}
