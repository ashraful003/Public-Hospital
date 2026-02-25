import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../model/DoctorModel.dart';
import '../../model/UserModel.dart';

class MakePdfService {
  static Future<void> generatePrescription({
    required DoctorModel doctor,
    required UserModel patient,
    required String weight,
    required String complaints,
    required String diagnosis,
    required List<String> medicines,
  }) async {
    final pdf = pw.Document();
    List<pw.Widget> medicineWidgets = [];
    int count = 1;

    for (int i = 0; i < medicines.length; i++) {
      String line = medicines[i].trim();
      if (line.isEmpty) continue;
      bool isDosage = RegExp(r'^[\d]+\+[\d]+\+[\d]+').hasMatch(line) ||
          RegExp(r'^[\d]+\s*\+\s*[\d]+\s*\+\s*[\d]+').hasMatch(line);

      if (isDosage) {
        medicineWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20, bottom: 8),
            child: pw.Text(
              line,
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
        );
      } else {
        medicineWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Text(
              "$count. $line",
              style: pw.TextStyle(
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        );
        count++;
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        doctor.hospital,
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(doctor.address),
                      pw.Text("Phone: ${doctor.phone}"),
                      pw.SizedBox(height: 10),
                      pw.Divider(thickness: 2),
                    ],
                  ),
                ),

                pw.SizedBox(height: 10),
                pw.Text(
                  doctor.name,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(doctor.degree),
                pw.SizedBox(height: 15),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Name: ${patient.name}"),
                    pw.Text("ID: ${patient.patientId}"),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Age: ${patient.age}"),
                    pw.Text("Weight: $weight kg"),
                  ],
                ),

                pw.SizedBox(height: 20),
                pw.Text("Problems:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(complaints),
                pw.SizedBox(height: 15),
                pw.Text("Diagnosis:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(diagnosis),
                pw.SizedBox(height: 20),
                pw.Text("Rx",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.SizedBox(height: 10),
                ...medicineWidgets,
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}