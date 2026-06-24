import 'package:flutter/foundation.dart';
import '../../model/appointment_schedule_model.dart';
import '../../service/appointment_schedule_service.dart';

enum ViewState { idle, loading, success, error }

class AppointmentScheduleViewModel extends ChangeNotifier {
  final AppointmentScheduleService _service = AppointmentScheduleService();
  List<AppointmentSchedule> _appointments = [];
  List<AppointmentSchedule> _filteredAppointments = [];
  ViewState _state = ViewState.idle;
  String _errorMessage = "";
  String _searchQuery = "";
  bool _isUpdating = false;
  String _updateErrorMessage = "";
  bool _isCreating = false;
  String _createErrorMessage = "";
  String? userRole;
  String? nationalId;

  List<AppointmentSchedule> get appointments => _filteredAppointments;

  ViewState get state => _state;

  String get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;

  bool get isUpdating => _isUpdating;

  String get updateErrorMessage => _updateErrorMessage;

  bool get isCreating => _isCreating;

  String get createErrorMessage => _createErrorMessage;

  void init({required String role, String? nationalId}) {
    userRole = role;
    this.nationalId = nationalId;
    fetchAppointments();
  }

  Future<bool> createAppointment({
    required String nationalId,
    required String day,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    _isCreating = true;
    _createErrorMessage = "";
    notifyListeners();
    try {
      final AppointmentSchedule created = await _service.createAppointment(
        nationalId: nationalId,
        day: day,
        date: date,
        startTime: startTime,
        endTime: endTime,
      );
      _appointments.add(created);
      _sortAppointmentsLatestFirst();
      _applySearchFilter();
      _isCreating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _createErrorMessage = e.toString();
      _isCreating = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchAppointments() async {
    _state = ViewState.loading;
    notifyListeners();
    try {
      if (nationalId != null) {
        _appointments = await _service.getAppointmentsByNationalId(nationalId!);
      } else {
        _appointments = [];
      }
      _sortAppointmentsLatestFirst();
      _applySearchFilter();
      _state = ViewState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  void _sortAppointmentsLatestFirst() {
    _appointments.sort((a, b) {
      final DateTime? dateA = _combineDateTime(a);
      final DateTime? dateB = _combineDateTime(b);
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateB.compareTo(dateA);
    });
  }

  DateTime? _combineDateTime(AppointmentSchedule appt) {
    try {
      final DateTime date = appt.date;
      final String time = appt.startTime.toString();
      final RegExp timeRegex = RegExp(r'^(\d{1,2}):(\d{2})');
      final match = timeRegex.firstMatch(time);
      if (match != null) {
        final int hour = int.parse(match.group(1)!);
        final int minute = int.parse(match.group(2)!);
        return DateTime(date.year, date.month, date.day, hour, minute);
      }
      return date;
    } catch (_) {
      return null;
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applySearchFilter();
    notifyListeners();
  }

  void _applySearchFilter() {
    if (_searchQuery.trim().isEmpty) {
      _filteredAppointments = List.from(_appointments);
      return;
    }
    final String q = _searchQuery.toLowerCase();
    _filteredAppointments = _appointments.where((appt) {
      final String day = appt.day.toString().toLowerCase();
      final String date = appt.formattedDate.toString().toLowerCase();
      final String start = appt.startTime.toString().toLowerCase();
      final String end = appt.endTime.toString().toLowerCase();
      return day.contains(q) ||
          date.contains(q) ||
          start.contains(q) ||
          end.contains(q);
    }).toList();
  }

  Future<void> deleteAppointment(AppointmentSchedule appt) async {
    try {
      await _service.deleteAppointment(appt.id);
      _appointments.removeWhere((a) => a.id == appt.id);
      _applySearchFilter();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
      notifyListeners();
    }
  }

  Future<bool> updateAppointment({
    required AppointmentSchedule original,
    required String nationalId,
    required String day,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    _isUpdating = true;
    _updateErrorMessage = "";
    notifyListeners();
    try {
      final AppointmentSchedule updated = await _service.updateAppointment(
        original.id,
        nationalId: nationalId,
        day: day,
        date: date,
        startTime: startTime,
        endTime: endTime,
      );
      final int index = _appointments.indexWhere((a) => a.id == original.id);
      if (index != -1) {
        _appointments[index] = updated;
      }
      _sortAppointmentsLatestFirst();
      _applySearchFilter();
      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _updateErrorMessage = e.toString();
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  void clearUpdateError() {
    _updateErrorMessage = "";
  }

  void clearCreateError() {
    _createErrorMessage = "";
  }

  Future<void> refresh() async {
    await fetchAppointments();
  }
}
