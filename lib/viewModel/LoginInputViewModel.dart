import 'package:flutter/material.dart';

class LoginInputViewModel extends ChangeNotifier{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false;
  bool isButtonEnable = false;

  LoginInputViewModel(){
    _addListener();
  }

  void _addListener(){
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm(){
    final isValid = emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    if(isButtonEnable != isValid){
      isButtonEnable = isValid;
      notifyListeners();
    }
  }

  void togglePassword(){
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool? value){
    rememberMe = value?? false;
    notifyListeners();
  }

  void login(){
    final email = emailController.text;
    final password = passwordController.text;
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}