import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier{
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isButtonEnable = false;

  SignUpViewModel(){
    _addListeners();
  }

  void _addListeners(){
    nameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    addressController.addListener(_validateForm);
    dobController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm(){
    final isValid = nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text;

    if(isButtonEnable != isValid){
      isButtonEnable = isValid;
      notifyListeners();
    }
  }

  void togglePassword(){
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }
  void toggleConfirmPassword(){
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  @override
  void dispose(){
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}