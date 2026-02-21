import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/material_inward.dart';
import '../models/po_models.dart';
import '../services/theme.dart';


class MaterialInwardPage extends StatelessWidget {
  final POModel po;

  MaterialInwardPage({super.key, required this.po});

  late final MaterialInwardController c = () {
    Get.delete<MaterialInwardController>(force: true);
    return Get.put(MaterialInwardController(po));
  }();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ErpColors.bgBase,
      appBar: _buildAppBar(),
      body: c.inwardRows.isEmpty ? _AllDoneView() : _InwardBody(c: c),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ErpColors.navyDark,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            size: 16, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      titleSpacing: 4,
      // FIX: Flexible so it never overflows
      title: Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Inward  ·  PO #${po.poNo}",
              style: ErpTextStyles.pageTitle,
              overflow: TextOverflow.ellipsis,
            ),
            const Text(
              "Stock Inward Entry",
              style: TextStyle(
                  color: ErpColors.textOnDarkSub, fontSize: 10),
            ),
          ],
        ),
      ),
      // Status chip — icon only to save space
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(3),
            border:
            Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Text(
            po.status,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFF1E3A5F)),
      ),
    );
  }
}

// ── All done view ──────────────────────────────────────────────
class _AllDoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ErpColors.successGreen.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                    color: ErpColors.successGreen.withOpacity(0.3),
                    width: 2),
              ),
              child: const Icon(Icons.task_alt,
                  color: ErpColors.successGreen, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              "All Items Fully Received",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: ErpColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              "No pending quantity for any item in this PO.",
              style:
              TextStyle(color: ErpColors.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ErpColors.borderMid),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                icon: const Icon(Icons.arrow_back,
                    size: 16, color: ErpColors.textSecondary),
                label: const Text("Go Back",
                    style: TextStyle(
                        color: ErpColors.textSecondary,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Inward form body ───────────────────────────────────────────
class _InwardBody extends StatelessWidget {
  final MaterialInwardController c;
  const _InwardBody({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeaderStrip(c: c),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            itemCount: c.inwardRows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) =>
                _InwardItemCard(row: c.inwardRows[i], index: i),
          ),
        ),
        _SubmitBar(c: c),
      ],
    );
  }
}

// ── Header strip — stacked vertically, no horizontal overflow ──
class _HeaderStrip extends StatelessWidget {
  final MaterialInwardController c;
  const _HeaderStrip({required this.c});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat("dd MMM yyyy");

    return Container(

      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
          color: ErpColors.bgSurface,
          border:
          Border(bottom: BorderSide(color: ErpColors.borderLight))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Supplier + Pending count
          Row(
            children: [
              // Supplier
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: ErpColors.bgMuted,
                        border:
                        Border.all(color: ErpColors.borderLight),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.business_outlined,
                          size: 16, color: ErpColors.textSecondary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("SUPPLIER",
                              style: ErpTextStyles.fieldLabel),
                          const SizedBox(height: 1),
                          Text(
                            c.po.supplier?.name ?? "—",
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Pending count
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ErpColors.warningAmber.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: ErpColors.warningAmber.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("PENDING",
                        style: TextStyle(
                            color: ErpColors.warningAmber,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4)),
                    const SizedBox(height: 1),
                    Text(
                      "${c.inwardRows.length}",
                      style: const TextStyle(
                          color: ErpColors.warningAmber,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Row 2: Date picker — full width button
          Obx(() => GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: c.inwardDate.value,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                builder: (ctx, child) => Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: ErpColors.accentBlue,
                      onPrimary: Colors.white,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) c.pickDate(picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: ErpColors.bgMuted,
                border: Border.all(color: ErpColors.borderLight),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: ErpColors.accentBlue),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("INWARD DATE",
                          style: ErpTextStyles.fieldLabel),
                      const SizedBox(height: 1),
                      Text(
                        dateFmt.format(c.inwardDate.value),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: ErpColors.textPrimary),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    "CHANGE",
                    style: TextStyle(
                        color: ErpColors.accentBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 16, color: ErpColors.accentBlue),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

// ── Inward item card — fully vertical, no column overflow ──────
class _InwardItemCard extends StatefulWidget {
  final InwardItemRow row;
  final int index;
  const _InwardItemCard({required this.row, required this.index});

  @override
  State<_InwardItemCard> createState() => _InwardItemCardState();
}

class _InwardItemCardState extends State<_InwardItemCard> {
  bool _showRemarks = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.row.poItem;
    final hasError = widget.row.hasError;

    return Container(
      decoration: BoxDecoration(
        color: ErpColors.bgSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasError ? ErpColors.errorRed : ErpColors.borderLight,
          width: hasError ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ErpColors.navyDark.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Card header: index + material name ──────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
            decoration: BoxDecoration(
              color: hasError
                  ? ErpColors.errorRed.withOpacity(0.04)
                  : ErpColors.bgMuted,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(8)),
              border: const Border(
                  bottom: BorderSide(color: ErpColors.borderLight)),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ErpColors.accentBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "${widget.index + 1}",
                    style: const TextStyle(
                        color: ErpColors.accentBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.rawMaterial?.name ?? "—",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.rawMaterial?.unit != null)
                        Text(
                          "Unit: ${item.rawMaterial!.unit}",
                          style: const TextStyle(
                              color: ErpColors.textMuted, fontSize: 11),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Qty chips: Ordered / Received / Pending ─
                Row(
                  children: [
                    _QtyChip(
                        label: "ORDERED",
                        value: "${item.quantity} kg",
                        color: ErpColors.textSecondary),
                    const SizedBox(width: 6),
                    _QtyChip(
                        label: "RECEIVED",
                        value: "${item.receivedQuantity} kg",
                        color: ErpColors.successGreen),
                    const SizedBox(width: 6),
                    _QtyChip(
                        label: "PENDING",
                        value: "${item.pendingQuantity} kg",
                        color: ErpColors.warningAmber),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Quantity input + FULL button ─────────────
                const Text("RECEIVING NOW *",
                    style: ErpTextStyles.fieldLabel),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.row.quantityCtrl,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "0",
                          hintStyle: const TextStyle(
                              color: ErpColors.textMuted, fontSize: 14),
                          filled: true,
                          fillColor: hasError
                              ? ErpColors.errorRed.withOpacity(0.04)
                              : ErpColors.bgMuted,
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                          suffixText: "kg",
                          suffixStyle: const TextStyle(
                              color: ErpColors.textSecondary, fontSize: 12),
                          errorText: hasError
                              ? "Exceeds pending (${item.pendingQuantity} kg)"
                              : null,
                          errorStyle: const TextStyle(
                              fontSize: 11, color: ErpColors.errorRed),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: hasError
                                  ? ErpColors.errorRed
                                  : ErpColors.borderLight,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: hasError
                                  ? ErpColors.errorRed
                                  : ErpColors.borderLight,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                              color: hasError
                                  ? ErpColors.errorRed
                                  : ErpColors.accentBlue,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // FULL button — fixed width, never compressed
                    GestureDetector(
                      onTap: () {
                        widget.row.quantityCtrl.text =
                            item.pendingQuantity.toString();
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: ErpColors.accentBlue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color:
                              ErpColors.accentBlue.withOpacity(0.3)),
                        ),
                        child: const Text(
                          "FULL",
                          style: TextStyle(
                              color: ErpColors.accentBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Remarks toggle ───────────────────────────
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () =>
                      setState(() => _showRemarks = !_showRemarks),
                  child: Row(
                    children: [
                      Icon(
                        _showRemarks
                            ? Icons.remove_circle_outline
                            : Icons.add_circle_outline,
                        size: 15,
                        color: ErpColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _showRemarks ? "Hide remarks" : "Add remarks",
                        style: const TextStyle(
                            color: ErpColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                if (_showRemarks) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: widget.row.remarksCtrl,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    decoration: ErpDecorations.formInput(
                        "Optional remarks..."),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _QtyChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4),
                textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ── Submit bar — two-row layout, no overflow ───────────────────
class _SubmitBar extends StatelessWidget {
  final MaterialInwardController c;
  const _SubmitBar({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: ErpColors.bgSurface,
        border: const Border(top: BorderSide(color: ErpColors.borderLight)),
        boxShadow: [
          BoxShadow(
            color: ErpColors.navyDark.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tip — full width, safe
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.info_outline,
                  size: 14, color: ErpColors.textMuted),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Enter quantity received for each item. Tap FULL to auto-fill.",
                  style: TextStyle(
                      color: ErpColors.textMuted, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Buttons — cancel 1/3, submit 2/3
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: ErpColors.borderMid),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          color: ErpColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed:
                    c.isSubmitting.value ? null : c.submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ErpColors.successGreen,
                      disabledBackgroundColor:
                      ErpColors.successGreen.withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    icon: c.isSubmitting.value
                        ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white))
                        : const Icon(Icons.input,
                        size: 16, color: Colors.white),
                    label: const Text(
                      "Record Inward",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}