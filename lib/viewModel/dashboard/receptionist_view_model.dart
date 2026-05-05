import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
import 'package:public_hospital/service/staff_service.dart';

enum ReceptionistTab { all, active }

class ReceptionistViewModel extends ChangeNotifier {
  final StaffService _service = StaffService();
  ReceptionistTab _selectedTab = ReceptionistTab.all;

  ReceptionistTab get selectedTab => _selectedTab;
  List<UserModel> _allReceptionists = [];
  List<UserModel> _activeReceptionists = [];
  List<UserModel> _filteredReceptionists = [];

  List<UserModel> get receptionists => _filteredReceptionists;
  bool isLoading = false;

  ReceptionistViewModel() {
    loadReceptionists();
  }

  Future<void> loadReceptionists() async {
    isLoading = true;
    notifyListeners();
    try {
      if (_allReceptionists.isEmpty) {
        _allReceptionists = await _service.fetchAllReceptionists();
      }
      if (_activeReceptionists.isEmpty) {
        _activeReceptionists = await _service.fetchActiveReceptionists();
      }
      _applyFilter();
    } catch (e) {
      _filteredReceptionists = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedTab == ReceptionistTab.all) {
      _filteredReceptionists = List.from(_allReceptionists);
    } else {
      _filteredReceptionists = List.from(_activeReceptionists);
    }
  }

  void changeTab(ReceptionistTab tab) {
    _selectedTab = tab;
    _applyFilter();
    notifyListeners();
  }

  void searchByNationalId(String id) {
    final query = id.trim();
    final baseList = _selectedTab == ReceptionistTab.all
        ? _allReceptionists
        : _activeReceptionists;
    if (query.isEmpty) {
      _filteredReceptionists = List.from(baseList);
    } else {
      _filteredReceptionists = baseList.where((r) {
        return (r.nationalId ?? '').contains(query);
      }).toList();
    }
    notifyListeners();
  }
}
