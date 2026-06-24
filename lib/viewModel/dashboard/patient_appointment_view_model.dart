import 'package:flutter/material.dart';
import '../../model/appointment_model.dart';
import '../../service/appointment_service.dart';

enum ViewState { idle, loading, success, error }

class PatientAppointmentViewModel extends ChangeNotifier {
  final AppointmentService _appointmentService = AppointmentService();
  ViewState _state = ViewState.idle;

  ViewState get state => _state;
  List<AppointmentModel> _allAppointments = [];
  List<AppointmentModel> _appointments = [];

  List<AppointmentModel> get appointments => _appointments;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  bool _showToday = true;

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void toggleView(bool showToday) {
    _showToday = showToday;
    _applyFilter();
  }

  void _applyFilter() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _appointments = _allAppointments.where((item) {
      final rawDate = DateTime.tryParse(item.date ?? "");
      if (rawDate == null) return false;
      final itemDate = DateTime(rawDate.year, rawDate.month, rawDate.day);
      final status = item.status?.toUpperCase() ?? "";
      final isToday = itemDate.isAtSameMomentAs(today);
      final isTodayOrBefore = !itemDate.isAfter(today);
      if (_showToday) {
        return isToday && status == "WAITING";
      } else {
        return isTodayOrBefore &&
            (status == "CANCELLED" ||
                status == "REJECTED" ||
                status == "VISITED");
      }
    }).toList();
    if (_showToday) {
      _appointments.sort((a, b) {
        final dateA = DateTime.tryParse(a.date ?? "") ?? DateTime(1900);
        final dateB = DateTime.tryParse(b.date ?? "") ?? DateTime(1900);
        final dateCompare = dateA.compareTo(dateB);
        if (dateCompare != 0) {
          return dateCompare;
        }
        return (a.id ?? 0).compareTo(b.id ?? 0);
      });
    } else {
      _appointments.sort((a, b) {
        final dateA = DateTime.tryParse(a.date ?? "") ?? DateTime(1900);
        final dateB = DateTime.tryParse(b.date ?? "") ?? DateTime(1900);
        final dateCompare = dateB.compareTo(dateA);
        if (dateCompare != 0) {
          return dateCompare;
        }
        return (b.id ?? 0).compareTo(a.id ?? 0);
      });
    }
    notifyListeners();
  }

  Future<void> fetchAppointments({
    required String userId,
    required String role,
  }) async {
    _setState(ViewState.loading);
    try {
      List<AppointmentModel> result;
      result = await _appointmentService.getAppointmentsByDoctor(userId);
      _allAppointments = result;
      _applyFilter();
      _errorMessage = null;
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  Future<void> updateStatus({
    required int appointmentId,
    required String status,
    String? reason,
    required String userId,
    required String role,
  }) async {
    await _appointmentService.updateAppointmentStatus(
      appointmentId: appointmentId,
      status: status,
      reason: reason,
    );
    await fetchAppointments(userId: userId, role: role);
  }

  Future<void> refresh({required String userId, required String role}) async {
    await fetchAppointments(userId: userId, role: role);
  }
}
