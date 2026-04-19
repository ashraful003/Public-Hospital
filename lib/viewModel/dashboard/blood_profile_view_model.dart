import 'package:flutter/material.dart';
import '../../data/shared_pref_service.dart';
import '../../model/blood_bank_model.dart';
import '../../service/blood_service.dart';

class BloodProfileViewModel extends ChangeNotifier {
  final BloodService _service = BloodService();
  BloodBankModel? profile;
  bool isLoading = false;
  final email = SharedPrefService.getString("remember_email");

  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    if (email != null && email!.isNotEmpty) {
      profile = await _service.getProfile(email!);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateDonationDate(DateTime newDate) async {
    if (profile == null || email == null) return;
    isLoading = true;
    notifyListeners();
    try {
      profile = await _service.updateDonationDate(email!, newDate);
    } catch (e) {
      debugPrint("Update failed: $e");
    }
    isLoading = false;
    notifyListeners();
  }
}
