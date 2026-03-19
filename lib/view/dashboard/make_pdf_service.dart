import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../model/user_model.dart';

class MakePdfService {
  static Future<void> generatePrescription({
    required UserModel doctor,
    required UserModel patient,
    required String weight,
    required String problems,
    required List<String> medicines,
    required String bloodPressure,
  }) async {
    final pdf = pw.Document();
    List<pw.Widget> medicineWidgets = [];
    int count = 1;
    for (var line in medicines) {
      line = line.trim();
      if (line.isEmpty) continue;
      bool isDosage = RegExp(
        r'^[\d]+\s*\+\s*[\d]+\s*\+\s*[\d]+',
      ).hasMatch(line);
      if (isDosage) {
        medicineWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20, bottom: 6),
            child: pw.Text(line, style: const pw.TextStyle(fontSize: 12)),
          ),
        );
      } else {
        medicineWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Text(
              "$count. $line",
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
            ),
          ),
        );
        count++;
      }
    }
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      doctor.institute ?? "",
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(doctor.address ?? ""),
                    pw.Text("Phone: ${doctor.phone ?? ''}"),
                  ],
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 8),
              pw.Text(
                doctor.name ?? "",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(doctor.degree ?? ""),
              pw.Text(doctor.specialist ?? ""),
              pw.SizedBox(height: 12),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 1.5),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Patient ID: ${patient.nationalId ?? ''}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Divider(thickness: 0.5),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            "Name: ${patient.name ?? ''}",
                            style: const pw.TextStyle(fontSize: 12),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            "Age: ${patient.age ?? 'N/A'}",
                            style: const pw.TextStyle(fontSize: 12),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            "Weight: $weight",
                            style: const pw.TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Expanded(
                child: pw.Container(
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1.5),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 160,
                        padding: const pw.EdgeInsets.all(10),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            right: pw.BorderSide(
                              color: PdfColors.black,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "BP: $bloodPressure",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text(
                              "Problems:",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            pw.Text(
                              problems,
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                "Rx",
                                style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(height: 6),
                              pw.Divider(thickness: 0.5),
                              pw.SizedBox(height: 8),
                              ...medicineWidgets,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
