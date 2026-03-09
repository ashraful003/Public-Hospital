import 'package:flutter/material.dart';

import '../../model/attendance_model.dart';

enum AttendanceTab { list, attendance }

class AttendanceViewModel extends ChangeNotifier {
  AttendanceTab selectedTab = AttendanceTab.list;

  final List<AttendanceModel> _allStaff = [
    AttendanceModel(nationalId: "12345", name: "John Doe", date: getCurrentDate(), time: getCurrentTime()),
  ];

  List<AttendanceModel> attendanceList = [];

  AttendanceViewModel() {
    updateAttendanceList();
  }

  void changeTab(AttendanceTab tab) {
    selectedTab = tab;
    updateAttendanceList();
    notifyListeners();
  }

  void updateAttendanceList() {
    if (selectedTab == AttendanceTab.attendance) {
      // Show all staff in attendance tab
      attendanceList = List.from(_allStaff);
    } else {
      // List tab: only show checked-in staff
      attendanceList = _allStaff.where((e) => e.checkIn != null).toList();
    }
  }

  void searchByNationalId(String id) {
    if (id.isEmpty) {
      updateAttendanceList();
    } else {
      attendanceList = attendanceList.where((e) => e.nationalId.contains(id)).toList();
    }
    notifyListeners();
  }

  void checkIn(String nationalId) {
    final staff = _allStaff.firstWhere((e) => e.nationalId == nationalId);
    staff.checkIn = getCurrentTime();
    staff.isPresent = true;
    updateAttendanceList();
    notifyListeners();
  }

  void checkOut(String nationalId) {
    final staff = _allStaff.firstWhere((e) => e.nationalId == nationalId);
    staff.checkOut = getCurrentTime();
    updateAttendanceList();
    notifyListeners();
  }

  static String getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}";
  }

  static String getCurrentDate() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}";
  }
}