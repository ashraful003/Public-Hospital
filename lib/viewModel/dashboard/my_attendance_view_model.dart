import 'package:flutter/material.dart';
import '../../model/attendance_model.dart';
import '../../service/attendance_service.dart';

class MyAttendanceViewModel extends ChangeNotifier {
  final AttendanceService _service = AttendanceService();
  List<AttendanceModel> attendanceList = [];
  bool isLoading = false;
  String? error;

  Future<void> loadMyAttendance(String nationalId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      attendanceList = await _service.fetchMyAttendance(nationalId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
