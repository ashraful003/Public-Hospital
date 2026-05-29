import 'package:flutter/material.dart';
import '../../model/dose_time_model.dart';
import '../../service/dose_time_service.dart';

class DoseTimeViewModel extends ChangeNotifier {
  final DoseTimeService _service = DoseTimeService();
  final String nationalId;

  DoseTimeViewModel(this.nationalId);

  List<DoseTimeModel> doseTimes = [];
  List<DoseTimeModel> filteredDoseTimes = [];
  bool isLoading = false;

  Future<void> loadDoseTimes() async {
    isLoading = true;
    notifyListeners();
    try {
      doseTimes = await _service.getDoseTimes(nationalId);
      filteredDoseTimes = List.from(doseTimes);
    } catch (e) {
      doseTimes = [];
      filteredDoseTimes = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void searchDoseTime(String value) {
    if (value.isEmpty) {
      filteredDoseTimes = List.from(doseTimes);
    } else {
      filteredDoseTimes = doseTimes
          .where((e) => e.doseTime.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<String> createDoseTime(String doseTime) async {
    try {
      final res = await _service.createDoseTime(doseTime, nationalId);
      await loadDoseTimes();
      return res;
    } catch (e) {
      return "Create failed";
    }
  }

  Future<Map<String, dynamic>> updateDoseTime(int id, String doseTime) async {
    try {
      final res = await _service.updateDoseTime(id, doseTime, nationalId);
      if (res["statusCode"] == 200) {
        await loadDoseTimes();
        return {"success": true, "message": res["body"]};
      }
      return {"success": false, "message": res["body"]};
    } catch (e) {
      return {"success": false, "message": "Update failed"};
    }
  }

  Future<String> deleteDoseTime(int id) async {
    try {
      final res = await _service.deleteDoseTime(id);
      await loadDoseTimes();
      return res;
    } catch (e) {
      return "Delete failed";
    }
  }
}
