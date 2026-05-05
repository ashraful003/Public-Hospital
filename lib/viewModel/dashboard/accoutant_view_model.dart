import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
import 'package:public_hospital/service/staff_service.dart';

enum AccountantTab { all, active }

class AccountantViewModel extends ChangeNotifier {
  final StaffService _service = StaffService();
  AccountantTab _selectedTab = AccountantTab.all;

  AccountantTab get selectedTab => _selectedTab;
  List<UserModel> _allAccountants = [];
  List<UserModel> _activeAccountants = [];
  List<UserModel> _filteredAccountants = [];

  List<UserModel> get accountants => _filteredAccountants;
  bool isLoading = false;

  AccountantViewModel() {
    loadAccountants();
  }

  Future<void> loadAccountants() async {
    isLoading = true;
    notifyListeners();
    try {
      if (_allAccountants.isEmpty) {
        _allAccountants = await _service.fetchAllAccountants();
      }
      if (_activeAccountants.isEmpty) {
        _activeAccountants = await _service.fetchActiveAccountants();
      }
      _applyFilter();
    } catch (e) {
      _filteredAccountants = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void changeTab(AccountantTab tab) {
    _selectedTab = tab;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedTab == AccountantTab.all) {
      _filteredAccountants = List.from(_allAccountants);
    } else {
      _filteredAccountants = List.from(_activeAccountants);
    }
  }

  void searchByNationalId(String id) {
    final query = id.trim();
    final baseList = _selectedTab == AccountantTab.all
        ? _allAccountants
        : _activeAccountants;
    if (query.isEmpty) {
      _filteredAccountants = List.from(baseList);
    } else {
      _filteredAccountants = baseList.where((a) {
        return (a.nationalId ?? '').contains(query);
      }).toList();
    }
    notifyListeners();
  }
}
