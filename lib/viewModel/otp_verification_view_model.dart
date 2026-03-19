import 'package:flutter/material.dart';
import '../../model/user_model.dart';

class OtpVerificationViewModel extends ChangeNotifier {
  final UserModel user;

  OtpVerificationViewModel({required this.user}) {
    _initControllers();
  }

  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];

  bool isLoading = false;
  String? errorMessage;

  void _initControllers() {
    for (int i = 0; i < 6; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
      controllers[i].addListener(() => notifyListeners());
    }
  }

  String get otp => controllers.map((e) => e.text).join();

  bool get isOtpComplete => otp.length == 6;

  void onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
    notifyListeners();
  }

  bool validateOtp() {
    if (!isOtpComplete) {
      errorMessage = "Enter complete 6-digit OTP";
      notifyListeners();
      return false;
    }
    errorMessage = null;
    notifyListeners();
    return true;
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (!validateOtp()) return;

    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      debugPrint("OTP Verified for user: ${user.toJson()}");
      debugPrint("Entered OTP: $otp");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified Successfully")),
      );
    } catch (e) {
      errorMessage = "Invalid OTP";
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }
}
