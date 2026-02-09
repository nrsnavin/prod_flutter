import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/common_widgets/appBar.dart';
import 'package:production/src/features/machines/controllers/machineViewController.dart';
import 'package:production/src/features/machines/screens/machineDetail.dart';

import '../models/machine.dart';
import 'AddMachine.dart';

class MachineListScreen extends StatefulWidget {
  @override
  State<MachineListScreen> createState() => _MachineListScreen();
}

class _MachineListScreen extends State<MachineListScreen> {
  final machineController = Get.put(MachineViewController());

  final searchController = TextEditingController();

  late List<MachineList> postsFuture = machineController.machinesList;

  List<MachineList>? orders;

  void _latestFormat() {
    final text = searchController.text;
    setState(() {
      orders = postsFuture.where((c) {
        return c.ID.toLowerCase().contains(text.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    machineController.getMachines();

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
          Get.to(() => const AddMachinePage());
        },
        icon: const Icon(Icons.add),
        label: const Text('ADD MACHINE'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    hintText: 'Search Machine By ID ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => SizedBox(
                height: MediaQuery.sizeOf(context).height-300,
                child: Center(
                  // FutureBuilder
                  child: postsFuture.isNotEmpty
                      ? buildPosts(orders!)
                      : const Text("Loading"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // function to display fetched data on screen
  Widget buildPosts(List<MachineList> machines) {
    return ListView.builder(
      itemCount: machines.length,
      itemBuilder: (context, index) {
        final order = machines[index];
        return InkWell(
          onDoubleTap: () => {
            Get.to(() =>  MachineDetailPage(), arguments: [order.id])
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
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Text(
                        "Manufacturer-",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        order.manufacturer.substring(
                          0,
                          min(order.manufacturer.length, 20),
                        )!,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text(
                      "Jacquard Hooks- ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      order.jacquardHooks.toString(),
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
                      " Heads in Machine- ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      order.heads.toString(),
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
                      "Status /Job Order Running-",
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
              ],
            ),
          ),
        );
      },
    );
  }
}
