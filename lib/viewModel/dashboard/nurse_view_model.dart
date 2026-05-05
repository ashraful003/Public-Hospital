import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
import '../../service/staff_service.dart';

enum NurseTab { all, active }

class NurseViewModel extends ChangeNotifier {
  final StaffService _service = StaffService();
  NurseTab _selectedTab = NurseTab.all;

  NurseTab get selectedTab => _selectedTab;
  List<UserModel> _allNurses = [];
  List<UserModel> _filteredNurses = [];

  List<UserModel> get nurses => _filteredNurses;
  bool isLoading = false;

  NurseViewModel() {
    loadNurses();
  }

  Future<void> loadNurses() async {
    isLoading = true;
    notifyListeners();
    try {
      if (_selectedTab == NurseTab.all) {
        _allNurses = await _service.fetchAllNurses();
      } else {
        _allNurses = await _service.fetchActiveNurses();
      }
      _filteredNurses = List.from(_allNurses);
    } catch (e) {
      _filteredNurses = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void changeTab(NurseTab tab) {
    _selectedTab = tab;
    loadNurses();
  }

  void searchByNationalId(String id) {
    final query = id.trim();
    if (query.isEmpty) {
      _filteredNurses = List.from(_allNurses);
    } else {
      _filteredNurses = _allNurses.where((nurse) {
        final nid = nurse.nationalId ?? '';
        return nid.contains(query);
      }).toList();
    }
    notifyListeners();
  }
}
