import 'package:flutter/material.dart';
import '../../model/hospital_admission.dart';
import '../../model/hospital_seat.dart';
import '../../service/hospital_admission_service.dart';
import '../../service/seat_service.dart';

class AdmissionTransferViewModel extends ChangeNotifier {
  final HospitalAdmissionService _admissionService = HospitalAdmissionService();
  final SeatService _seatService = SeatService();
  bool isLoading = false;
  bool isSubmitting = false;
  bool isLoadingSeatTypes = false;
  bool isLoadingAvailableSeats = false;
  String? errorMessage;
  int _admissionId = 0;

  int get admissionId => _admissionId;
  HospitalAdmission? admission;
  List<HospitalSeat> allSeats = [];
  List<String> admissionType = [];
  String? selectedSeatType;
  List<HospitalSeat> availableSeats = [];
  HospitalSeat? selectedSeat;
  final TextEditingController remarksController = TextEditingController();

  bool get isSeatNumberEnabled =>
      selectedSeatType != null &&
      selectedSeatType!.isNotEmpty &&
      !isLoadingAvailableSeats;

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
      admissionType = allSeats
          .map((s) => s.type ?? '')
          .where((t) => t.isNotEmpty && seen.add(t))
          .toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      isLoadingSeatTypes = false;
      notifyListeners();
    }
  }

  Future<void> selectSeatType(String? type) async {
    if (type == null || type.isEmpty || type == selectedSeatType) return;
    selectedSeatType = type;
    selectedSeat = null;
    availableSeats = [];
    isLoadingAvailableSeats = true;
    errorMessage = null;
    notifyListeners();
    try {
      availableSeats = await _seatService.getAvailableSeatsByType(type);
    } catch (e) {
      errorMessage = e.toString();
      availableSeats = [];
    } finally {
      isLoadingAvailableSeats = false;
      notifyListeners();
    }
  }

  void selectSeat(HospitalSeat? seat) {
    selectedSeat = seat;
    notifyListeners();
  }

  String? validate() {
    if (selectedSeatType == null || selectedSeatType!.isEmpty) {
      return 'Please select a seat type';
    }
    if (selectedSeat == null) {
      return 'Please select an available seat';
    }
    if (admission?.seatNo != null &&
        selectedSeat!.seatNo == admission!.seatNo) {
      return 'Patient is already in this seat';
    }
    return null;
  }

  Future<bool> submitTransfer() async {
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
        'newSeatNo': selectedSeat!.seatNo,
        'admissionType': selectedSeatType,
        'remarks': remarksController.text.trim(),
      };
      admission = await _admissionService.transferSeat(
        currentAdmission!.id!,
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
    remarksController.dispose();
    super.dispose();
  }
}
