import 'package:flutter/material.dart';
import 'package:public_hospital/service/staff_service.dart';
import '../../model/user_model.dart';

enum DoctorAssistantTab { all, active }

class DoctorAssistantViewModel extends ChangeNotifier {
  final StaffService _service = StaffService();
  DoctorAssistantTab _selectedTab = DoctorAssistantTab.all;

  DoctorAssistantTab get selectedTab => _selectedTab;
  List<UserModel> _allAssistants = [];
  List<UserModel> _activeAssistants = [];
  List<UserModel> _filteredAssistants = [];

  List<UserModel> get assistants => _filteredAssistants;
  bool isLoading = false;

  DoctorAssistantViewModel() {
    loadAssistants();
  }

  Future<void> loadAssistants() async {
    isLoading = true;
    notifyListeners();
    try {
      if (_allAssistants.isEmpty) {
        _allAssistants = await _service.fetchAllDoctorAssistant();
      }
      if (_activeAssistants.isEmpty) {
        _activeAssistants = await _service.fetchActiveDoctorAssistant();
      }
      _applyFilter();
    } catch (e) {
      _filteredAssistants = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void changeTab(DoctorAssistantTab tab) {
    _selectedTab = tab;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedTab == DoctorAssistantTab.all) {
      _filteredAssistants = List.from(_allAssistants);
    } else {
      _filteredAssistants = List.from(_activeAssistants);
    }
  }

  void searchByNationalId(String id) {
    final query = id.trim();
    final baseList = _selectedTab == DoctorAssistantTab.all
        ? _allAssistants
        : _activeAssistants;
    if (query.isEmpty) {
      _filteredAssistants = List.from(baseList);
    } else {
      _filteredAssistants = baseList.where((a) {
        return (a.nationalId ?? '').contains(query);
      }).toList();
    }
    notifyListeners();
  }
}
