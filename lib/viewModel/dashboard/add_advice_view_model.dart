import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/shared_pref_service.dart';
import '../../model/advice_model.dart';
import '../../model/user_model.dart';
import '../../service/advice_service.dart';
import '../../service/api_client.dart';
import '../../service/api_config.dart';

class AddAdviceViewModel extends ChangeNotifier {
  final AdviceService _service = AdviceService();
  UserModel? currentUser;
  bool isLoading = false;
  bool isButtonEnable = false;
  String nationalId = "";
  String _title = "";
  String _advice = "";

  Future<void> loadCurrentUser() async {
    try {
      isLoading = true;
      notifyListeners();
      final email =
          await SharedPrefService.getString("remember_email") ??
          await SharedPrefService.getString("user_email");
      if (email == null || email.isEmpty) {
        throw Exception("Email not found");
      }
      final url = "${ApiConfig.baseUrl}/profile?email=$email";
      final response = await ApiClient.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        currentUser = UserModel.fromJson(json);
        nationalId = currentUser?.nationalId ?? "";
      } else {
        throw Exception("Failed to load profile");
      }
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateTitle(String value) {
    _title = value.trim();
    _validate();
  }

  void updateAdvice(String value) {
    _advice = value.trim();
    _validate();
  }

  void _validate() {
    isButtonEnable = _title.isNotEmpty && _advice.isNotEmpty;
    notifyListeners();
  }

  Future<bool> addAdvice() async {
    try {
      isLoading = true;
      notifyListeners();
      final advice = AdviceModel(
        nationalId: nationalId,
        title: _title,
        advice: _advice,
      );
      await _service.addAdvice(advice);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
