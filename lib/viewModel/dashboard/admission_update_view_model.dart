import 'package:flutter/material.dart';
import '../../model/hospital_admission.dart';
import '../../model/hospital_seat.dart';
import '../../model/user_model.dart';
import '../../service/hospital_admission_service.dart';
import '../../service/seat_service.dart';
import '../../service/staff_service.dart';

class AdmissionUpdateViewModel extends ChangeNotifier {
  final HospitalAdmissionService _admissionService = HospitalAdmissionService();
  final SeatService _seatService = SeatService();
  final StaffService _staffService = StaffService();
  bool isLoading = false;
  bool isSubmitting = false;
  bool isLoadingDoctors = false;
  bool isLoadingAvailableSeats = false;
  String? errorMessage;
  int _admissionId = 0;

  int get admissionId => _admissionId;
  HospitalAdmission? admission;
  List<UserModel> doctors = [];
  UserModel? selectedDoctor;
  dynamic _prefilledDoctorId;
  final TextEditingController doctorNameController = TextEditingController();
  List<HospitalSeat> allSeats = [];
  List<String> seatTypes = [];
  bool isLoadingSeatTypes = false;
  String? selectedSeatType;
  List<HospitalSeat> availableSeats = [];
  HospitalSeat? selectedSeat;
  dynamic _prefilledSeatNo;
  DateTime? expectedDischargeDate;
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  Future<void> init(int admissionId) async {
    _admissionId = admissionId;
    isLoading = true;
    isLoadingSeatTypes = true;
    errorMessage = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _admissionService.getAdmissionById(admissionId),
        _seatService.getAllSeats(),
      ]);
      admission = results[0] as HospitalAdmission;
      allSeats = results[1] as List<HospitalSeat>;
      final seen = <String>{};
      seatTypes = allSeats
          .map((s) => s.type ?? '')
          .where((t) => t.isNotEmpty && seen.add(t))
          .toList();
      loadAdmission();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      isLoadingSeatTypes = false;
      notifyListeners();
    }
  }

  void loadAdmission() {
    final a = admission;
    if (a == null) return;
    diagnosisController.text = a.diagnosis ?? '';
    remarksController.text = a.remarks ?? '';
    expectedDischargeDate = a.expectedDischargeDate;
    _prefilledDoctorId = a.doctorId;
    doctorNameController.text = a.doctorName ?? '';
    _prefilledSeatNo = a.seatNo;
    if (a.admissionType != null && a.admissionType!.isNotEmpty) {
      final normalized = a.admissionType!.trim().toLowerCase();
      final matchedType = seatTypes.firstWhere(
        (t) => t.trim().toLowerCase() == normalized,
        orElse: () => '',
      );
      selectedSeatType = matchedType.isNotEmpty ? matchedType : a.admissionType;
    }
  }

  Future<void> loadDoctors() async {
    if (doctors.isNotEmpty || isLoadingDoctors) return;
    isLoadingDoctors = true;
    errorMessage = null;
    notifyListeners();
    try {
      doctors = await _staffService.fetchAllDoctors();
      _matchPrefilledDoctor();
    } catch (e) {
      errorMessage = e.toString();
      doctors = [];
    } finally {
      isLoadingDoctors = false;
      notifyListeners();
    }
  }

  void _matchPrefilledDoctor() {
    if (_prefilledDoctorId == null || doctors.isEmpty) return;
    final match = doctors
        .where(
          (d) =>
              d.id != null && d.id.toString() == _prefilledDoctorId.toString(),
        )
        .toList();
    if (match.isNotEmpty) {
      selectedDoctor = match.first;
      if (selectedDoctor!.name != null && selectedDoctor!.name!.isNotEmpty) {
        doctorNameController.text = selectedDoctor!.name!;
      }
    }
  }

  void selectDoctor(UserModel? doctor) {
    selectedDoctor = doctor;
    doctorNameController.text = doctor?.name ?? '';
    notifyListeners();
  }

  String? get selectedDoctorIdentifier =>
      selectedDoctor?.nationalId ?? selectedDoctor?.id?.toString();

  void setExpectedDischargeDate(DateTime date) {
    expectedDischargeDate = date;
    notifyListeners();
  }

  String? validate() {
    if (selectedDoctor == null) return 'Please select a doctor';
    if (expectedDischargeDate == null) {
      return 'Please pick an expected discharge date';
    }
    return null;
  }

  Future<bool> submitUpdate() async {
    final validationError = validate();
    if (validationError != null) {
      errorMessage = validationError;
      notifyListeners();
      return false;
    }
    final currentAdmission = admission;
    if (currentAdmission?.id == null) {
      errorMessage = 'Missing admission id';
      notifyListeners();
      return false;
    }
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();
    try {
      final body = {
        'patientName': currentAdmission!.patientName,
        'patientAge': currentAdmission.patientAge,
        'patientWeight': currentAdmission.patientWeight,
        'patientAddress': currentAdmission.patientAddress,
        'doctorId': selectedDoctor!.nationalId,
        'doctorName': selectedDoctor!.name,
        'diagnosis': diagnosisController.text.trim(),
        'remarks': remarksController.text.trim(),
        'expectedDischargeDate': expectedDischargeDate?.toIso8601String(),
      };
      admission = await _admissionService.updateAdmission(
        currentAdmission.id!,
        body,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    diagnosisController.dispose();
    remarksController.dispose();
    doctorNameController.dispose();
    super.dispose();
  }
}
