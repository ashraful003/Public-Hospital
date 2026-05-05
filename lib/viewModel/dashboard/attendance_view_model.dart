import 'dart:async';
import 'package:flutter/material.dart';
import '../../model/attendance_model.dart';
import '../../model/user_model.dart';
import '../../service/attendance_service.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceService _service = AttendanceService();
  UserModel? user;
  List<AttendanceModel> attendanceList = [];
  bool isLoading = false;
  Timer? _autoRefreshTimer;

  AttendanceViewModel() {
    loadTodayAttendance();
    _startAutoRefresh();
  }

  void _setLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }

  Future<void> loadUser(String id) async {
    try {
      user = await _service.getUser(id);
    } catch (_) {
      user = null;
    }
    notifyListeners();
  }

  Future<void> loadTodayAttendance() async {
    try {
      attendanceList = await _service.getTodayAttendance();
      notifyListeners();
    } catch (_) {}
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      loadTodayAttendance();
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<String> checkIn(String id) async {
    _setLoading(true);
    try {
      final res = await _service.checkIn(id);
      await loadTodayAttendance();
      return res;
    } finally {
      _setLoading(false);
    }
  }

  Future<String> checkOut(String id) async {
    _setLoading(true);
    try {
      final res = await _service.checkOut(id);
      await loadTodayAttendance();
      return res;
    } finally {
      _setLoading(false);
    }
  }

  void clearUser() {
    user = null;
    notifyListeners();
  }
}
