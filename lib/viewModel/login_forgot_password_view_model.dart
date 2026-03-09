import 'package:flutter/material.dart';

class LoginForgotPasswordViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  bool isButtonEnable =  false;

  LoginForgotPasswordViewModel(){
    _addListener();
  }

  void _addListener(){
    emailController.addListener(_validateForm);
  }

  void _validateForm(){
    final isValid = emailController.text.isNotEmpty;
    if(isButtonEnable != isValid){
      isButtonEnable = isValid;
      notifyListeners();
    }
  }

  void forgotPassword(){
    final email = emailController.text;
  }

  void disposal(){
    emailController.dispose();
    super.dispose();
  }
}