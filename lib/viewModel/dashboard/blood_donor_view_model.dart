import 'package:flutter/material.dart';
import '../../model/blood_bank_model.dart';
import '../../service/blood_service.dart';

class BloodDonorViewModel extends ChangeNotifier {
  final BloodService _service = BloodService();
  List<BloodBankModel> _allDonors = [];
  List<BloodBankModel> _filteredDonors = [];

  List<BloodBankModel> get donors => _filteredDonors;
  bool isLoading = false;

  BloodDonorViewModel() {
    loadDonors();
  }

  Future<void> loadDonors() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await _service.getAllDonors();
      _allDonors = data;
      _filteredDonors = data;
    } catch (e) {
      _allDonors = [];
      _filteredDonors = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void searchByBloodGroup(String query) {
    if (query.isEmpty) {
      _filteredDonors = _allDonors;
    } else {
      _filteredDonors = _allDonors
          .where(
            (donor) =>
                donor.bloodGroup.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadDonors();
  }
}
