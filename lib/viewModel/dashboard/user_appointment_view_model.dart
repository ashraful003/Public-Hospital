import 'package:flutter/material.dart';
import '../../model/appointment_model.dart';
import '../../service/appointment_service.dart';

enum ViewState { idle, loading, success, error }

class UserAppointmentViewModel extends ChangeNotifier {
  final AppointmentService _appointmentService = AppointmentService();
  ViewState _state = ViewState.idle;

  ViewState get state => _state;
  List<AppointmentModel> _allAppointments = [];
  List<AppointmentModel> _appointments = [];

  List<AppointmentModel> get appointments => _appointments;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  bool _showCurrent = true;

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> fetchAppointments(String patientId) async {
    _setState(ViewState.loading);
    try {
      final result = await _appointmentService.getAppointmentsByPatient(
        patientId,
      );
      _allAppointments = result;
      _applyFilter();
      _errorMessage = null;
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  void toggleView(bool current) {
    _showCurrent = current;
    _applyFilter();
  }

  void _applyFilter() {
    _appointments = _allAppointments.where((item) {
      final status = item.status?.toUpperCase() ?? "";
      if (_showCurrent) {
        return status == "WAITING";
      }
      return status == "VISITED" ||
          status == "CANCELLED" ||
          status == "REJECTED";
    }).toList();
    if (_showCurrent) {
      _appointments.sort((a, b) {
        final dateA = DateTime.tryParse(a.date ?? "") ?? DateTime(1900);
        final dateB = DateTime.tryParse(b.date ?? "") ?? DateTime(1900);
        return dateA.compareTo(dateB);
      });
    } else {
      _appointments.sort((a, b) {
        final dateA = DateTime.tryParse(a.date ?? "") ?? DateTime(1900);
        final dateB = DateTime.tryParse(b.date ?? "") ?? DateTime(1900);
        return dateB.compareTo(dateA);
      });
    }
    notifyListeners();
  }

  Future<void> refresh(String patientId) async {
    await fetchAppointments(patientId);
  }
}
