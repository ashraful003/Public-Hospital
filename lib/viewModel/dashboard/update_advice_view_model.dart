import 'package:flutter/material.dart';
import '../../model/advice_model.dart';
import '../../service/advice_service.dart';

class UpdateAdviceViewModel extends ChangeNotifier {
  final AdviceService _service = AdviceService();
  bool isLoading = false;
  bool isButtonEnable = false;
  String nationalId = "";
  String title = "";
  String advice = "";

  void loadAdvice(AdviceModel adviceModel) {
    nationalId = adviceModel.nationalId;
    title = adviceModel.title;
    advice = adviceModel.advice;
    _validate();
  }

  void updateTitle(String value) {
    title = value.trim();
    _validate();
  }

  void updateAdvice(String value) {
    advice = value.trim();
    _validate();
  }

  void _validate() {
    isButtonEnable = title.isNotEmpty && advice.isNotEmpty;
    notifyListeners();
  }

  Future<bool> updateAdviceData(String adviceId) async {
    try {
      isLoading = true;
      notifyListeners();
      final adviceModel = AdviceModel(
        id: adviceId,
        nationalId: nationalId,
        title: title,
        advice: advice,
      );
      final success = await _service.updateAdvice(
        id: adviceId,
        advice: adviceModel,
      );
      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
