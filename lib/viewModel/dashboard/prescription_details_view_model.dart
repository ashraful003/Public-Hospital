import 'package:flutter/material.dart';
import '../../model/prescription_model.dart';
import '../../service/prescription_service.dart';

class PrescriptionDetailViewModel extends ChangeNotifier {
  final PrescriptionService _service = PrescriptionService();
  PrescriptionModel? prescription;
  bool isLoading = false;
  String? error;

  Future<void> loadById(int id) async {
    try {
      isLoading = true;
      error = null;
      prescription = null;
      notifyListeners();
      final data = await _service.getPrescriptionById(id);
      prescription = data;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }
}