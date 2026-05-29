import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../service/prescription_service.dart';

class MakePrescriptionViewModel extends ChangeNotifier {
  final PrescriptionService _service = PrescriptionService();
  UserModel? doctor;
  UserModel? patient;
  bool isLoading = false;
  bool isSubmitting = false;
  String? error;
  String? successMessage;
  List<String> medicineTypes = [];
  List<String> medicines = [];
  List<String> doses = [];
  List<String> doseTimes = [];
  List<String> durations = [];
  List<String> tests = [];
  List<String> nextMeetList = [];
  List<String> adviceList = [];
  final problemController = TextEditingController();
  final bpController = TextEditingController();
  final weightController = TextEditingController();
  final nextMeetController = TextEditingController();
  final pulseController = TextEditingController();
  final temperatureController = TextEditingController();
  final adviceController = TextEditingController();

  Future<void> load(String patientId) async {
    try {
      isLoading = true;
      notifyListeners();
      doctor = await _service.loadCurrentDoctor();
      patient = await _service.loadPatient(patientId);
      adviceList = await _service.loadAdvice(doctor!.nationalId!);
      medicines = await _service.loadMedicines();
      if (doctor?.nationalId != null && doctor!.nationalId!.trim().isNotEmpty) {
        medicineTypes = await _service.loadMedicineTypes(doctor!.nationalId!);
        doses = await _service.loadDoses(doctor!.nationalId!);
        doseTimes = await _service.loadDoseTimes(doctor!.nationalId!);
        durations = await _service.loadDurations(doctor!.nationalId!);
        adviceList = await _service.loadAdvice(doctor!.nationalId!);
        nextMeetList = await _service.loadNextMeet(doctor!.nationalId!);
      }
      tests = await _service.loadTests();
      weightController.text = patient?.weight ?? "";
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = "Load failed: $e";
      notifyListeners();
    }
  }

  Future<bool> submit({required List rxList, required List testList}) async {
    if (doctor == null || patient == null) {
      error = "Doctor or Patient not loaded";
      notifyListeners();
      return false;
    }
    final validRx = rxList
        .where(
          (e) =>
              e.type.toString().trim().isNotEmpty &&
              e.medicine.toString().trim().isNotEmpty &&
              e.dose.toString().trim().isNotEmpty &&
              e.doseTime.toString().trim().isNotEmpty &&
              e.duration.toString().trim().isNotEmpty,
        )
        .toList();
    final validTests = testList
        .where((e) => e.test.toString().trim().isNotEmpty)
        .toList();
    if (validRx.isEmpty) {
      error = "Please add at least one medicine";
      notifyListeners();
      return false;
    }
    try {
      isSubmitting = true;
      error = null;
      successMessage = null;
      notifyListeners();
      final body = {
        "doctorName": doctor?.name ?? "",
        "doctorDegree": doctor?.degree ?? "",
        "doctorSpecialist": doctor?.specialist ?? "",
        "doctorInstitute": doctor?.institute ?? "",
        "doctorLicense": doctor?.license ?? "",
        "patientId": patient?.nationalId ?? "",
        "patientName": patient?.name ?? "",
        "patientAge": patient?.age ?? "",
        "patientWeight": weightController.text.trim(),
        "problems": problemController.text.trim(),
        "bloodPressure": bpController.text.trim(),
        "pulse": pulseController.text.trim(),
        "temperature": temperatureController.text.trim(),
        "medicines": validRx.map((e) {
          return {
            "type": e.type,
            "medicine": e.medicine,
            "dose": e.dose,
            "doseTime": e.doseTime,
            "duration": e.duration,
          };
        }).toList(),
        "advice": adviceController.text.trim(),
        "tests": validTests.map((e) => e.test.toString()).toList(),
        "nextMeet": nextMeetController.text.trim(),
        "date": DateTime.now().toIso8601String(),
      };
      final ok = await _service.createPrescription(body);
      if (ok) {
        successMessage = "Prescription submitted successfully";
        clearAllFields(rxList, testList);
        isSubmitting = false;
        notifyListeners();
        return true;
      } else {
        error = "Prescription submit failed";
        isSubmitting = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isSubmitting = false;
      error = "Error: $e";
      notifyListeners();
      return false;
    }
  }

  void clearAllFields(List rxList, List testList) {
    problemController.clear();
    bpController.clear();
    pulseController.clear();
    temperatureController.clear();
    adviceController.clear();
    nextMeetController.clear();
    rxList.clear();
    testList.clear();
    notifyListeners();
  }

  @override
  @override
  void dispose() {
    problemController.dispose();
    bpController.dispose();
    pulseController.dispose();
    temperatureController.dispose();
    weightController.dispose();
    adviceController.dispose();
    nextMeetController.dispose();
    super.dispose();
  }
}
