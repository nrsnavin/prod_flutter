import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:production/src/features/Warping/models/warping_plan_model.dart';

import '../models/beam.dart';


class BeamPlanPdfService {
  static  generatePdf({
    required String jobOrderNo,
    required List<WarpingBeam> beams,
  }) async {
    final pdf = pw.Document();

    final totalBeams = beams.length;
    final totalSections =
    beams.fold(0, (sum, b) => sum + b.sections.length);
    final totalEnds =
    beams.fold(0, (sum, b) => sum + b.totalEnds);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          _header(jobOrderNo),
          pw.SizedBox(height: 12),
          _summary(totalBeams, totalSections, totalEnds),
          pw.SizedBox(height: 16),
          ...beams.map(_beamBlock),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/BeamPlan_$jobOrderNo.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);

  }

  // ---------------- WIDGETS ----------------

  static pw.Widget _header(String jobOrderNo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "WARPING BEAM PLAN",
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text("Job Order No: $jobOrderNo"),
        pw.Text("Date: ${DateTime.now().toLocal().toString().split(' ')[0]}"),
        pw.Divider(),
      ],
    );
  }

  static pw.Widget _summary(
      int beams, int sections, int ends) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Beams: $beams"),
          pw.Text("Sections: $sections"),
          pw.Text("Total Ends: $ends"),
        ],
      ),
    );
  }

  static pw.Widget _beamBlock(WarpingBeam beam) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 14),
        pw.Text(
          "Beam ${beam.beamNo}",
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(4),
            2: const pw.FlexColumnWidth(2),
          },
          children: [
            _tableHeader(),
            ...beam.sections.asMap().entries.map(
                  (e) => _tableRow(
                e.key + 1,
                e.value.warpYarnName.toString(),
                e.value.ends,
              ),
            ),
          ],
        ),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(top: 4),
            child: pw.Text(
              "Beam Total Ends: ${beam.totalEnds}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  static pw.TableRow _tableHeader() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: [
        _cell("Sec"),
        _cell("Warp Yarn"),
        _cell("Ends"),
      ],
    );
  }

  static pw.TableRow _tableRow(
      int sec, String yarn, int ends) {
    return pw.TableRow(
      children: [
        _cell(sec.toString()),
        _cell(yarn),
        _cell(ends.toString()),
      ],
    );
  }

  static pw.Widget _cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text),
    );
  }
}
