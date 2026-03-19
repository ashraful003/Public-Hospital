import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';

enum DoctorTab { all, active }

class DoctorViewModel extends ChangeNotifier {
  DoctorTab _selectedTab = DoctorTab.all;

  DoctorTab get selectedTab => _selectedTab;
  final List<UserModel> _allDoctors = [
    UserModel(
      nationalId: "12345",
      license: '123456789',
      name: "Dr. John Doe",
      email: 'john@gmail.com',
      phone: "01711111111",
      dob: DateTime(1997, 12, 12),
      institute: 'Dhaka Medical College Hospital',
      specialist: "Cardiologist",
      degree: "MBBS, MD (Cardiology)",
      address: "Dhaka, Bangladesh",
      imageUrl: 'assets/images/logo.png',
      isActive: true,
      role: UserRole.doctor,
    ),
    UserModel(
      nationalId: "67890",
      license: '123456789',
      name: "Dr. Sarah Smith",
      email: 'smith@gmail.com',
      phone: "01711111111",
      dob: DateTime(1997, 12, 12),
      institute: 'Dhaka Medical College Hospital',
      specialist: "Cardiologist",
      degree: "MBBS, MD (Cardiology)",
      address: "Dhaka, Bangladesh",
      imageUrl: 'assets/images/logo.png',
      isActive: false,
      role: UserRole.doctor,
    ),
  ];
  List<UserModel> _filteredDoctors = [];

  List<UserModel> get doctors => _filteredDoctors;

  DoctorViewModel() {
    _filteredDoctors = List.from(_allDoctors);
  }

  List<UserModel> _getBaseList() {
    if (_selectedTab == DoctorTab.all) {
      return _allDoctors;
    } else {
      return _allDoctors.where((doctor) => doctor.isActive == true).toList();
    }
  }

  void changeTab(DoctorTab tab) {
    _selectedTab = tab;
    _filteredDoctors = _getBaseList();
    notifyListeners();
  }

  void searchByNationalId(String id) {
    final query = id.trim();

    final baseList = _getBaseList();

    if (query.isEmpty) {
      _filteredDoctors = baseList;
    } else {
      _filteredDoctors = baseList.where((doctor) {
        final nid = doctor.nationalId ?? "";
        return nid.contains(query);
      }).toList();
    }
    notifyListeners();
  }
}
