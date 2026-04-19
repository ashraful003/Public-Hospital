import 'package:flutter/material.dart';
import 'package:public_hospital/service/auth_service.dart';
import '../../data/shared_pref_service.dart';
import '../../model/user_model.dart';

class ChangeOldPasswordViewModel extends ChangeNotifier {
  final UserModel user;

  ChangeOldPasswordViewModel({required this.user}) {
    oldPasswordController.addListener(_validateForm);
    newPasswordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
  }

  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;
  bool isButtonEnabled = false;
  String? errorMessage;
  String? successMessage;

  void _validateForm() {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();
    isButtonEnabled =
        oldPass.isNotEmpty &&
        newPass.isNotEmpty &&
        confirmPass.isNotEmpty &&
        newPass.length >= 6 &&
        newPass == confirmPass;
    notifyListeners();
  }

  void toggleOld() {
    obscureOld = !obscureOld;
    notifyListeners();
  }

  void toggleNew() {
    obscureNew = !obscureNew;
    notifyListeners();
  }

  void toggleConfirm() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  Future<void> changeOldPassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    final inputOldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final savedEmail = SharedPrefService.getRememberEmail();
    final savedPassword = SharedPrefService.getRememberPassword();
    if (savedEmail == null || savedPassword == null) {
      errorMessage = "Session expired. Please login again.";
      notifyListeners();
      return;
    }
    if (inputOldPassword != savedPassword) {
      errorMessage = "Old password is incorrect";
      notifyListeners();
      return;
    }
    try {
      isLoading = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();
      final message = await AuthService.changeOldPassword(
        email: savedEmail,
        password: inputOldPassword,
        newPassword: newPassword,
      );
      await SharedPrefService.saveRememberMe(
        email: savedEmail,
        password: newPassword,
      );
      isLoading = false;
      successMessage = message;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
    }
  }

  String? validateOld(String? value) {
    if (value == null || value.isEmpty) return "Old password is required";
    return null;
  }

  String? validateNew(String? value) {
    if (value == null || value.isEmpty) return "Enter new password";
    if (value.length < 6) return "Minimum 6 characters";
    return null;
  }

  String? validateConfirm(String? value) {
    if (value == null || value.isEmpty) return "Confirm password required";
    if (value != newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
