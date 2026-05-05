import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
import 'package:public_hospital/service/staff_service.dart';

enum DriverTab { all, active }

class DriverViewModel extends ChangeNotifier {
  final StaffService _service = StaffService();
  DriverTab _selectedTab = DriverTab.all;

  DriverTab get selectedTab => _selectedTab;
  List<UserModel> _allDrivers = [];
  List<UserModel> _activeDrivers = [];
  List<UserModel> _filteredDrivers = [];

  List<UserModel> get drivers => _filteredDrivers;
  bool isLoading = false;

  DriverViewModel() {
    loadDrivers();
  }

  Future<void> loadDrivers() async {
    isLoading = true;
    notifyListeners();
    try {
      if (_allDrivers.isEmpty) {
        _allDrivers = await _service.fetchAllDrivers();
      }
      if (_activeDrivers.isEmpty) {
        _activeDrivers = await _service.fetchActiveDrivers();
      }
      _applyFilter();
    } catch (e) {
      _filteredDrivers = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedTab == DriverTab.all) {
      _filteredDrivers = List.from(_allDrivers);
    } else {
      _filteredDrivers = List.from(_activeDrivers);
    }
  }

  void changeTab(DriverTab tab) {
    _selectedTab = tab;
    _applyFilter();
    notifyListeners();
  }

  void searchByNationalId(String id) {
    final query = id.trim();
    final baseList = _selectedTab == DriverTab.all
        ? _allDrivers
        : _activeDrivers;
    if (query.isEmpty) {
      _filteredDrivers = List.from(baseList);
    } else {
      _filteredDrivers = baseList.where((d) {
        return (d.nationalId ?? '').contains(query);
      }).toList();
    }
    notifyListeners();
  }
}
