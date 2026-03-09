import 'package:flutter/material.dart';
import 'package:public_hospital/model/cleaner_model.dart';

enum CleanerTab { all, active }

class CleanerViewModel extends ChangeNotifier {
  CleanerTab _selectedTab = CleanerTab.all;
  CleanerTab get selectedTab => _selectedTab;
  final List<CleanerModel> _allCleaner = [
    CleanerModel(
      nationalId: '12345678',
      name: 'John Smith',
      email: 'johnsmith@gmail.com',
      address: 'West Rajabazar Dhaka-1215',
      phone: '01717078044',
      dob: DateTime(1998, 12, 12),
      institute: 'Dhaka Rajdhani High School',
      degree: 'Secondary School Certificate',
      isActive: true,
    ),
    CleanerModel(
      nationalId: '89213756',
      name: 'John',
      email: 'john@gmail.com',
      address: 'West Rajabazar Dhaka-1215',
      phone: '01717078044',
      dob: DateTime(1998, 12, 12),
      institute: 'Dhaka Rajdhani High School',
      degree: 'Secondary School Certificate',
      isActive: false,
    ),
  ];
  List<CleanerModel> _filteredCleaners = [];

  List<CleanerModel> get cleaners => _filteredCleaners;

  CleanerViewModel() {
    _filteredCleaners = List.from(_allCleaner);
  }

  void changeTab(CleanerTab tab) {
    _selectedTab = tab;
    if (tab == CleanerTab.all) {
      _filteredCleaners = List.from(_allCleaner);
    }
    else{
      _filteredCleaners = _allCleaner
          .where((cleaners) => cleaners.isActive)
          .toList();
    }
    notifyListeners();
  }

  void searchByNationalId(String id) {
    List<CleanerModel> baseList = _selectedTab == CleanerTab.all
        ? _allCleaner
        : _allCleaner.where((d) => d.isActive).toList();
    if(id.isEmpty){
      _filteredCleaners = baseList;
    }else{
      _filteredCleaners = baseList
          .where((cleaner)=>cleaner.nationalId.contains(id)).toList();
    }
    notifyListeners();
  }
}
