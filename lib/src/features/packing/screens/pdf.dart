import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
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

    /// 4" x 6" size
    final pageFormat = PdfPageFormat(
      4 * PdfPageFormat.inch,
      6 * PdfPageFormat.inch,
    );

    /// Load company logo
    final logoBytes =
    (await rootBundle.load('assets/images/logo.png'))
        .buffer
        .asUint8List();

    /// Auto serial number
    final serialNo =
        "SL-${DateTime.now().millisecondsSinceEpoch}";

    /// QR Data
    final qrData = jsonEncode({
      "jobOrderNo": jobOrderNo,
      "packingId": packingId,
      "serial": serialNo,
      "meters": meters,
      "timestamp": DateTime.now().toIso8601String(),
    });

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(12),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              /// ================= HEADER =================
              pw.Row(
                mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(
                    pw.MemoryImage(logoBytes),
                    height: 40,
                  ),
                  pw.Column(
                    crossAxisAlignment:
                    pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "PACKING SLIP",
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight:
                          pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        serialNo,
                        style: const pw.TextStyle(
                          fontSize: 7,
                        ),
                      ),
                    ],
                  )
                ],
              ),

              pw.SizedBox(height: 6),
              pw.Divider(),

              /// ================= CUSTOMER =================
              _labelValue("Customer", customerName),
              _labelValue("PO", po),
              _labelValue("Job Order", jobOrderNo),

              pw.SizedBox(height: 8),

              pw.Container(
                padding:
                const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    width: 0.5,
                  ),
                ),
                child: pw.Text(
                  elasticName,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight:
                    pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 8),

              /// ================= PRODUCTION =================
              _labelValue(
                  "Meters",
                  "${meters.toStringAsFixed(2)} m"),
              _labelValue(
                  "Joints", joints.toString()),
              _labelValue(
                  "Stretch",
                  "${stretch.toStringAsFixed(1)} %"),

              pw.SizedBox(height: 6),

              _labelValue(
                  "Net Weight",
                  "${netWeight.toStringAsFixed(2)} kg"),
              _labelValue(
                  "Tare Weight",
                  "${tareWeight.toStringAsFixed(2)} kg"),
              _labelValue(
                  "Gross Weight",
                  "${grossWeight.toStringAsFixed(2)} kg"),

              pw.SizedBox(height: 10),
              pw.Divider(),

              /// ================= QC =================
              _labelValue("Checked By", checkedBy),
              _labelValue("Packed By", packedBy),

              pw.Spacer(),

              /// ================= QR =================
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: qrData,
                  width: 90,
                  height: 90,
                ),
              ),

              pw.SizedBox(height: 4),

              pw.Center(
                child: pw.Text(
                  "Scan for verification",
                  style:
                  const pw.TextStyle(fontSize: 7),
                ),
              ),
            ],
          );
        },
      ),
    );

    /// Save to Downloads
    final directory =
    await getDownloadsDirectory();

    if (directory == null) return;

    final file = File(
        "${directory.path}/PackingSlip_${jobOrderNo}_$packingId.pdf");

    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  static pw.Widget _labelValue(
      String label, String value) {
    return pw.Padding(
      padding:
      const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment:
        pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "$label:",
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight:
              pw.FontWeight.bold,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              textAlign: pw.TextAlign.right,
              style: const pw.TextStyle(
                  fontSize: 8),
            ),
          ),
        ],
      ),
    );
  }
}
