import 'package:flutter/foundation.dart';
import '../../model/emergency_contact.dart';
import '../../service/emergency_contact_service.dart';

enum ViewState { idle, loading, success, error }

class EmergencyContactViewModel extends ChangeNotifier {
  final EmergencyContactService _service;

  EmergencyContactViewModel({EmergencyContactService? service})
    : _service = service ?? EmergencyContactService();
  List<EmergencyContact> _contacts = [];
  ViewState _state = ViewState.idle;
  String _errorMessage = '';

  List<EmergencyContact> get contacts => _contacts;

  ViewState get state => _state;

  String get errorMessage => _errorMessage;

  bool get isLoading => _state == ViewState.loading;

  bool get hasError => _state == ViewState.error;

  bool get hasData => _contacts.isNotEmpty;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<bool> createContact({
    required String emergencyNumber,
    required String emergencyDoctorNumber,
    required String emergencyDoctorWhatsappNumber,
  }) async {
    try {
      await _service.createEmergencyContact(
        emergencyNumber: emergencyNumber,
        emergencyDoctorNumber: emergencyDoctorNumber,
        emergencyDoctorWhatsappNumber: emergencyDoctorWhatsappNumber,
      );
      await fetchAllContacts();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchAllContacts() async {
    _setState(ViewState.loading);
    _errorMessage = '';
    try {
      _contacts = await _service.getAllEmergencyContacts();
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setState(ViewState.error);
    }
  }

  Future<bool> updateContact({
    required int id,
    required String emergencyNumber,
    required String emergencyDoctorNumber,
    required String emergencyDoctorWhatsappNumber,
  }) async {
    try {
      await _service.updateEmergencyContact(
        id: id,
        emergencyNumber: emergencyNumber,
        emergencyDoctorNumber: emergencyDoctorNumber,
        emergencyDoctorWhatsappNumber: emergencyDoctorWhatsappNumber,
      );
      await fetchAllContacts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteContact(int id) async {
    try {
      await _service.deleteEmergencyContact(id);
      await fetchAllContacts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void retry() => fetchAllContacts();

  void clearError() {
    _errorMessage = '';
    _setState(ViewState.idle);
  }
}