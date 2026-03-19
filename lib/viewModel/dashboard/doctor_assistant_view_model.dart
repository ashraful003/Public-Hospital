import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
enum DoctorAssistantTab { all, active }
class DoctorAssistantViewModel extends ChangeNotifier {
  DoctorAssistantTab _selectedTab = DoctorAssistantTab.all;
  DoctorAssistantTab get selectedTab => _selectedTab;
  final List<UserModel> _allDoctorAssistants = [
    UserModel(
      nationalId: '123456',
      name: 'John Smith',
      email: 'johnsmith@gmail.com',
      address: 'West Rajabazar, Dhaka-1215',
      phone: '01717078044',
      dob: DateTime(1997, 12, 12),
      institute: 'Dhaka Medical College & Hospital',
      degree: 'Honors',
      imageUrl: 'assets/images/logo.png',
      isActive: true,
      role: UserRole.doctorAssistant,
    ),
    UserModel(
      nationalId: '987654',
      name: 'Smith',
      email: 'smith@gmail.com',
      address: 'West Rajabazar, Dhaka-1215',
      phone: '01717078044',
      dob: DateTime(1997, 12, 12),
      institute: 'Dhaka Medical College & Hospital',
      degree: 'Honors',
      imageUrl: 'assets/images/logo.png',
      isActive: false,
      role: UserRole.doctorAssistant,
    ),
  ];
  List<UserModel> _filteredDoctorAssistants = [];

  List<UserModel> get assistants => _filteredDoctorAssistants;

  DoctorAssistantViewModel() {
    _filteredDoctorAssistants = List.from(_allDoctorAssistants);
  }
  List<UserModel> _getBaseList() {
    if (_selectedTab == DoctorAssistantTab.all) {
      return _allDoctorAssistants;
    } else {
      return _allDoctorAssistants
          .where((assistant) => assistant.isActive == true)
          .toList();
    }
  }
  void changeTab(DoctorAssistantTab tab) {
    _selectedTab = tab;
    _filteredDoctorAssistants = _getBaseList();
    notifyListeners();
  }
  void searchByNationalId(String id) {

    final query = id.trim();

    final baseList = _getBaseList();

    if (query.isEmpty) {
      _filteredDoctorAssistants = baseList;
    } else {
      _filteredDoctorAssistants = baseList.where((assistant) {

        final nid = assistant.nationalId ?? '';

        return nid.contains(query);

      }).toList();
    }

    notifyListeners();
  }

}