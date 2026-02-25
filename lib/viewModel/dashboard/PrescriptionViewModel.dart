import 'package:flutter/material.dart';
import 'package:public_hospital/model/PrescriptionModel.dart';

class PrescriptionViewModel extends ChangeNotifier {
  final String patientId;

  PrescriptionViewModel(String patientId)
      : patientId = patientId.trim() {
    fetchPrescriptions();
  }

  bool isLoading = false;
  List<PrescriptionModel> prescriptions = [];

  Future<void> fetchPrescriptions() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final allPrescriptions = [
      PrescriptionModel(
        id: "1",
        patientId: "123456",
        date: "20-02-2026",
        patientName: "John Doe",
        pdfUrl: "assets/MedicalReport.pdf",
      ),
      PrescriptionModel(
        id: "2",
        patientId: "123456",
        date: "22-02-2026",
        patientName: "John Doe",
        pdfUrl: "assets/TestReport.pdf",
      ),
      PrescriptionModel(
        id: "3",
        patientId: "999999",
        date: "25-02-2026",
        patientName: "Jane Smith",
        pdfUrl: "assets/MedicalReport.pdf",
      ),
    ];

    if (patientId.isEmpty) {
      prescriptions = allPrescriptions;
    } else {
      prescriptions =
          allPrescriptions.where((p) => p.patientId == patientId).toList();
    }

    isLoading = false;
    notifyListeners();
  }
}