import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/DoctorModel.dart';
import '../../model/UserModel.dart';
import '../../view/dashboard/MakePdfService.dart';

class MakePrescriptionViewModel extends ChangeNotifier {
  DoctorModel? doctor;
  UserModel? patient;

  final weightController = TextEditingController();
  final complaintsController = TextEditingController();
  final diagnosisController = TextEditingController();
  final medicineController = TextEditingController();

  // ✅ Track states
  bool isPdfGenerated = false;
  bool isSubmitting = false;
  bool isSubmitted = false;
  String? errorMessage;

  void loadDoctor() {
    doctor = DoctorModel(
      name: "Associate Prof. Dr. Md. Shah Jahan",
      degree: "MBBS, FCPS (Pediatrics)",
      hospital: "BRB Hospitals Limited",
      address: "77/A Panthapath, Dhaka",
      phone: "01647XXXXXX",
    );
    notifyListeners();
  }

  void loadPatient(String patientId) {
    patient = UserModel(
      name: "MD. Anas",
      dob: DateTime(2025, 6, 5),
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

  // ✅ Generate PDF
  Future<void> generatePrescription() async {
    if (doctor == null || patient == null) return;

    await MakePdfService.generatePrescription(
      doctor: doctor!,
      patient: patient!,
      weight: weightController.text,
      complaints: complaintsController.text,
      diagnosis: diagnosisController.text,
      medicines: _getMedicineList(),
    );

    isPdfGenerated = true;
    isSubmitted = false;
    errorMessage = null;
    notifyListeners();
  }

  // ✅ Submit prescription data to server
  Future<bool> submitToServer() async {
    if (doctor == null || patient == null) return false;

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Build the request body
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
        "complaints": complaintsController.text,
        "diagnosis": diagnosisController.text,
        "medicines": _getMedicineList(),
        "date": DateTime.now().toIso8601String(),
      };

      // ✅ Replace with your actual server URL
      const String apiUrl = "https://your-server.com/api/prescriptions";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer YOUR_TOKEN", // if needed
        },
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
    complaintsController.dispose();
    diagnosisController.dispose();
    medicineController.dispose();
    super.dispose();
  }
}