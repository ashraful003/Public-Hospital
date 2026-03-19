import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/user_model.dart';
import '../../view/dashboard/make_pdf_service.dart';

class MakePrescriptionViewModel extends ChangeNotifier {
  UserModel? doctor;
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
    doctor = UserModel(
      nationalId: "D-001",
      name: "Associate Prof. Dr. Md. Ashraful Alam",
      email: "doctor@hospital.com",
      phone: "01647000000",
      address: "Panthapath, Dhaka",
      dob: DateTime(1980, 5, 15),
      institute: "Dhaka Medical College & Hospital",
      degree: "MBBS, FCPS (Pediatrics)",
      specialist: "Cardiologist",
      isActive: true,
    );

    notifyListeners();
  }

  void loadPatient(String nationalId) {
    patient = UserModel(
      nationalId: nationalId,
      name: "MD. Ashraful Alam",
      address: "Dhaka",
      dob: DateTime(1997, 12, 12),
      weight: "",
      role: UserRole.patient,
    );

    notifyListeners();
  }

  List<String> _getMedicineList() {
    return medicineController.text
        .split('\n')
        .map((m) => m.trim())
        .where((m) => m.isNotEmpty)
        .toList();
  }

  bool _validateForm() {
    if (doctor == null || patient == null) {
      errorMessage = "Doctor or Patient not loaded";
      return false;
    }
    if (weightController.text.trim().isEmpty) {
      errorMessage = "Please enter patient weight";
      return false;
    }
    if (problemsController.text.trim().isEmpty) {
      errorMessage = "Please enter patient problems";
      return false;
    }
    if (_getMedicineList().isEmpty) {
      errorMessage = "Please add at least one medicine";
      return false;
    }
    return true;
  }

  Future<void> generatePrescription() async {
    if (!_validateForm()) {
      notifyListeners();
      return;
    }

    await MakePdfService.generatePrescription(
      doctor: doctor!,
      patient: patient!,
      weight: weightController.text,
      problems: problemsController.text,
      bloodPressure: bpController.text,
      medicines: _getMedicineList(),
    );

    isPdfGenerated = true;
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> submitToServer() async {
    if (!_validateForm()) {
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final body = {
        "doctor": {
          "name": doctor!.name,
          "degree": doctor!.degree,
          "specialist": doctor!.specialist,
          "hospital": doctor!.institute,
          "phone": doctor!.phone,
        },
        "patient": {
          "name": patient!.name,
          "nationalId": patient!.nationalId,
          "age": patient!.dob != null
              ? DateTime.now().year - patient!.dob!.year
              : null,
          "weight": weightController.text,
        },
        "complaints": problemsController.text,
        "bloodPressure": bpController.text,
        "medicines": _getMedicineList(),
        "date": DateTime.now().toIso8601String(),
      };

      const apiUrl = "https://your-server.com/api/prescriptions";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isSubmitted = true;
        isSubmitting = false;
        errorMessage = null;
        _clearForm();
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
      errorMessage = "Network error: $e";
      notifyListeners();
      return false;
    }
  }

  void _clearForm() {
    weightController.clear();
    problemsController.clear();
    bpController.clear();
    medicineController.clear();
    isPdfGenerated = false;
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
