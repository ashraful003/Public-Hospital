import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_model.dart';
import '../../model/hospital_seat.dart';
import '../../service/profile_service.dart';
import '../../service/staff_service.dart';
import '../../service/seat_service.dart';
import '../../service/hospital_admission_service.dart';

class AdmissionPatientViewModel extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final StaffService _staffService = StaffService();
  final SeatService _seatService = SeatService();
  final HospitalAdmissionService _admissionService = HospitalAdmissionService();
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool isLoadingUser = false;
  String? userError;
  List<UserModel> doctors = [];
  bool isLoadingDoctors = false;
  String? doctorError;
  UserModel? selectedDoctor;
  List<HospitalSeat> _allSeats = [];
  List<String> seatTypes = [];
  bool isLoadingSeatTypes = false;
  String? seatTypeError;
  List<HospitalSeat> availableSeats = [];
  bool isLoadingSeats = false;
  String? seatError;
  String? selectedSeatType;
  HospitalSeat? selectedSeat;
  bool isSubmitting = false;
  String? submitError;
  bool submitSuccess = false;

  Future<void> init() async {
    await Future.wait([
      loadCurrentUserProfile(),
      loadDoctors(),
      loadSeatTypes(),
    ]);
  }

  Future<void> loadCurrentUserProfile() async {
    isLoadingUser = true;
    userError = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('remember_email');
      if (email == null || email.isEmpty) {
        throw Exception('No logged-in user found');
      }
      _currentUser = await _profileService.getProfile(email);
    } catch (e) {
      userError = e.toString();
    } finally {
      isLoadingUser = false;
      notifyListeners();
    }
  }

  Future<void> loadDoctors() async {
    isLoadingDoctors = true;
    doctorError = null;
    notifyListeners();
    try {
      doctors = await _staffService.fetchAllDoctors();
    } catch (e) {
      doctorError = e.toString();
    } finally {
      isLoadingDoctors = false;
      notifyListeners();
    }
  }

  void selectDoctor(UserModel doctor) {
    selectedDoctor = doctor;
    notifyListeners();
  }

  void clearDoctor() {
    selectedDoctor = null;
    notifyListeners();
  }

  Future<void> loadSeatTypes() async {
    isLoadingSeatTypes = true;
    seatTypeError = null;
    notifyListeners();
    try {
      _allSeats = await _seatService.getAllSeats();
      final types = _allSeats.map((s) => s.type).toSet().toList();
      types.sort();
      seatTypes = types;
    } catch (e) {
      seatTypeError = e.toString();
      seatTypes = [];
      _allSeats = [];
    } finally {
      isLoadingSeatTypes = false;
      notifyListeners();
    }
  }

  Future<void> loadAvailableSeats(String type) async {
    isLoadingSeats = true;
    seatError = null;
    notifyListeners();
    try {
      availableSeats = await _seatService.getAvailableSeatsByType(type);
    } catch (e) {
      seatError = e.toString();
      availableSeats = [];
    } finally {
      isLoadingSeats = false;
      notifyListeners();
    }
  }

  Future<void> selectSeatType(String type) async {
    if (selectedSeatType == type) return;
    selectedSeatType = type;
    selectedSeat = null;
    availableSeats = [];
    notifyListeners();
    await loadAvailableSeats(type);
  }

  void selectSeat(HospitalSeat seat) {
    selectedSeat = seat;
    notifyListeners();
  }

  void clearSeatSelection() {
    selectedSeatType = null;
    selectedSeat = null;
    availableSeats = [];
    notifyListeners();
  }

  Future<bool> submitAdmission({
    required String patientId,
    required String patientName,
    int? patientAge,
    double? patientWeight,
    required String patientAddress,
    required String diagnosis,
    required String remarks,
    DateTime? admissionDate,
    DateTime? expectedDischargeDate,
  }) async {
    submitError = null;
    submitSuccess = false;
    if (patientId.trim().isEmpty || patientName.trim().isEmpty) {
      submitError = 'Patient ID and Patient Name are required.';
      notifyListeners();
      return false;
    }
    if (selectedDoctor == null) {
      submitError = 'Please select an attending doctor.';
      notifyListeners();
      return false;
    }
    if (selectedSeatType == null || selectedSeat == null) {
      submitError = 'Please select a seat type and seat number.';
      notifyListeners();
      return false;
    }
    if (currentUser == null) {
      submitError = 'Could not identify the current user. Please retry.';
      notifyListeners();
      return false;
    }
    isSubmitting = true;
    notifyListeners();
    try {
      final Map<String, dynamic> body = {
        'patientId': patientId.trim(),
        'patientName': patientName.trim(),
        'patientAge': patientAge,
        'patientWeight': patientWeight,
        'patientAddress': patientAddress.trim(),
        'doctorId': selectedDoctor!.nationalId,
        'doctorName': selectedDoctor!.name,
        'seatNo': selectedSeat!.seatNo,
        'admissionType': selectedSeatType,
        'diagnosis': diagnosis.trim(),
        'remarks': remarks.trim(),
        'admissionDate': admissionDate?.toIso8601String(),
        'expectedDischargeDate': expectedDischargeDate?.toIso8601String(),
        'admitedById': currentUser!.nationalId,
        'admitedByName': currentUser!.name,
      };
      final message = await _admissionService.createAdmission(body);
      final lower = message.toLowerCase();
      if (lower.contains('already admitted') ||
          lower.contains('already occupied')) {
        submitError = message;
        return false;
      }
      availableSeats.removeWhere((seat) => seat.seatNo == selectedSeat!.seatNo);
      selectedSeat = null;
      submitSuccess = true;
      notifyListeners();
      return true;
    } catch (e) {
      submitError = e.toString();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void resetSubmitState() {
    submitError = null;
    submitSuccess = false;
    notifyListeners();
  }
}
