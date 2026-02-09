import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Job/screens/job_detail.dart';
import '../controllers/covering_detail.dart';
import '../models/covering.dart';

class CoveringDetailPage extends StatelessWidget {
  final String coveringId;

  const CoveringDetailPage({super.key, required this.coveringId});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CoveringDetailController(coveringId));

    return Scaffold(
      appBar: AppBar(title: const Text("Covering Detail")),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.error.isNotEmpty) {
          return Center(child: Text(c.error.value));
        }

        final data = c.covering.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(data),
              const SizedBox(height: 12),
              _statusActionButton(c, data),
              const SizedBox(height: 12,),
              _jobSection(data),
              const SizedBox(height: 12),
              ...data.elasticPlanned.map(_elasticCard),

              if (data.status == "in_progress") ...[
                _runningCoveringIndicator(),
                const SizedBox(height: 12),
                _completeCoveringButton(c),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _runningCoveringIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(width: 12),
          const Text(
            "Covering is running...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  Widget _completeCoveringButton(
      CoveringDetailController c,
      ) {
    return Obx(
          () => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: c.isCompleting.value
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Icon(Icons.check_circle),

          label: Text(
            c.isCompleting.value
                ? "Completing..."
                : "Mark as Completed",
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),

          onPressed:
          c.isCompleting.value ? null : c.completeCovering,
        ),
      ),
    );
  }


  Widget _header(data) {
    return Card(
      child: ListTile(
        title: Text("Status: ${data.status.toUpperCase()}"),
        subtitle: Text("Date: ${data.date.toLocal()}"),
      ),
    );
  }

  Widget _jobSection(data) {
    return Card(
      child: ListTile(
        title: Text("Job #${data.job.jobOrderNo}"),
        subtitle: Text("Customer: ${data.job.customerName ?? '-'}"),
        trailing: ElevatedButton(
          child: const Text("Go to Job Detail"),
          onPressed: () {
            Get.to(() => JobDetailPage(),arguments: data.job.id);
          },
        ),
      ),
    );
  }

  Widget _statusActionButton(
      CoveringDetailController c,
      CoveringDetailModel data,
      ) {
    if (data.status != "open") return const SizedBox();

    return Obx(
          () => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: c.isActionLoading.value
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Icon(Icons.play_arrow),

          label: Text(
            c.isActionLoading.value
                ? "Starting..."
                : "Move to IN PROGRESS",
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),

          onPressed:
          c.isActionLoading.value ? null : c.moveToInProgress,
        ),
      ),
    );
  }


  Widget _elasticCard(e) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.elastic.name,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            Text("🧶 Warp Spandex"),
            Text("Material: ${e.elastic.warpSpandex.materialName}"),
            Text("Ends: ${e.elastic.warpSpandex.ends}"),

            const SizedBox(height: 8),

            Text("🧵 Covering"),
            Text("Material: ${e.elastic.covering.materialName}"),
            Text("Weight: ${e.elastic.covering.weight} g"),

            const SizedBox(height: 8),

            Text("📐 Testing"),
            Text("Width: ${e.elastic.testing.width ?? '-'}"),
            Text("Elongation: ${e.elastic.testing.elongation}%"),
            Text("Recovery: ${e.elastic.testing.recovery}%"),

            const SizedBox(height: 8),
            Text("Planned Qty: ${e.quantity}",
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
