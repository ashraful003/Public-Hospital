import 'package:flutter/material.dart';
import '../../model/doctor_model.dart';
enum DoctorTab { all, active }
class DoctorViewModel extends ChangeNotifier {
  DoctorTab _selectedTab = DoctorTab.all;
  DoctorTab get selectedTab => _selectedTab;
  final List<DoctorModel> _allDoctors = [
    DoctorModel(
      name: "Dr. John Doe",
      nationalId: "12345",
      imageUrl: null,
      isActive: true,
      dob: DateTime(1997,12,12),
      institute: 'Dhaka Medical College Hospital',
      specialist: "Cardiologist",
      degree: "MBBS, MD (Cardiology)",
      hospital: "City Heart Hospital",
      address: "Dhaka, Bangladesh",
      phone: "01711111111",
    ),
    DoctorModel(
      name: "Dr. Sarah Smith",
      nationalId: "67890",
      imageUrl: null,
      isActive: false,
      dob: DateTime(1997,12,12),
      institute: 'Dhaka Medical College Hospital',
      specialist: "Cardiologist",
      degree: "MBBS, MD (Cardiology)",
      hospital: "City Heart Hospital",
      address: "Dhaka, Bangladesh",
      phone: "01711111111",
    ),
  ];
  List<DoctorModel> _filteredDoctors = [];
  List<DoctorModel> get doctors => _filteredDoctors;
  DoctorViewModel() {
    _filteredDoctors = List.from(_allDoctors);
  }
  void changeTab(DoctorTab tab) {
    _selectedTab = tab;
    if (tab == DoctorTab.all) {
      _filteredDoctors = List.from(_allDoctors);
    } else {
      _filteredDoctors =
          _allDoctors.where((doctor) => doctor.isActive).toList();
    }
    notifyListeners();
  }
  void searchByNationalId(String id) {
    List<DoctorModel> baseList =
    _selectedTab == DoctorTab.all
        ? _allDoctors
        : _allDoctors.where((d) => d.isActive).toList();
    if (id.isEmpty) {
      _filteredDoctors = baseList;
    } else {
      _filteredDoctors = baseList
          .where((doctor) => doctor.nationalId.contains(id))
          .toList();
    }
    notifyListeners();
  }
}