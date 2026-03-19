import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
class LoginForgotPasswordViewModel extends ChangeNotifier {
  final TextEditingController inputController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;
  String? errorMessage;
  LoginForgotPasswordViewModel() {
    _addListener();
  }
  void _addListener() {
    inputController.addListener(_validateForm);
  }
  bool get isEmail {
    final text = inputController.text.trim();
    return text.contains("@");
  }
  void _validateForm() {
    final text = inputController.text.trim();
    bool isValid = false;
    if (text.isEmpty) {
      errorMessage = null;
    } else if (isEmail) {
      isValid = text.contains(".");
      errorMessage = isValid ? null : "Enter valid email";
    } else {
      isValid = text.length >= 10;
      errorMessage = isValid ? null : "Enter valid phone number";
    }
    isButtonEnabled = isValid;
    notifyListeners();
  }
  Future<UserModel?> sendOtp(BuildContext context) async {
    if (!isButtonEnabled) return null;
    isLoading = true;
    notifyListeners();
    try {
      final user = UserModel(
        email: isEmail ? inputController.text.trim() : null,
        phone: !isEmail ? inputController.text.trim() : null,
      );
      await Future.delayed(const Duration(seconds: 2));
      debugPrint("OTP sent to: ${user.toJson()}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent successfully")),
      );
      return user;
    } catch (e) {
      errorMessage = "Failed to send OTP";
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
}