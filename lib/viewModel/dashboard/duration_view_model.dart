import 'package:flutter/material.dart';
import '../../model/duration_model.dart';
import '../../service/duration_service.dart';

class DurationViewModel extends ChangeNotifier {
  final DurationService _service = DurationService();
  final String nationalId;

  DurationViewModel(this.nationalId);

  List<DurationModel> durations = [];
  List<DurationModel> filteredDurations = [];
  bool isLoading = false;

  Future<void> loadDurations() async {
    isLoading = true;
    notifyListeners();
    try {
      durations = await _service.getDurations(nationalId);
      durations.sort((a, b) {
        final aValue =
            int.tryParse(a.duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        final bValue =
            int.tryParse(b.duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return aValue.compareTo(bValue);
      });
      filteredDurations = List.from(durations);
    } catch (e) {
      durations = [];
      filteredDurations = [];
    }
    isLoading = false;
    notifyListeners();
  }

  void searchDuration(String value) {
    if (value.isEmpty) {
      filteredDurations = List.from(durations);
    } else {
      filteredDurations = durations.where((e) {
        return e.duration.toLowerCase().contains(value.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<String> createDuration(String duration) async {
    try {
      final result = await _service.addDuration(nationalId, duration);
      if (result["success"] == true) {
        await loadDurations();
        return result["message"] ?? "Duration created successfully";
      }
      return result["message"] ?? "Create failed";
    } catch (e) {
      return "Create failed";
    }
  }

  Future<Map<String, dynamic>> updateDuration(int id, String duration) async {
    try {
      await _service.updateDuration(id, nationalId, duration);
      await loadDurations();
      return {"success": true, "message": "Duration updated successfully"};
    } catch (e) {
      return {"success": false, "message": "Update failed"};
    }
  }

  Future<String> deleteDuration(int id) async {
    try {
      await _service.deleteDuration(id);
      await loadDurations();
      return "Duration deleted successfully";
    } catch (e) {
      return "Delete failed";
    }
  }
}
