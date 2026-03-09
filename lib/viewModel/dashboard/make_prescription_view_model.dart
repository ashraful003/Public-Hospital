import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/doctor_model.dart';
import '../../model/make_prescription_model.dart';
import '../../model/user_model.dart';
import '../../view/dashboard/make_pdf_service.dart';

class MakePrescriptionViewModel extends ChangeNotifier {
  DoctorModel? doctor;
  UserModel? patient;

  final weightController = TextEditingController();
  final problemsController = TextEditingController();
  final bpController = TextEditingController();
  final medicineController = TextEditingController();
  bool isPdfGenerated = false;
  bool isSubmitting = false;
  bool isSubmitted = false;
  String? errorMessage;

  void loadDoctor() {
    doctor = DoctorModel(
      name: "Associate Prof. Dr. Md. Ashraful Alam",
      degree: "MBBS, FCPS (Pediatrics)",
      hospital: "Public Hospital",
      address: "Panthapath, Dhaka",
      phone: "01647000000",
      dob: DateTime(1980, 5, 15),
      institute: 'Dhaka Medical College & Hospital',
      specialist: 'Cardiologist',
      isActive: false,
    );
    notifyListeners();
  }

  void loadPatient(String patientId) {
    patient = UserModel(
      name: "MD. Ashraful Alam",
      dob: DateTime(1997, 12, 12),
      patientId: patientId,
      email: '',
      phone: '',
      address: '',
      password: '',
      weight: '',
    );
    notifyListeners();
  }

  List<String> _getMedicineList() {
    return medicineController.text
        .split('\n')
        .where((m) => m.trim().isNotEmpty)
        .toList();
  }

  Future<void> generatePrescription() async {
    if (doctor == null || patient == null) return;

    final prescription = MakePrescriptionModel(
      doctor: doctor!,
      patient: patient!,
      weight: weightController.text,
      problems: problemsController.text,
      bloodPressure: bpController.text,
      medicines: _getMedicineList(),
      date: DateTime.now(),
    );

    await MakePdfService.generatePrescription(
      doctor: prescription.doctor,
      patient: prescription.patient,
      weight: prescription.weight,
      problems: prescription.problems,
      bloodPressure: prescription.bloodPressure,
      medicines: prescription.medicines,
    );

    isPdfGenerated = true;
    isSubmitted = false;
    errorMessage = null;

    notifyListeners();
  }

  Future<bool> submitToServer() async {
    if (doctor == null || patient == null) return false;

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> body = {
        "doctor": {
          "name": doctor!.name,
          "degree": doctor!.degree,
          "hospital": doctor!.hospital,
          "address": doctor!.address,
          "phone": doctor!.phone,
        },
        "patient": {
          "name": patient!.name,
          "patientId": patient!.patientId,
          "age": patient!.age,
          "weight": weightController.text,
        },
        "complaints": problemsController.text,
        "diagnosis": bpController.text,
        "medicines": _getMedicineList(),
        "date": DateTime.now().toIso8601String(),
      };
      const String apiUrl = "https://your-server.com/api/prescriptions";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isSubmitting = false;
        isSubmitted = true;
        errorMessage = null;
        notifyListeners();
        return true;
      } else {
        isSubmitting = false;
        isSubmitted = false;
        errorMessage = "Server error: ${response.statusCode}";
        notifyListeners();
        return false;
      }
    } catch (e) {
      isSubmitting = false;
      isSubmitted = false;
      errorMessage = "Failed to submit: $e";
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    problemsController.dispose();
    bpController.dispose();
    medicineController.dispose();
    super.dispose();
  }
}
