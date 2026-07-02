import 'package:flutter/material.dart';
import '../../model/hospital_admission.dart';
import '../../service/hospital_admission_service.dart';

class AdmissionDetailsViewModel extends ChangeNotifier {
  final HospitalAdmissionService _service = HospitalAdmissionService();
  HospitalAdmission? _admission;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  HospitalAdmission? get admission => _admission;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  String get errorMessage => _errorMessage;

  Future<void> loadAdmission({required int admissionId}) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      _admission = await _service.getAdmissionById(admissionId);
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh({required int admissionId}) {
    return loadAdmission(admissionId: admissionId);
  }
}