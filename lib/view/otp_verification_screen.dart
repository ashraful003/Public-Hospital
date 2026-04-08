import 'package:flutter/material.dart';
import '../color/app_color.dart';
import '../model/user_model.dart';
import '../service/auth_service.dart';
import 'change_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final UserModel user;

  const OtpVerificationScreen({super.key, required this.user});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;
  bool isButtonEnabled = true;
  String? error;

  Future<void> verifyOtp() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final success = await _authService.verifyOtpEmail(
        email: widget.user.email!,
        otp: otpController.text.trim(),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Verified")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChangePasswordScreen(user: widget.user),
          ),
        );
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "OTP sent to ${widget.user.email}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                errorText: error,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isButtonEnabled && !isLoading ? verifyOtp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isButtonEnabled ? AppColors.blue_200 : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}