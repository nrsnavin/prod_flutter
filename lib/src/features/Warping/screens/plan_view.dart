import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/plan_view.dart';
// import '../controllers/warping_plan_controller.dart';
import '../models/warping_plan_model.dart';

class WarpingPlanPageView extends StatelessWidget {
  final String warpingId;

  const WarpingPlanPageView({
    super.key,
    required this.warpingId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WarpingPlanControllerView(warpingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Warping Plan"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.plan.value == null) {
          return _noPlanView(controller);
        }

        return _planView(controller.plan.value!, controller);
      }),
    );
  }

  /// ===========================
  /// NO PLAN UI
  /// ===========================
  Widget _noPlanView(WarpingPlanControllerView controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No Warping Plan Created",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Create Warping Plan"),
            onPressed: () {
              // Navigate to create plan screen
              // Get.to(() => CreateWarpingPlanPage(warpingId: controller.warpingId));
            },
          ),
        ],
      ),
    );
  }

  /// ===========================
  /// PLAN VIEW UI
  /// ===========================
  Widget _planView(WarpingPlanModel plan, WarpingPlanControllerView controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(plan),
          const SizedBox(height: 12),
          _summary(plan),
          const SizedBox(height: 16),
          _beamList(plan),
          const SizedBox(height: 24),
          _actions(controller),
        ],
      ),
    );
  }

  /// ===========================
  /// HEADER
  /// ===========================
  Widget _header(WarpingPlanModel plan) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.factory),
        title: Text(
          "Job ID: ${plan.jobId}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Created: ${plan.createdAt.toLocal().toString().split(' ')[0]}",
        ),
      ),
    );
  }

  /// ===========================
  /// SUMMARY
  /// ===========================
  Widget _summary(WarpingPlanModel plan) {
    final totalEnds =
    plan.beams.fold<int>(0, (sum, b) => sum + b.totalEnds);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _summaryItem("Beams", plan.noOfBeams.toString()),
            _summaryItem("Total Ends", totalEnds.toString()),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }

  /// ===========================
  /// BEAM LIST
  /// ===========================
  Widget _beamList(WarpingPlanModel plan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: plan.beams.map(_beamCard).toList(),
    );
  }

  Widget _beamCard(WarpingBeam beam) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Beam ${beam.beamNo}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _sectionTable(beam),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Chip(
                label: Text(
                  "Total Ends: ${beam.totalEnds}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===========================
  /// SECTION TABLE
  /// ===========================
  Widget _sectionTable(WarpingBeam beam) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FixedColumnWidth(60),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(80),
      },
      children: [
        _tableHeader(),
        ...beam.sections.map(_sectionRow).toList(),
      ],
    );
  }

  TableRow _tableHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text("Sec", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text("Warp Yarn", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text("Ends", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  TableRow _sectionRow(WarpingBeamSection section) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          // child: Text(section.sectionNo.toString()),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(section.warpYarnName),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            section.ends.toString(),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  /// ===========================
  /// ACTIONS
  /// ===========================
  Widget _actions(WarpingPlanControllerView controller) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("View PDF"),
            onPressed: controller.exportPdf,
          ),
        ),
      ],
    );
  }
}
