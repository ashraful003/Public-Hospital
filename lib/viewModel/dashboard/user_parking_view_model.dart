import 'package:flutter/material.dart';
import '../../model/user_parking_model.dart';
import '../../service/user_parking_service.dart';

class UserParkingViewModel extends ChangeNotifier {
  final UserParkingService _service = UserParkingService();
  bool loading = false;
  List<UserParkingModel> allParking = [];
  List<UserParkingModel> activeParking = [];
  List<UserParkingModel> patientParking = [];

  Future<bool> createUserParking(
    UserParkingModel request,
    BuildContext context,
  ) async {
    try {
      loading = true;
      notifyListeners();
      final result = await _service.createUserParking(request);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result["message"] ?? "Success")));
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadData({
    required String role,
    required String patientId,
  }) async {
    loading = true;
    notifyListeners();
    try {
      final isAdmin = role.toLowerCase() == "admin";
      if (isAdmin) {
        allParking = await _service.getAllParking();
        activeParking = await _service.getActiveParking();
        allParking.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        activeParking.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      } else {
        patientParking = await _service.getPatientParking(patientId);
        patientParking.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> exitVehicle(String vehicleNo) async {
    try {
      await _service.exitVehicle(vehicleNo);
      return true;
    } catch (e) {
      return false;
    }
  }
}