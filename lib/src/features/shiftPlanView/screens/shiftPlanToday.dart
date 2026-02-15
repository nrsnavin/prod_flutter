import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:production/src/features/shiftPlanView/controllers/shift_plan_view_controller.dart';
import 'package:production/src/features/shiftPlanView/screens/shiftPlanDetail.dart';

import 'package:production/src/features/shiftProgram/screens/shiftPlanScreen.dart';

import '../models/shiftSummary.dart';

class TodayShiftPage extends StatefulWidget {
  const TodayShiftPage({super.key});

  @override
  State<TodayShiftPage> createState() => _TodayShiftPageState();
}

class _TodayShiftPageState extends State<TodayShiftPage> {
  final controller = Get.put(ShiftController());

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toLocal();

    return Scaffold(
      appBar: AppBar(title: const Text("Today's Shift Plans")),
      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh:  controller.fetchTodayShifts,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),

            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Date:${DateFormat('dd MMM yyyy').format(now.toLocal())}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              _shiftCard(
                title: 'DAY SHIFT',
                shift: controller.dayShift.value,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              _shiftCard(
                title: 'NIGHT SHIFT',
                shift: controller.nightShift.value,
                color: Colors.deepPurple,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _shiftCard({
    required String title,
    required ShiftSummaryModel? shift,
    required Color color,
  }) {
    if (shift!.id == "test") {
      return _emptyShift(title);
    }

    final isLocked = shift.status == "closed";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                _lockBadge(isLocked),
              ],
            ),

            const SizedBox(height: 10),

            /// LIVE STATUS DOT
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLocked ? Colors.grey : Colors.green,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isLocked ? "Shift Closed" : "Shift Running",
                  style: TextStyle(
                    color: isLocked ? Colors.grey : Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const Divider(height: 25),

            /// KPI ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _kpiBox(
                  label: "Machines",
                  value: shift.runningMachines.toString(),
                  color: Colors.red,
                ),
                _kpiBox(
                  label: "Production",
                  value: "${shift.production} m",
                  color: Colors.blue,
                ),
                _kpiBox(
                  label: "Operators",
                  value: shift.runningMachines.toString(),
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// VIEW BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.to(
                    ShiftPlanDetailPage(),
                    arguments: shift.id,
                  );
                },
                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kpiBox({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _lockBadge(bool locked) {
    return Chip(
      label: Text(
        locked ? 'LOCKED' : 'OPEN',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: locked ? Colors.red : Colors.green,
    );
  }

  Widget _emptyShift(String title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'No shift plan created',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
