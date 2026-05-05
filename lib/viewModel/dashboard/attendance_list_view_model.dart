import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/attendance_model.dart';
import '../../service/attendance_service.dart';

class AttendanceListViewModel extends ChangeNotifier {
  final AttendanceService _service = AttendanceService();
  List<AttendanceModel> _list = [];

  List<AttendanceModel> get list => _filteredList;
  List<AttendanceModel> _filteredList = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  final TextEditingController searchController = TextEditingController();
  String userRole = "";

  Future<void> init() async {
    await _loadRole();
    await loadAttendance();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString("user_role") ?? "";
    notifyListeners();
  }

  Future<void> loadAttendance() async {
    _isLoading = true;
    notifyListeners();
    try {
      _list = await _service.fetchAllAttendance();
      _filteredList = _list;
    } catch (e) {
      debugPrint(e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  void searchByNationalId(String query) {
    if (query.isEmpty) {
      _filteredList = _list;
    } else {
      _filteredList = _list
          .where(
            (item) =>
                item.nationalId.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  bool get isAdmin => userRole.trim().toUpperCase() == "ADMIN";
}
