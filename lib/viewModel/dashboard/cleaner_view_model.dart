import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
import 'package:public_hospital/service/staff_service.dart';

enum CleanerTab { all, active }

class CleanerViewModel extends ChangeNotifier {
  final StaffService _service = StaffService();
  CleanerTab _selectedTab = CleanerTab.all;

  CleanerTab get selectedTab => _selectedTab;
  List<UserModel> _allCleaners = [];
  List<UserModel> _activeCleaners = [];
  List<UserModel> _filteredCleaners = [];

  List<UserModel> get cleaners => _filteredCleaners;
  bool isLoading = false;

  CleanerViewModel() {
    loadCleaners();
  }

  Future<void> loadCleaners() async {
    isLoading = true;
    notifyListeners();
    try {
      if (_allCleaners.isEmpty) {
        _allCleaners = await _service.fetchAllCleaners();
      }
      if (_activeCleaners.isEmpty) {
        _activeCleaners = await _service.fetchActiveCleaners();
      }
      _applyFilter();
    } catch (e) {
      _filteredCleaners = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedTab == CleanerTab.all) {
      _filteredCleaners = List.from(_allCleaners);
    } else {
      _filteredCleaners = List.from(_activeCleaners);
    }
  }

  void changeTab(CleanerTab tab) {
    _selectedTab = tab;
    _applyFilter();
    notifyListeners();
  }

  void searchByNationalId(String id) {
    final query = id.trim();
    final baseList = _selectedTab == CleanerTab.all
        ? _allCleaners
        : _activeCleaners;
    if (query.isEmpty) {
      _filteredCleaners = List.from(baseList);
    } else {
      _filteredCleaners = baseList.where((c) {
        return (c.nationalId ?? '').contains(query);
      }).toList();
    }
    notifyListeners();
  }
}
