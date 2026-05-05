import 'package:flutter/material.dart';
import 'package:public_hospital/service/staff_service.dart';
import '../../model/user_model.dart';

enum DoctorTab { all, active }

class DoctorViewModel extends ChangeNotifier {
  final StaffService _service = StaffService();

  DoctorTab _selectedTab = DoctorTab.all;

  DoctorTab get selectedTab => _selectedTab;

  List<UserModel> _allDoctors = [];
  List<UserModel> _filteredDoctors = [];

  List<UserModel> get doctors => _filteredDoctors;

  bool isLoading = false;

  DoctorViewModel() {
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    isLoading = true;
    notifyListeners();

    try {
      if (_selectedTab == DoctorTab.all) {
        _allDoctors = await _service.fetchAllDoctors();
      } else {
        _allDoctors = await _service.fetchActiveDoctors();
      }

      _filteredDoctors = List.from(_allDoctors);
    } catch (e) {
      debugPrint("Doctor error: $e");
      _filteredDoctors = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void changeTab(DoctorTab tab) {
    _selectedTab = tab;
    loadDoctors();
  }

  void searchByNationalId(String id) {
    final query = id.trim();

    if (query.isEmpty) {
      _filteredDoctors = List.from(_allDoctors);
    } else {
      _filteredDoctors = _allDoctors.where((d) {
        final nid = d.nationalId ?? '';
        return nid.contains(query);
      }).toList();
    }

    notifyListeners();
  }
}
