import 'package:flutter/material.dart';
import '../../model/doses_model.dart';
import '../../service/dose_service.dart';

class DoseViewModel extends ChangeNotifier {
  final DoseService _doseService = DoseService();
  final String nationalId;

  DoseViewModel(this.nationalId);

  List<DoseModel> doseList = [];
  List<DoseModel> filteredDoseList = [];

  List<DoseModel> get doses => filteredDoseList;
  bool isLoading = false;

  Future<void> loadCurrentUserAndDoses() async {
    try {
      isLoading = true;
      notifyListeners();
      doseList = await _doseService.getDosesByNationalId(nationalId);
      doseList = doseList.reversed.toList();
      filteredDoseList = List.from(doseList);
    } catch (e) {
      doseList = [];
      filteredDoseList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchDose(String value) {
    if (value.isEmpty) {
      filteredDoseList = List.from(doseList);
    } else {
      filteredDoseList = doseList
          .where((d) => d.dose.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<String> addDose({
    required String dose,
    required String nationalId,
  }) async {
    try {
      final res = await _doseService.addDose(
        dose: dose,
        nationalId: nationalId,
      );
      await loadCurrentUserAndDoses();
      return res;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateDose({
    required int id,
    required String dose,
    required String nationalId,
  }) async {
    try {
      final res = await _doseService.updateDose(
        id: id,
        dose: dose,
        nationalId: nationalId,
      );
      await loadCurrentUserAndDoses();
      return res;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deleteDose(int id) async {
    try {
      final res = await _doseService.deleteDose(id);
      await loadCurrentUserAndDoses();
      return res;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> refreshDoses() async {
    await loadCurrentUserAndDoses();
  }
}
