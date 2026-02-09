import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/features/elastic/screens/searchable_material_picker.dart';
import '../controllers/add_elastic_controller.dart';
import '../models/cost.dart';
import '../models/raw_material.dart';

class AddElasticPage extends StatelessWidget {
  
  final c = Get.put(AddElasticController());

    final Map<String, dynamic>? cloneData;
  AddElasticPage({super.key, this.cloneData});



  @override
  Widget build(BuildContext context) {



    if (cloneData != null) {
      c.setPendingClone(cloneData!);
    }

    if (cloneData != null) {
      c.pendingCloneData = cloneData;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(cloneData == null ? "Add Elastic" : "Clone Elastic"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ───────────────── BASIC INFO ─────────────────
            _sectionCard(
              title: "Basic Information",
              children: [
                _textField("Elastic Name", (v) => c.name.value = v),
                _textField("Weave Type", (v) => c.weaveType.value = v),
                _numberField("Pick",(v) => c.pick.value = int.parse(v)),
                _numberField("No of Hooks", (v) => c.noOfHook.value = int.parse(v)),
                _numberField("Elastic Weight (gm)", (v) => c.weight.value = double.parse(v)),
              ],
            ),

            /// ───────────────── SPANDEX ─────────────────
            _sectionCard(
              title: "Cover Elastomer Configuration",
              children: [
                _numberField(
                    "Spandex Ends", (v) => c.spandexEnds.value = int.parse(v)),


                Obx(() => _materialDropdown(
                  label: "Warp Spandex",
                  materials: c.warpMaterials,
                  value: c.warpSpandex.value,
                  onSelect: (v) {
                    c.warpSpandex.value = v;
                    c.calculateCost();
                  },
                  onWeight: (w) {
                    c.warpSpandexWeight = w;
                    c.calculateCost();
                  },
                )),

                SizedBox(height: 10,),

                Obx(() => _materialDropdown(
                  label: " Covering",
                  materials: c.coveringMaterials,
                  value: c.spandexCovering.value,
                  onSelect: (v) {
                    c.spandexCovering.value = v;
                    c.calculateCost();
                  },
                  onWeight: (w) {
                    c.coveringWeight = w;
                    c.calculateCost();
                  },
                ))




             
              ],
            ),

            /// ───────────────── WARP YARN ─────────────────
            _sectionCard(
              title: "Warp Yarn Configuration",
              children: [
                Obx(() => Column(
                  children: List.generate(c.warpYarns.length, (index) {
                    final row = c.warpYarns[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [

                            /// RAW MATERIAL DROPDOWN
                            Obx(() => DropdownButtonFormField<String>(
                              value: row.material?.id,
                              items: c.warpMaterials.map((m) {
                                return DropdownMenuItem(
                                  value: m.id,
                                  child: Text(m.name),
                                );
                              }).toList(),
                              onChanged: (v) => row.material = c.allMaterials.firstWhere((t)=>t.id==v),
                              decoration: const InputDecoration(labelText: "Warp Yarn Material"),
                            )),

                            const SizedBox(height: 8),

                            /// ENDS
                            TextFormField(

                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: "Ends"),
                            ),

                            const SizedBox(height: 8),

                            /// TYPE
                            TextFormField(

                              decoration: const InputDecoration(labelText: "Type"),
                            ),

                            const SizedBox(height: 8),

                            /// WEIGHT
                            TextFormField(

                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: "Weight (grams)"),
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => c.removeWarpYarnRow(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ))
,
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: c.addWarpYarnRow,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Warp Yarn"),
                  )
                ),
              ],
            ),

            /// ───────────────── WEFT YARN ─────────────────
            _sectionCard(
              title: "Weft Yarn Configuration",
              children: [


                Obx(() => _materialDropdown(
                  label: "Weft Yarn",
                  materials: c.weftMaterials,
                  value: c.weftYarn.value,
                  onSelect: (v) {
                    c.weftYarn.value = v;
                    c.calculateCost();
                  },
                  onWeight: (w) {
                    c.weftWeight = w;
                    c.calculateCost();
                  },
                ))
              ],
            ),

            /// ───────────────── TESTING PARAMETERS ─────────────────
            _sectionCard(
              title: "Testing Parameters",
              children: [
                _numberField("Width (mm)", (v) {}),
                _numberField("Elongation (%)", (v) {}),
                _numberField("Recovery (%)", (v) {}),
                _textField("Stretch Type", (v) {}),
              ],
            ),

            /// ───────────────── COST PREVIEW ─────────────────
            _sectionCard(
              title: "Cost Preview",
              children: [
                Obx(() => Text(
                  "Estimated Material Cost: ₹${c.totalCost.value.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )),
              ],
            ),
            costBreakdownSection(c),

            const SizedBox(height: 20),

            /// ───────────────── SAVE ─────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: c.submitElastic,
                child: const Text("Save Elastic"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ───────────────── HELPERS ─────────────────

  Widget _sectionCard(
      {required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _textField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(

        decoration: InputDecoration(labelText: label),
        onChanged: onChanged,
      ),
    );
  }

  Widget _numberField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(

        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }

  Widget _materialDropdown({
    required String label,
    required List<RawMaterialMini> materials,
    required RawMaterialMini? value,
    required Function(RawMaterialMini?) onSelect,
    required Function(double) onWeight,
  }) {
    return Column(
      children: [
        materialSelectField(
          label:label,
          value:value ,
          onTap: () => showMaterialPicker(
            title: "Select "+label,
            materials: materials,
            onSelected:onSelect
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Weight (gm)"),
          onChanged: (v) => onWeight(double.tryParse(v) ?? 0),
        ),
      ],
    );
  }


  Widget costBreakdownSection(AddElasticController c) {
    return Obx(() {
      if (c.costBreakdown.isEmpty) return const SizedBox();

      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: ExpansionTile(
          title: const Text(
            "Cost Breakdown",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Total: ₹${c.totalCost.value.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.green),
          ),
          children: [
            ..._groupedCostTiles(c.costBreakdown),
          ],
        ),
      );
    });
  }
  List<Widget> _groupedCostTiles(List<CostItem> items) {
    final Map<String, List<CostItem>> grouped = {};

    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return grouped.entries.map((entry) {
      final categoryTotal =
      entry.value.fold<double>(0, (s, i) => s + i.cost);

      return ExpansionTile(
        title: Text(entry.key),
        trailing: Text("₹${categoryTotal.toStringAsFixed(2)}"),
        children: entry.value.map((i) {
          return ListTile(
            title: Text(i.name),
            subtitle: Text(
                "Wt: ${i.weight}g × ₹${i.rate}/kg"),
            trailing: Text(
              "₹${i.cost.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  Widget materialSelectField({
    required String label,
    required RawMaterialMini? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value?.name ?? "Select"),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }


}
