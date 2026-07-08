import 'package:flutter/material.dart';
import '../../model/doctor_bn.dart';
import '../../service/doctor_bn_service.dart';

class DoctorBnViewModel extends ChangeNotifier {
  final DoctorBnService _service = DoctorBnService();
  final String doctorId;

  DoctorBnViewModel({required this.doctorId});

  DoctorBn? doctor;
  bool isLoading = false;
  String? error;

  Future<void> loadDoctor() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      doctor = await _service.getDoctorProfile(doctorId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}