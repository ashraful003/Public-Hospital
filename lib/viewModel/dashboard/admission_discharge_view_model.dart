import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/hospital_admission.dart';
import '../../model/user_model.dart';
import '../../service/hospital_admission_service.dart';
import '../../service/profile_service.dart';

class AdmissionDischargeViewModel extends ChangeNotifier {
  final HospitalAdmissionService _service = HospitalAdmissionService();
  final ProfileService _profileService = ProfileService();
  HospitalAdmission? _admission;

  HospitalAdmission? get admission => _admission;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;
  bool _hasError = false;

  bool get hasError => _hasError;
  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  bool _submitSuccess = false;

  bool get submitSuccess => _submitSuccess;
  String _submitError = '';

  String get submitError => _submitError;
  final remarksController = TextEditingController();

  String get dischargedByName => _currentUser?.name ?? '—';

  String? get dischargedById => _currentUser?.nationalId;

  Future<void> loadAdmission({required int admissionId}) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    try {
      final results = await Future.wait([
        _service.getAdmissionById(admissionId),
        _loadCurrentUserProfile(),
      ]);
      _admission = results[0] as HospitalAdmission;
      remarksController.text = _admission?.remarks ?? '';
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCurrentUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('remember_email');
    if (email == null || email.isEmpty) {
      throw Exception('No logged-in user found');
    }
    final user = await _profileService.getProfile(email);
    _currentUser = user;
  }

  Future<void> refresh({required int admissionId}) async {
    await loadAdmission(admissionId: admissionId);
  }

  bool get isAlreadyDischarged =>
      (_admission?.status ?? '').trim().toLowerCase() == 'discharged';

  String? validate() {
    if (_currentUser == null) {
      return 'Unable to identify the current user. Please re-login.';
    }
    return null;
  }

  Future<bool> submitDischarge({required int admissionId}) async {
    final validationError = validate();
    if (validationError != null) {
      _submitSuccess = false;
      _submitError = validationError;
      notifyListeners();
      return false;
    }
    _isSubmitting = true;
    _submitSuccess = false;
    _submitError = '';
    notifyListeners();
    try {
      final requestBody = {
        'dischargedByName': dischargedByName,
        'dischargedById': dischargedById,
        'remarks': remarksController.text.trim(),
      };
      await _service.dischargePatient(admissionId, requestBody);
      _submitSuccess = true;
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _submitSuccess = false;
      _submitError = e.toString().replaceFirst('Exception: ', '');
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }
}
