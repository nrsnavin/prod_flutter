import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/warping_plan.dart';


class WarpingPlanPage extends StatelessWidget {
   WarpingPlanPage({super.key});

  final args=Get.arguments;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(WarpingPlanController(args[0],args[1]));

    return Scaffold(
      appBar: AppBar(title: const Text("Warping Plan")),
      body: Obx(
            () => ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _beamCountSelector(c),
            const SizedBox(height: 12),

            ...c.beams.map((beam) => _beamCard(c, beam)).toList(),

            const SizedBox(height: 16),
            _totalEndsCard(c),
            const SizedBox(height: 12),
            _submitWarpingPlanButton(c),
          ],
        ),
      ),
    );
  }

  Widget _beamCountSelector(WarpingPlanController c) {
    return Card(
      child: ListTile(
        title: const Text("Number of Beams"),
        trailing: SizedBox(
          width: 80,
          child: TextFormField(
            initialValue: c.beamCount.value.toString(),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              final n = int.tryParse(v) ?? 1;
              c.updateBeamCount(n.clamp(1, 24300300));
            },
          ),
        ),
      ),
    );
  }

  Widget _beamCard(WarpingPlanController c, beam) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Beam ${beam.beamNo}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            ...beam.sections.asMap().entries.map(
                  (e) => _sectionRow(
                c,
                beamIndex: beam.beamNo - 1,
                sectionIndex: e.key,
                section: e.value,
              ),
            ),

            TextButton.icon(
              onPressed: () => c.addSection(beam.beamNo - 1),
              icon: const Icon(Icons.add),
              label: const Text("Add Section"),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Beam Ends: ${beam.totalEnds}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionRow(
      WarpingPlanController c, {
        required int beamIndex,
        required int sectionIndex,
        required section,
      }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField(
            decoration: const InputDecoration(labelText: "Warp Yarn"),
            items: c.warpYarns
                .map(
                  (w) => DropdownMenuItem(
                value: w.id,
                child: Text(w.name),
              ),
            )
                .toList(),
            onChanged: (val) {
              final yarn = c.warpYarns.firstWhere((e) => e.id == val);
              section.warpYarnId = yarn.id;
              section.warpYarnName = yarn.name;
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(labelText: "Ends"),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              section.ends = int.tryParse(v) ?? 0;
              c.beams.refresh();
            },
          ),
        ),
      ],
    );
  }


   Widget _submitWarpingPlanButton(WarpingPlanController controller) {
     return Obx(() {
       return SizedBox(
         width: double.infinity,
         child: ElevatedButton.icon(
           icon: controller.saving.value
               ? const SizedBox(
             width: 18,
             height: 18,
             child: CircularProgressIndicator(
               strokeWidth: 2,
               color: Colors.white,
             ),
           )
               : const Icon(Icons.save),
           label: Text(
             controller.saving.value
                 ? "Submitting..."
                 : "Submit Warping Plan",
           ),
           onPressed: controller.saving.value
               ? null
               : () {
             // 🛑 Basic validation
             if (controller.beams.isEmpty) {
               Get.snackbar(
                 "Validation Error",
                 "Add at least one beam",
                 backgroundColor: Colors.red,
                 colorText: Colors.white,
               );
               return;
             }

             for (final beam in controller.beams) {
               if (beam.sections.isEmpty) {
                 Get.snackbar(
                   "Validation Error",
                   "Each beam must have at least one section",
                   backgroundColor: Colors.red,
                   colorText: Colors.white,
                 );
                 return;
               }

               for (final section in beam.sections) {
                 if (section.warpYarnId == null ||
                     section.ends <= 0) {
                   Get.snackbar(
                     "Validation Error",
                     "Select warp yarn and enter valid ends",
                     backgroundColor: Colors.red,
                     colorText: Colors.white,
                   );
                   return;
                 }
               }
             }

             // ✅ Submit to backend
             controller.submitWarpingPlan();
           },
           style: ElevatedButton.styleFrom(
             padding: const EdgeInsets.symmetric(vertical: 14),
             backgroundColor: Colors.blue,
             textStyle: const TextStyle(
               fontSize: 16,
               fontWeight: FontWeight.bold,
             ),
           ),
         ),
       );
     });
   }


   Widget _totalEndsCard(WarpingPlanController c) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.calculate),
            const SizedBox(width: 12),
            Text(
              "Total Ends Planned: ${c.totalEnds}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
