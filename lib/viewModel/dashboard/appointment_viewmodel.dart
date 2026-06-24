import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../service/appointment_service.dart';

class AppointmentViewModel extends ChangeNotifier {
  final AppointmentService service;

  AppointmentViewModel({required this.service});

  bool loading = false;
  String? error;
  List<UserModel> allDoctors = [];
  List<UserModel> filteredDoctors = [];

  Future<void> loadDoctors(String department) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      allDoctors = await service.getAllDoctors();
      final dept = department.trim().toLowerCase();
      filteredDoctors = allDoctors.where((doctor) {
        final department = doctor.department?.trim().toLowerCase() ?? "";
        return department.contains(dept);
      }).toList();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }
}
