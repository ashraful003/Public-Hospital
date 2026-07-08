import 'package:flutter/material.dart';
import '../../model/prescription_model.dart';
import '../../model/user_model.dart';
import '../../service/prescription_service.dart';

class PrescriptionUpdateViewModel extends ChangeNotifier {
  final PrescriptionService _service = PrescriptionService();
  PrescriptionModel? prescription;
  UserModel? currentDoctor;
  bool isLoading = false;
  bool isSaving = false;
  String? error;
  String? successMessage;
  List<String> medicinesList = [];
  List<String> medicineTypes = [];
  List<String> doses = [];
  List<String> doseTime = [];
  List<String> doseTimes = [];
  List<String> durations = [];
  List<String> testsList = [];
  List<String> adviceList = [];
  List<String> nextMeetList = [];
  final weightController = TextEditingController();
  final bpController = TextEditingController();
  final pulseController = TextEditingController();
  final temperatureController = TextEditingController();
  final problemController = TextEditingController();
  final adviceController = TextEditingController();
  final nextMeetController = TextEditingController();
  List<Map<String, dynamic>> medicines = [];
  List<String> tests = [];

  Future<void> load(int prescriptionId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      prescription = await _service.getPrescriptionById(prescriptionId);
      if (prescription == null) {
        error = "Prescription not found";
        isLoading = false;
        notifyListeners();
        return;
      }
      final p = prescription!;
      currentDoctor = await _service.loadCurrentDoctor();
      medicinesList = await _service.loadMedicines();
      testsList = await _service.loadTests();
      final nationalId = currentDoctor?.nationalId?.toString() ?? "";
      if (nationalId.isNotEmpty) {
        medicineTypes = await _service.loadMedicineTypes(nationalId);
        doses = await _service.loadDoses(nationalId);
        doseTimes = await _service.loadDoseTimes(nationalId);
        durations = await _service.loadDurations(nationalId);
        adviceList = await _service.loadAdvice(nationalId);
        nextMeetList = await _service.loadNextMeet(nationalId);
      }
      weightController.text = p.patientWeight;
      bpController.text = p.bloodPressure;
      pulseController.text = p.pulse;
      temperatureController.text = p.temperature;
      problemController.text = p.problems;
      adviceController.text = p.advice;
      nextMeetController.text = p.nextMeet;
      medicines = List<Map<String, dynamic>>.from(
        p.medicines.map(
              (e) => {
            "type": e["type"] ?? "",
            "medicine": e["medicine"] ?? "",
            "dose": e["dose"] ?? "",
            "doseTime": e["doseTime"] ?? "",
            "duration": e["duration"] ?? "",
            "instruction": e["instruction"] ?? "",
          },
        ),
      );
      tests = List<String>.from(p.tests);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = "Load failed : $e";
      notifyListeners();
    }
  }

  void addMedicine() {
    medicines.add({
      "type": "",
      "medicine": "",
      "dose": "",
      "duration": "",
      "instruction": "",
    });
    notifyListeners();
  }

  void removeMedicine(int index) {
    medicines.removeAt(index);
    notifyListeners();
  }

  void addTest() {
    tests.add("");
    notifyListeners();
  }

  void removeTest(int index) {
    tests.removeAt(index);
    notifyListeners();
  }

  Future<bool> updatePrescription() async {
    try {
      if (prescription == null) {
        return false;
      }
      isSaving = true;
      notifyListeners();
      final p = prescription!;
      final cleanMedicines = medicines
          .where(
            (e) =>
        (e["type"] ?? "").toString().trim().isNotEmpty &&
            (e["medicine"] ?? "").toString().trim().isNotEmpty &&
            (e["dose"] ?? "").toString().trim().isNotEmpty &&
            (e["duration"] ?? "").toString().trim().isNotEmpty,
      )
          .map(
            (e) => {
          "type": e["type"] ?? "",
          "medicine": e["medicine"] ?? "",
          "dose": e["dose"] ?? "",
          "doseTime": e["doseTime"] ?? "",
          "duration": e["duration"] ?? "",
          "instruction": e["instruction"] ?? "",
        },
      )
          .toList();

      if (cleanMedicines.isEmpty) {
        isSaving = false;
        error = "Add at least one valid medicine";
        notifyListeners();
        return false;
      }
      final cleanTests = tests
          .where((e) => e.toString().trim().isNotEmpty)
          .toList();

      // FIX: the previous body was missing every doctorBn* field.
      // The backend's PrescriptionRequest expects these too, and sending
      // them as null on update overwrites existing data / can violate
      // NOT NULL constraints in the DB, causing the backend to throw and
      // return a non-200 response -- even though the endpoint itself works
      // fine when tested manually with a complete payload.
      final body = {
        "doctorName": p.doctorName,
        "doctorBnName": p.doctorBnName,
        "doctorDegree": p.doctorDegree,
        "doctorBnDegree": p.doctorBnDegree,
        "doctorSpecialist": p.doctorSpecialist,
        "doctorBnSpecialist": p.doctorBnSpecialist,
        "doctorInstitute": p.doctorInstitute,
        "doctorBnInstitute": p.doctorBnInstitute,
        "doctorLicense": p.doctorLicense,
        "doctorBnLicense": p.doctorBnLicense,
        "doctorBnVisitingTime": p.doctorBnVisitingTime,
        "patientId": p.patientId,
        "patientName": p.patientName,
        "patientAge": p.patientAge,
        "patientWeight": weightController.text.trim(),
        "problems": problemController.text.trim(),
        "bloodPressure": bpController.text.trim(),
        "pulse": pulseController.text.trim(),
        "temperature": temperatureController.text.trim(),
        "medicines": cleanMedicines,
        "tests": cleanTests,
        "advice": adviceController.text.trim(),
        "nextMeet": nextMeetController.text.trim(),
        "date": p.date.toIso8601String(),
      };
      final ok = await _service.updatePrescriptionById(p.id, body);
      isSaving = false;
      if (!ok) {
        // FIX: this `error` now only represents a save-time failure.
        // The screen checks `vm.prescription == null` before showing the
        // full-page error state, so a failed save shows a SnackBar instead
        // of wiping the whole form off the screen.
        error = "Update failed";
        notifyListeners();
        return false;
      }
      successMessage = "Updated successfully";
      error = null;
      notifyListeners();
      return true;
    } catch (e) {
      isSaving = false;
      error = "Exception: $e";
      notifyListeners();
      return false;
    }
  }

  void clearAll() {
    weightController.clear();
    bpController.clear();
    pulseController.clear();
    temperatureController.clear();
    problemController.clear();
    adviceController.clear();
    nextMeetController.clear();
    medicines.clear();
    tests.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    weightController.dispose();
    bpController.dispose();
    pulseController.dispose();
    temperatureController.dispose();
    problemController.dispose();
    adviceController.dispose();
    nextMeetController.dispose();
    super.dispose();
  }
}
