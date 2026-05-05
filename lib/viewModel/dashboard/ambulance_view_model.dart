import 'package:flutter/material.dart';
import 'package:public_hospital/service/staff_service.dart';
import '../../model/user_model.dart';

class AmbulanceViewModel extends ChangeNotifier {
  final StaffService _service = StaffService();
  List<UserModel> drivers = [];
  bool isLoading = false;
  String? error;

  Future<void> loadDrivers() async {
    try {
      isLoading = true;
      notifyListeners();
      drivers = await _service.fetchActiveDrivers();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
