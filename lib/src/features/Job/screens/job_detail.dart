import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:production/src/features/Job/models/jobElastic.dart';

import '../../shiftProgram/models/shiftDetailModel.dart';
import '../controllers/job_detail_controller.dart';
import '../models/ShiftDetailModel.dart';
import '../models/eqv.dart';
import '../models/job_detail.dart';
import '../models/preparatory_model.dart';
import 'machine_assign.dart';

class JobDetailPage extends StatelessWidget {
  final args = Get.arguments;
  late final c = Get.put(JobDetailController(args));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Job Details")),
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final job = c.job.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(job),
              _elasticSummary(job),
              _preparatorySection(job),
              _weavingSection(job),
              _finishingSection(job),
              _checkingSection(job),
              _packingSection(job),
              _shiftDetailsSection(job.shiftDetails),
            ],
          ),
        );
      }),
    );
  }

  Widget _preparatorySection(JobDetailView job) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text("Preparatory"),
            subtitle: Text("Status: ${job.status}"),
          ),
          _prepTile("Warping", job.warping),
          _prepTile("Covering", job.covering),
        ],
      ),
    );
  }

  Widget _prepTile(String title, PreparatoryView? prep) {
    if (prep == null) return const SizedBox();

    return ListTile(
      title: Text(title),
      subtitle: Text("Status: ${prep.status}"),
      trailing: prep.status == "completed"
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.hourglass_empty),
    );
  }

  Widget _shiftDetailsSection(List<ShiftDetailModelView> shifts) {
    if (shifts.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("No shift records yet"),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Shift Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ...shifts.map((shift) {
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // LEFT SIDE
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(shift.date as DateTime),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("Shift: ${shift.shift}"),
                      Text("Operator: ${shift.operatorName}"),
                    ],
                  ),

                  // RIGHT SIDE
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Production",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "${shift.production} m",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }


  Widget _weavingSection(JobDetailView job) {
    if (job.status != "weaving" && job.status != "preparatory")
      return const SizedBox();

    return Card(
      child: Column(
        children: [
          const ListTile(title: Text("Weaving")),
          if (job.machineName == null)
            ElevatedButton(
              onPressed: () {
                // open machine + employee selector
                Get.to(
                  WeavingPlanPage(
                    jobId: job.id,
                    jobElastics: job.planned
                        .map(
                          (e) => JobElasticModel(
                            id: e.elasticId,
                            name: e.elasticName,
                            quantity: e.quantity.toInt(),
                          ),
                        )
                        .toList(),
                  ),
                  arguments: job.id,
                );
              },
              child: const Text("Plan Weaving"),
            )
          else
            ListTile(
              title: Text("Machine: ${job.machineName}"),
              subtitle: Text("Operators: ${job.weavingEmployees.join(', ')}"),
            ),
        ],
      ),
    );
  }

  Widget _checkingSection(JobDetailView job) {
    if (job.status != "checking") return const SizedBox();

    return Card(
      child: Column(
        children: [
          const ListTile(title: Text("Checking")),
          ElevatedButton(
            onPressed: () {
              // Add wastage dialog
            },
            child: const Text("Add Wastage"),
          ),
        ],
      ),
    );
  }

  Widget _header(JobDetailView job) {
    Color statusColor() {
      switch (job.status) {
        case "preparatory":
          return Colors.orange;
        case "weaving":
          return Colors.blue;
        case "finishing":
          return Colors.purple;
        case "checking":
          return Colors.amber;
        case "packing":
          return Colors.teal;
        case "completed":
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔢 Job Number
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Job Order #${job.jobNo}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Date: ${_formatDate(job.date)}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // 🏷 Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor().withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                job.status.toUpperCase(),
                style: TextStyle(
                  color: statusColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _elasticSummary(JobDetailView job) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Elastic Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 📊 Header
            Row(
              children: const [
                Expanded(flex: 3, child: Text("Elastic")),
                Expanded(child: Text("Planned", textAlign: TextAlign.right)),
                Expanded(child: Text("Produced", textAlign: TextAlign.right)),
                Expanded(child: Text("Packed", textAlign: TextAlign.right)),
              ],
            ),
            const Divider(),

            // 📦 Rows
            ...job.planned.map((p) {
              final produced = job.produced.firstWhere(
                (e) => e.elasticId == p.elasticId,
                orElse: () => ElasticQtyView(
                  elasticId: p.elasticId,
                  elasticName: p.elasticName,
                  quantity: 0,
                ),
              );

              final packed = job.packed.firstWhere(
                (e) => e.elasticId == p.elasticId,
                orElse: () => ElasticQtyView(
                  elasticId: p.elasticId,
                  elasticName: p.elasticName,
                  quantity: 0,
                ),
              );

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        p.elasticName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        p.quantity.toStringAsFixed(0),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        produced.quantity.toStringAsFixed(0),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        packed.quantity.toStringAsFixed(0),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _finishingSection(JobDetailView job) {
    if (job.status != "finishing" &&
        job.status != "checking" &&
        job.status != "packing" &&
        job.status != "completed") {
      return const SizedBox();
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Finishing",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 🟢 Status Indicator
            Row(
              children: [
                Icon(
                  job.status == "finishing"
                      ? Icons.hourglass_top
                      : Icons.check_circle,
                  color: job.status == "finishing"
                      ? Colors.orange
                      : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  job.status == "finishing"
                      ? "Finishing in progress"
                      : "Finishing completed",
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ✅ Complete Finishing Button
            if (job.status == "finishing")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.done),
                  label: const Text("Mark Finishing Completed"),
                  onPressed: () {
                    // CALL API:
                    // POST /job-orders/mark-finishing-completed
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _packingSection(JobDetailView job) {
    if (job.status != "packing" && job.status != "completed") {
      return const SizedBox();
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Packing",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 📦 Packed Elastic Summary
            ...job.packed.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.elasticName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      e.quantity.toStringAsFixed(0),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),

            const Divider(height: 20),

            // ➕ Add Packing Entry
            if (job.status == "packing")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_box),
                  label: const Text("Add Packing Entry"),
                  onPressed: () {
                    // OPEN PACKING FORM
                    // POST /packing/create
                  },
                ),
              ),

            // 🟢 Completed Badge
            if (job.status == "completed")
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Job Completed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }
}
