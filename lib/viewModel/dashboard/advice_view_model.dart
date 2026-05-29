import 'package:flutter/material.dart';
import '../../model/advice_model.dart';
import '../../service/advice_service.dart';

class AdviceViewModel extends ChangeNotifier {
  final AdviceService _adviceService = AdviceService();
  List<AdviceModel> adviceList = [];
  List<AdviceModel> filteredList = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadAdvice(String nationalId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      adviceList = await _adviceService.getAdviceList(nationalId);
      adviceList = adviceList.reversed.toList();
      filteredList = adviceList;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchAdvice(String query) {
    if (query.isEmpty) {
      filteredList = adviceList;
    } else {
      filteredList = adviceList
          .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
