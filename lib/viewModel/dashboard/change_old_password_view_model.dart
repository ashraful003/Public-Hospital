import 'package:flutter/material.dart';
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

  /// 🔥 BUTTON ENABLE LOGIC
  void _validateForm() {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    isButtonEnabled = oldPass.isNotEmpty &&
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

  Future<void> changePassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();

    /// ❌ Wrong old password
    if (oldPassword != user.password) {
      errorMessage = "Old password is incorrect";
      notifyListeners();
      return;
    }

    /// 🔄 Start loading
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    final updatedUser = user.copyWith(password: newPassword);

    isLoading = false;
    successMessage = "Password changed successfully!";
    notifyListeners();

    debugPrint("Updated Password: ${updatedUser.password}");

    /// ✅ SHOW SUCCESS + GO BACK
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password changed successfully"),
        backgroundColor: Colors.green,
      ),
    );

    /// ⏳ Small delay for UX
    await Future.delayed(const Duration(milliseconds: 500));

    Navigator.pop(context); // 🔥 GO BACK
  }

  /// VALIDATORS
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