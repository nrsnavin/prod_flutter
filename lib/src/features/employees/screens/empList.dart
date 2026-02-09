import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/common_widgets/appBar.dart';
import 'package:production/src/features/employees/screens/add_employee_page.dart';
import 'package:production/src/features/employees/screens/employeeDetail.dart';
import 'package:production/src/features/machines/controllers/machineViewController.dart';

import '../../authentication/controllers/login_controller.dart';
import '../controllers/empViewController.dart';
import '../models/employeeList.dart';

class EmpListScreen extends StatefulWidget {
  @override
  State<EmpListScreen> createState() => _EmpListScreen();
}

class _EmpListScreen extends State<EmpListScreen> {
  final empController = Get.put(EmpViewController());

  final loginController = Get.put(LoginController());

  final searchController = TextEditingController();

  late List<Emplist> postsFuture = empController.empList;

  List<Emplist>? orders;

  void _latestFormat() {
    final text = searchController.text;
    setState(() {
      orders = postsFuture.where((c) {
        return c.name.toLowerCase().contains(text.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    empController.getEmps();

    searchController.addListener(_latestFormat);
    orders = postsFuture;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat, //

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addMachine',
        onPressed: () {
          Get.to(() => const AddEmployeePage());
        },
        icon: const Icon(Icons.add),
        label: const Text('ADD Employee'),
      ),
      body: SingleChildScrollView(
        child: Obx(
          ()=> Column(
            children: [
              NAppBar(showBackArrow: true),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search Operator By name ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.sizeOf(context).height-300,
                  child: Center(
                    // FutureBuilder
                    child: postsFuture.isNotEmpty
                        ? buildPosts(orders!)
                        : const Text("Loading"),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }

  // function to display fetched data on screen
  Widget buildPosts(List<Emplist> machines) {
    return ListView.builder(
      itemCount: machines.length,
      itemBuilder: (context, index) {
        final order = machines[index];
        return InkWell(
          onDoubleTap: () => {
            Get.to(() =>  EmployeeDetailPage(), arguments: [order.id])
          },
          child: Container(
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
                      "Name-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      order.name,
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
                      "Department- ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      order.department,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text(
                      "Role- ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      order.role.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text(
                      "Rating-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      order.performance.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
