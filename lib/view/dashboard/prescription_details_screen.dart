import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:public_hospital/view/dashboard/prescription_update_screen.dart';
import '../../viewModel/dashboard/prescription_details_view_model.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final int prescriptionId;
  final String role;

  PrescriptionDetailScreen({
    super.key,
    required this.prescriptionId,
    required this.role,
  });

  final GlobalKey _printKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrescriptionDetailViewModel()..loadById(prescriptionId),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Prescription",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            if (role.toLowerCase() == "doctor")
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () async {
                  final updatedPrescriptionId = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrescriptionUpdateScreen(
                        prescriptionId: prescriptionId,
                      ),
                    ),
                  );
                  if (updatedPrescriptionId != null && context.mounted) {
                    await context.read<PrescriptionDetailViewModel>().loadById(
                      updatedPrescriptionId,
                    );
                  }
                },
              ),
            const SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Consumer<PrescriptionDetailViewModel>(
                builder: (context, vm, child) {
                  return IconButton(
                    icon: const Icon(Icons.print, color: Colors.black),
                    onPressed: () async {
                      final boundary =
                      _printKey.currentContext?.findRenderObject()
                      as RenderRepaintBoundary?;
                      if (boundary == null) return;

                      // FIX: pixelRatio is now derived from the actual A4
                      // print resolution instead of an arbitrary constant,
                      // so the capture resolution always lines up with the
                      // physical A4 page size regardless of the boundary's
                      // logical pixel size.
                      const double targetDpi = 300;
                      const double baseDpi = 96; // logical px per inch
                      final double pixelRatio = targetDpi / baseDpi;

                      final image = await boundary.toImage(
                        pixelRatio: pixelRatio,
                      );
                      final byteData = await image.toByteData(
                        format: ui.ImageByteFormat.png,
                      );
                      if (byteData == null) return;
                      Uint8List pngBytes = byteData.buffer.asUint8List();

                      await Printing.layoutPdf(
                        onLayout: (format) async {
                          final pdf = pw.Document();
                          final imageProvider = pw.MemoryImage(pngBytes);

                          // FIX: explicitly build the page at A4 size with
                          // zero margin, then center the captured image on
                          // it using BoxFit.contain (not fill). This keeps
                          // the prescription's own aspect ratio intact and
                          // guarantees it sits flush and correctly aligned
                          // on a true A4 page instead of being stretched to
                          // whatever the print dialog's format happens to
                          // report.
                          pdf.addPage(
                            pw.Page(
                              pageFormat: PdfPageFormat.a4,
                              margin: pw.EdgeInsets.zero,
                              build: (context) {
                                return pw.Center(
                                  child: pw.SizedBox(
                                    width: PdfPageFormat.a4.width,
                                    height: PdfPageFormat.a4.height,
                                    child: pw.Image(
                                      imageProvider,
                                      fit: pw.BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                          return pdf.save();
                        },
                        format: PdfPageFormat.a4,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: Consumer<PrescriptionDetailViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return Center(child: Text(vm.error!));
            }
            final p = vm.prescription;
            if (p == null) {
              return const Center(child: Text("No Prescription Found"));
            }
            final hasDoctorBn = p.doctorBnName.isNotEmpty;
            final hasDoctorBnVisitingTime = p.doctorBnVisitingTime.isNotEmpty;
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  // A4 at 96 logical px/inch: 210mm x 297mm = 794 x 1123 px.
                  // Kept as-is so the on-screen preview and the captured
                  // image both match the true A4 aspect ratio (0.7071).
                  width: 794,
                  height: 1123,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: RepaintBoundary(
                    key: _printKey,
                    child: ClipRect(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              left: 39,
                              right: 18,
                              top: 28,
                              bottom: 18,
                            ),
                            alignment: Alignment.centerLeft,
                            color: const Color(0xFFFFFACC),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.doctorName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text(p.doctorDegree),
                                      Text(
                                        p.doctorSpecialist,
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(p.doctorInstitute),
                                      Text(
                                        "BM&DC Reg. No: ${p.doctorLicense}",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (hasDoctorBn)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          p.doctorBnName,
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Text(
                                          p.doctorBnDegree,
                                          textAlign: TextAlign.right,
                                        ),
                                        Text(
                                          p.doctorBnSpecialist,
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          p.doctorBnInstitute,
                                          textAlign: TextAlign.right,
                                        ),
                                        Text(
                                          "বিএম ও ডিসি রেজিস্ট্রেশন নং: ${p.doctorBnLicense}",
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            height: 55,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: const BoxDecoration(
                              color: Color(0xFFB3CCCC),
                              border: Border(
                                top: BorderSide(color: Colors.black, width: 1),
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text("ID: ${p.patientId}"),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: Text("Name: ${p.patientName}"),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text("Age: ${p.patientAge}"),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        "Weight: ${p.patientWeight} kg",
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        "Date : ${DateFormat('dd/MM/yyyy').format(p.date)}",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 245,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFB3CCCC),
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 18,
                                      bottom: 18,
                                      right: 18,
                                      left: 70,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        _leftText("O/E :"),
                                        const SizedBox(height: 12),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text("BP : ${p.bloodPressure}"),
                                              Text("Pulse : ${p.pulse}"),
                                              Text("Temp : ${p.temperature}"),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        _leftText("Problems :"),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            ...p.problems
                                                .split('.')
                                                .map((e) => e.trim())
                                                .where((e) => e.isNotEmpty)
                                                .map(
                                                  (e) => Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                  bottom: 6,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    const Text(
                                                      "•  ",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        e,
                                                        softWrap: true,
                                                        style:
                                                        const TextStyle(
                                                          height: 1.4,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 35),
                                        _leftText("Tests :"),
                                        const SizedBox(height: 8),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            ...p.tests.map(
                                                  (e) => Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 6,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "•  ",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        e,
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                          height: 1.4,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 18,
                                      right: 18,
                                      top: 5,
                                      bottom: 10,
                                    ),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return SingleChildScrollView(
                                          physics:
                                          const NeverScrollableScrollPhysics(),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minHeight: constraints.maxHeight,
                                            ),
                                            child: IntrinsicHeight(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "℞.",
                                                    style: TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  ...p.medicines.map(
                                                        (m) => Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                        left: 30,
                                                        bottom: 18,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                  "• ${m["type"]}. ",
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                  "${m["medicine"]}",
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                              left: 10,
                                                              right: 40,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    "${m["dose"]}",
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Padding(
                                                                    padding:
                                                                    const EdgeInsets.only(
                                                                      left:
                                                                      15,
                                                                    ),
                                                                    child: Text(
                                                                      "${m["doseTime"]}",
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 50,
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    "${m["duration"]}",
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                      left: 30,
                                                    ),
                                                    child: _leftText("উপদেশঃ"),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                      left: 38,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        ...p.advice
                                                            .split('.')
                                                            .map(
                                                              (e) => e.trim(),
                                                        )
                                                            .where(
                                                              (e) =>
                                                          e.isNotEmpty,
                                                        )
                                                            .map(
                                                              (e) => Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                              bottom: 6,
                                                            ),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                const Text(
                                                                  "•  ",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    fontWeight:
                                                                    FontWeight.w500,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    e,
                                                                    softWrap:
                                                                    true,
                                                                    style: const TextStyle(
                                                                      height:
                                                                      1.4,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                      left: 30,
                                                      bottom: 10,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                        bottom: 15,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const Text(
                                                            "ফলোআপঃ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                              left: 5,
                                                            ),
                                                            child: Text(
                                                              "• ${p.nextMeet}",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (hasDoctorBnVisitingTime)
                            Container(
                              width: double.infinity,
                              height: 50, // Adjust as needed
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFFACC),
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "রোগী দেখার সময় : ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: p.doctorBnVisitingTime ?? "",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _leftText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }
}
