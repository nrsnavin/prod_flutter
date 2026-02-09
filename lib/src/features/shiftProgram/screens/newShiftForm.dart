import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/common_widgets/appBar.dart';
import 'package:production/src/features/machines/controllers/machineViewController.dart';
import 'package:production/src/features/shiftProgram/controllers/shift_controller.dart';
import 'package:production/src/features/shiftProgram/models/employee.dart';

import '../../machines/models/machine.dart';

class NewShiftCreationForm extends StatefulWidget {
  @override
  State<NewShiftCreationForm> createState() => _NewShiftCreationForm();
}

class _NewShiftCreationForm extends State<NewShiftCreationForm> {
  final shiftController = Get.put(ShiftController());
  final machineController = Get.put(MachineViewController());
  var date = DateTime.now();

  var employeesList;
  var elasticsList;
  final descriptionController = TextEditingController();
  var shiftText;
  var plan = {};
  var selectedEmployee;
  var selectedElastic;

  var machineList;

  @override
  void initState() {
    shiftController.getWeavingEmployees();
    machineController.getMachines();
    employeesList = shiftController.employeesWeave;

    machineList = machineController.machinesList;

    super.initState();
  }

  var args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: NAppBar(
        showBackArrow: true,
        actions: [

          Obx(() => TextButton(
            onPressed: shiftController.isLoadingSp.value
                ? null
                : () {
              shiftController.tryPost(
                plan,
                date,
                shiftText,
                descriptionController.value.text,

              );
            },
            child: shiftController.isLoadingSp.value
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Save'),
          ))

        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: (Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Add New Shift",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 10),
              DateTimeFormField(
                mode: DateTimeFieldPickerMode.date,
                decoration: const InputDecoration(
                  labelText: 'Enter Shift Date',
                ),
                firstDate: DateTime.now().subtract(const Duration(days: 10)),
                lastDate: DateTime.now().add(const Duration(days: 10)),
                initialPickerDateTime: DateTime.now(),

                onChanged: (DateTime? value) {
                  date = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Description",
                  hintText: "Enter Description if Any",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: shiftText,
                hint: const Text("Shift "),
                items: ["DAY", "NIGHT"].map<DropdownMenuItem<String>>((p) {
                  return DropdownMenuItem<String>(value: p, child: Text(p));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    shiftText = value;
                  });
                },
              ),
              const SizedBox(height: 30),

              Obx(
                () => Column(
                  // FutureBuilder
                 children: [...machineList.map(_shiftCard).toList()],
                ),
              ),

              // TextButton(
              //   onPressed: () {
              //     shiftController.tryPost(
              //       args[0],
              //       date,
              //       shiftText,
              //       descriptionController.value.text,
              //       selectedEmployee,
              //     );
              //   },
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.indigo,
              //     shadowColor: Colors.black,
              //     elevation: 2,
              //     fixedSize: const Size.fromWidth(300),
              //   ),
              //   child: const Text(
              //     "Assign Shift",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
            ],
          )),
        ),
      ),
    ));
  }

  Widget _shiftCard(MachineList order) {

    return Container(
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      width: MediaQuery.sizeOf(context).width - 10,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              const Text(
                "Machine ID-",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              Text(
                order.ID,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              const Text(
                "Order Running-",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              Text(
                order.elastic,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Obx(
                () => DropdownButtonFormField(
              initialValue: selectedEmployee,
              hint: const Text("Emploee Name"),
              items: employeesList.map<DropdownMenuItem<String>>((p) {
                return DropdownMenuItem<String>(
                  value: p.id,
                  child: Text(p.name.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  plan[order.ID] = value;
                  // selectedEmployee = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildPosts() {
  //   List<MachineList> machines = machineList;
  //
  //
  //   return ListView.builder(
  //     itemCount: machines.length,
  //     itemBuilder: (context, index) {
  //       final order = machines[index];
  //
  //       return Container(
  //         color: Colors.grey.shade300,
  //         margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
  //         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
  //         width: MediaQuery.sizeOf(context).width - 10,
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 const SizedBox(width: 10),
  //                 const Text(
  //                   "Machine ID-",
  //                   style: TextStyle(
  //                     color: Colors.black87,
  //                     fontWeight: FontWeight.w900,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //                 Text(
  //                   order.ID,
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 const SizedBox(width: 10),
  //                 const Text(
  //                   "Order Running-",
  //                   style: TextStyle(
  //                     color: Colors.black87,
  //                     fontWeight: FontWeight.w900,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //                 Text(
  //                   order.elastic,
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Obx(
  //               () => DropdownButtonFormField(
  //                 initialValue: selectedEmployee,
  //                 hint: const Text("Emploee Name"),
  //                 items: employeesList.map<DropdownMenuItem<String>>((p) {
  //                   return DropdownMenuItem<String>(
  //                     value: p.id,
  //                     child: Text(p.name.toString()),
  //                   );
  //                 }).toList(),
  //                 onChanged: (value) {
  //                   setState(() {
  //                     plan[machines[index].ID] = value;
  //                     // selectedEmployee = value;
  //                   });
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
