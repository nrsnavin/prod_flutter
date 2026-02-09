import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:production/src/features/production/controllers/productionViewController.dart';
import 'package:production/src/features/shiftProgram/models/shiftPlanlModel.dart';
import 'package:production/src/features/shiftProgram/screens/shiftPlanScreen.dart';



class PPonDateScreen extends StatefulWidget {
  const PPonDateScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PPonDateScreen();
  }
}

class _PPonDateScreen extends State<PPonDateScreen> {
  final controller = Get.put(ProductionViewController());

  var args = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    controller.getProductionDetailsInDate(args[0]);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(args[0]+" Shift Plans")),
      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async => controller.getProductionDetailsInDate(args[0]),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),

            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Date:${args[0]}",
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
                shift: controller.dayShiftPLanRX.value,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              _shiftCard(
                title: 'NIGHT SHIFT',
                shift: controller.nightShiftPLanRX.value,
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
    required ShiftPlanModel shift,
    required Color color,
  }) {
    if (shift.plan == []) {
      return _emptyShift(title);
    }

    return Card(

      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                _lockBadge(false),

              ],

            ),
            Center(
              child: TextButton(onPressed: (){
                Get.to(ShiftPlanScreen(),arguments: [shift.id]);
              }, child: Text("Click to View Details",)),
            ),

            const Divider(),

            // Machines list
            Text("Machines Planned:"+shift.plan.length.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text("Production:"+shift.production.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _lockBadge(bool locked) {
    return Chip(
      label: Text(
        locked ? 'LOCKED' : 'OPEN',
        style: const TextStyle(color: Colors.white),
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
