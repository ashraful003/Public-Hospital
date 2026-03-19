import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';

enum NurseTab { all, active }

class NurseViewModel extends ChangeNotifier {

  NurseTab _selectedTab = NurseTab.all;
  NurseTab get selectedTab => _selectedTab;

  final List<UserModel> _allNurses = [
    UserModel(
      nationalId: '123456',
      name: 'Jobayer',
      email: 'jobayer@gmail.com',
      address: 'West Rajabazar, Dhaka-1215',
      phone: '01700000000',
      dob: DateTime(1998, 12, 12),
      institute: 'Dhaka Medical College & Hospital',
      degree: 'BSc in Nursing',
      license: '12345678',
      imageUrl: 'assets/images/logo.png',
      isActive: true,
      role: UserRole.nurse,
    ),
    UserModel(
      nationalId: '98765432',
      name: 'Milon',
      email: 'milon@gmail.com',
      address: 'West Rajabazar, Dhaka-1215',
      phone: '01700000000',
      dob: DateTime(1998, 12, 12),
      institute: 'Dhaka Medical College & Hospital',
      degree: 'BSc in Nursing',
      license: '12345678',
      imageUrl: 'assets/images/logo.png',
      isActive: false,
      role: UserRole.nurse,
    ),
  ];

  List<UserModel> _filteredNurses = [];
  List<UserModel> get nurses => _filteredNurses;

  NurseViewModel() {
    _filteredNurses = List.from(_allNurses);
  }

  List<UserModel> _getBaseList() {
    if (_selectedTab == NurseTab.all) {
      return _allNurses;
    } else {
      return _allNurses.where((n) => n.isActive == true).toList();
    }
  }

  void changeTab(NurseTab tab) {
    _selectedTab = tab;
    _filteredNurses = _getBaseList();
    notifyListeners();
  }

  void searchByNationalId(String id) {

    final query = id.trim();

    final baseList = _getBaseList();

    if (query.isEmpty) {
      _filteredNurses = baseList;
    } else {
      _filteredNurses = baseList.where((nurse) {
        final nid = nurse.nationalId ?? '';
        return nid.contains(query);
      }).toList();
    }

    notifyListeners();
  }
}