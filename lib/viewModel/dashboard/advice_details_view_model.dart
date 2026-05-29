import 'package:flutter/material.dart';
import '../../model/advice_model.dart';
import '../../service/advice_service.dart';

class AdviceDetailsViewModel extends ChangeNotifier {
  final AdviceService _service = AdviceService();
  AdviceModel? advice;
  bool isLoading = false;
  bool isDeleteLoading = false;
  String? errorMessage;

  Future<void> loadAdviceDetails({
    required String nationalId,
    required String adviceId,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      final adviceList = await _service.getAdviceList(nationalId);
      advice = adviceList.firstWhere((e) => e.id.toString() == adviceId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAdvice() async {
    try {
      isDeleteLoading = true;
      notifyListeners();
      final success = await _service.deleteAdvice(advice!.id!);
      isDeleteLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      errorMessage = e.toString();
      isDeleteLoading = false;
      notifyListeners();
      return false;
    }
  }
}
