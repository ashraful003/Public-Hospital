import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
import 'package:public_hospital/service/staff_service.dart';

enum PharmacistTab { all, active }

class PharmacistViewModel extends ChangeNotifier {
  final StaffService _service = StaffService();
  PharmacistTab _selectedTab = PharmacistTab.all;

  PharmacistTab get selectedTab => _selectedTab;
  List<UserModel> _allPharmacists = [];
  List<UserModel> _activePharmacists = [];
  List<UserModel> _filteredPharmacists = [];

  List<UserModel> get pharmacists => _filteredPharmacists;
  bool isLoading = false;

  PharmacistViewModel() {
    loadPharmacists();
  }

  Future<void> loadPharmacists() async {
    isLoading = true;
    notifyListeners();
    try {
      if (_allPharmacists.isEmpty) {
        _allPharmacists = await _service.fetchAllPharmacists();
      }
      if (_activePharmacists.isEmpty) {
        _activePharmacists = await _service.fetchActivePharmacists();
      }
      _applyFilter();
    } catch (e) {
      _filteredPharmacists = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedTab == PharmacistTab.all) {
      _filteredPharmacists = List.from(_allPharmacists);
    } else {
      _filteredPharmacists = List.from(_activePharmacists);
    }
  }

  void changeTab(PharmacistTab tab) {
    _selectedTab = tab;
    _applyFilter();
    notifyListeners();
  }

  void searchByNationalId(String id) {
    final query = id.trim();
    final baseList = _selectedTab == PharmacistTab.all
        ? _allPharmacists
        : _activePharmacists;
    if (query.isEmpty) {
      _filteredPharmacists = List.from(baseList);
    } else {
      _filteredPharmacists = baseList.where((a) {
        return (a.nationalId ?? '').contains(query);
      }).toList();
    }
    notifyListeners();
  }
}
