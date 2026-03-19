import 'package:flutter/material.dart';
import '../../model/user_model.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final UserModel user;

  ChangePasswordViewModel({required this.user}) {
    _addListeners();
  }

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmVisible = false;
  bool isLoading = false;
  String? errorMessage;

  void _addListeners() {
    passwordController.addListener(_validateForm);
    confirmController.addListener(_validateForm);
  }

  void togglePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirm() {
    isConfirmVisible = !isConfirmVisible;
    notifyListeners();
  }

  bool get isButtonEnabled {
    final pass = passwordController.text.trim();
    final confirm = confirmController.text.trim();
    return pass.isNotEmpty && confirm.isNotEmpty && pass == confirm;
  }

  void _validateForm() {
    final pass = passwordController.text.trim();
    final confirm = confirmController.text.trim();
    if (pass.isEmpty || confirm.isEmpty) {
      errorMessage = null;
    } else if (pass != confirm) {
      errorMessage = "Passwords do not match";
    } else {
      errorMessage = null;
    }
    notifyListeners();
  }

  Future<void> changePassword(BuildContext context) async {
    if (!isButtonEnabled) return;
    isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      debugPrint("Password changed for user: ${user.email ?? user.phone}");
      debugPrint("New Password: ${passwordController.text.trim()}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully")),
      );
    } catch (e) {
      errorMessage = "Failed to change password";
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }
}
