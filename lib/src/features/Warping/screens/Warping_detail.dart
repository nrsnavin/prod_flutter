import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:printing/printing.dart';
import 'package:production/src/features/Warping/screens/pdf.dart';
import 'package:production/src/features/Warping/screens/plan_view.dart';
import 'package:production/src/features/Warping/screens/warping_plan.dart';

import '../controllers/warp_detail.dart';
import '../controllers/warp_material_model.dart';
import '../controllers/warping_detail.dart';
import '../models/warping_detail.dart';

class WarpingDetailPage extends StatelessWidget {
  final String warpingId;
  const WarpingDetailPage({required this.warpingId});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(WarpingDetailController(warpingId));

    return Scaffold(
      appBar: AppBar(title: const Text("Warping Detail")),
      body: Obx(() {
        if (c.loading.value || c.warping.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final w = c.warping.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(w),


              const SizedBox(height: 12),

              if (w.status == "open") _slideToStart(c),

              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => WarpingPlanPage(),arguments: [w.jid,w.id]);
                },
                icon: const Icon(Icons.account_tree),
                label: const Text("Create Warping Plan"),
              ),

              if (w.status == "in_progress") ...[
                _runningIndicator(),
                const SizedBox(height: 12),
                _slideToComplete(c),
              ],

              if (w.status == "completed") _completedBanner(),
              const SizedBox(height: 16),
              ...w.elastics.map(_elasticWarpCard),
              Obx(() {
                if (!c.hasPlan.value) {
                  return ElevatedButton(child: Text("data"),onPressed: (){
                    Get.to(WarpingPlanPageView(warpingId:"69863957e8230cd864ae612f",),arguments: ["69863957e8230cd864ae612f"]);
                  },);
                }
                
                
                
                final plan = c.plan!;

                return Column(
                  children: plan.beams.map((b) {
                    return Card(
                      child: ListTile(
                        title: Text("Beam ${b.beamNo}"),
                        subtitle: Text("Total Ends: ${b.totalEnds}"),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _slideToStart(WarpingDetailController c) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              c.startWarping();
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.play_arrow,
            label: "Start Warping",
          ),
        ],
      ),
      child: _actionTile("Slide to Start Warping"),
    );
  }


  Future<bool> showConfirmDialog(
      String title,
      String message,
      ) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    ) ??
        false;
  }


  // Widget _statusActions(WarpingDetailController controller) {
  //   return Obx(() {
  //     final status = controller.warping.value?.status;
  //
  //     if (status == "open") {
  //       return ElevatedButton.icon(
  //         icon: const Icon(Icons.play_arrow),
  //         label: const Text("Start Warping"),
  //         onPressed: () async {
  //           final ok = await showConfirmDialog(
  //             "Start Warping",
  //             "Are you sure you want to start warping?",
  //           );
  //           if (ok) {
  //             await controller.startWarping();
  //           }
  //         },
  //       );
  //     }
  //
  //     if (status == "in_progress") {
  //       return ElevatedButton.icon(
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.green,
  //         ),
  //         icon: const Icon(Icons.check),
  //         label: const Text("Complete Warping"),
  //         onPressed: () async {
  //           final ok = await showConfirmDialog(
  //             "Complete Warping",
  //             "Confirm warping completion?",
  //           );
  //           if (ok) {
  //             await controller.completeWarping();
  //           }
  //         },
  //       );
  //     }
  //
  //     if (status == "completed") {
  //       return const Chip(
  //         label: Text(
  //           "Warping Completed",
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         backgroundColor: Colors.greenAccent,
  //       );
  //     }
  //
  //     return const SizedBox.shrink();
  //   });
  // }


  // 🔄 RUNNING
  Widget _runningIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: const [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(width: 12),
          Text(
            "Warping is running...",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ✅ SLIDE TO COMPLETE WITH CONFIRMATION
  Widget _slideToComplete(WarpingDetailController c) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.check_circle,
            label: "Complete",
            onPressed: (_) => _confirmComplete(c),
          ),
        ],
      ),
      child: _actionTile("Slide to Complete Warping"),
    );
  }

  Widget _actionTile(String text) {
    return Card(
      child: ListTile(
        title: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.swipe),
      ),
    );
  }

  Widget _completedBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Warping Completed ✅",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🔔 CONFIRMATION DIALOG
  void _confirmComplete(WarpingDetailController c) {
    Get.defaultDialog(
      title: "Confirm Completion",
      middleText: "Are you sure you want to complete warping?",
      textConfirm: "Yes, Complete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        c.completeWarping();
        Get.back();
      },
    );
  }

  Widget _header(WarpingDetailModel w) {
    return Card(
      child: ListTile(
        title: Text(
          "Job Order #${w.jobOrderNo}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Status: ${w.status.toUpperCase()}\nDate: ${_fmt(w.date)}",
        ),
      ),
    );
  }

  Widget _elasticWarpCard(ElasticWarpDetailModel e) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.elasticName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text("Planned Qty: ${e.plannedQty}"),

            const Divider(),

            if (e.warpSpandex != null) ...[
              const Text(
                "Warp Spandex",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _warpRow(e.warpSpandex!),
              const SizedBox(height: 10),
            ],

            const Text(
              "Warp Yarns",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...e.warpYarns.map(_warpRow),



            // ElevatedButton.icon(
            //   icon: const Icon(Icons.picture_as_pdf),
            //   label: const Text("Export Beam Plan"),
            //   onPressed: () async {
            //     final file = await BeamPlanPdfService.generatePdf(
            //       jobOrderNo: job.jobOrderNo.toString(),
            //       beams: c.beamPlans,
            //     );
            //
            //     await Printing.sharePdf(
            //       bytes: await file.readAsBytes(),
            //       filename: file.path.split('/').last,
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _warpRow(WarpMaterialModel w) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(w.name)),
          Text("Ends: ${w.ends}"),
          const SizedBox(width: 8),
          Text("${w.weight} g"),
        ],
      ),
    );
  }

  String _fmt(DateTime d) => "${d.day}-${d.month}-${d.year}";
}
