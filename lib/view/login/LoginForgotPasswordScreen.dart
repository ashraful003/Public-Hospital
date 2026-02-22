import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/color/AppColor.dart';
import 'package:public_hospital/viewModel/LoginForgotPasswordViewModel.dart';

class LoginForgotPasswordScreen extends StatefulWidget {
  const LoginForgotPasswordScreen({super.key});

  @override
  State<LoginForgotPasswordScreen> createState() =>
      _LoginForgotPasswordScreenState();
}

class _LoginForgotPasswordScreenState extends State<LoginForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginForgotPasswordViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor_100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.whiteColor_100,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          ),
        ),
        body: Consumer<LoginForgotPasswordViewModel>(
          builder: (context, vm, _) {
            return Padding(
              padding: const EdgeInsets.only(left: 35, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),

                  const SizedBox(height: 40),
                  _buildfield(
                    controller: vm.emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: vm.isButtonEnable?(){

                          //Back End Code
                        }:null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vm.isButtonEnable? AppColors.blue_200: AppColors.whiteColor_100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                          )
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(fontSize: 16,color: AppColors.whiteColor),
                        )
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildfield({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTop,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTop,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
