import 'dart:convert';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PackingSlipPdf {
  static Future<void> generate({
    required String packingId,
    required String elasticName,
    required String customerName,
    required String po,
    required String jobOrderNo,
    required int joints,
    required String checkedBy,
    required String packedBy,
    required double meters,
    required double stretch,
    required double netWeight,
    required double tareWeight,
    required double grossWeight,
  }) async {
    final pdf = pw.Document();

    final pageFormat =
    PdfPageFormat(4 * PdfPageFormat.inch, 6 * PdfPageFormat.inch);

    final serialNo =
        "SL-${DateTime.now().millisecondsSinceEpoch}";

    final qrData = jsonEncode({
      "jobOrderNo": jobOrderNo,
      "packingId": packingId,
      "serial": serialNo,
      "meters": meters,
    });

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(10),
        build: (context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 1),
            ),
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                /// ===== HEADER =====
                pw.Row(
                  mainAxisAlignment:
                  pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "ANU TAPES",
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      serialNo,
                      style: const pw.TextStyle(fontSize: 7),
                    ),
                  ],
                ),

                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.Text(
                    "PACKING SLIP",
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),

                pw.SizedBox(height: 6),

                /// ===== MAIN INFO TABLE =====
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1.2),
                    1: const pw.FlexColumnWidth(1.8),
                  },
                  children: [

                    _row("Customer", customerName),
                    _row("PO", po),
                    _row("Job Order", jobOrderNo),

                  ],
                ),

                pw.SizedBox(height: 6),

                /// ===== ELASTIC NAME BOX =====
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(6),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 0.7),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      elasticName,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                pw.SizedBox(height: 6),

                /// ===== PRODUCTION DATA =====
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(1.2),
                    1: const pw.FlexColumnWidth(1.8),
                  },
                  children: [
                    _row("Meters", "${meters.toStringAsFixed(2)} m"),
                    _row("Joints", joints.toString()),
                    _row("Stretch", "${stretch.toStringAsFixed(1)} %"),
                    _row("Net Weight", "${netWeight.toStringAsFixed(2)} kg"),
                    _row("Tare Weight", "${tareWeight.toStringAsFixed(2)} kg"),
                    _row("Gross Weight", "${grossWeight.toStringAsFixed(2)} kg"),
                  ],
                ),

                pw.SizedBox(height: 6),

                /// ===== QC TABLE =====
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  children: [
                    _row("Checked By", checkedBy),
                    _row("Packed By", packedBy),
                  ],
                ),

                pw.Spacer(),

                /// ===== QR =====
                pw.Center(
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: qrData,
                    width: 85,
                    height: 85,
                  ),
                ),

                pw.SizedBox(height: 4),

                pw.Center(
                  child: pw.Text(
                    "Scan for Verification",
                    style: const pw.TextStyle(fontSize: 6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final directory = await getDownloadsDirectory();
    if (directory == null) return;

    final file = File(
        "${directory.path}/PackingSlip_${jobOrderNo}_$packingId.pdf");

    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
  }

  /// 🔹 Table Row With Border
  static pw.TableRow _row(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    );
  }
}
