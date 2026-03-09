import 'package:flutter/material.dart';
import 'package:public_hospital/data/shared_pref_service.dart';
import 'package:public_hospital/utils/pref_keys.dart';

class LoginInputViewModel extends ChangeNotifier{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false;
  bool isButtonEnable = false;
  bool isLoading = false;

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

  Future<void> _loadRememberMe() async{
    final savedEmail = await SharedPrefService.getString(PrefKeys.rememberEmail);
    final savedPassword = await SharedPrefService.getString(PrefKeys.rememberPassword);

    if(savedEmail != null && savedEmail.isNotEmpty && savedPassword != null && savedPassword.isNotEmpty){
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe = true;
      notifyListeners();
    }
  }

  Future<void> login() async{
    if(!isButtonEnable || isLoading) return;
    isLoading = true;
    notifyListeners();
    final email = emailController.text;
    final password = passwordController.text;

    await Future.delayed(const Duration(seconds: 2));

    await SharedPrefService.setBool(PrefKeys.isLoggedIn, true);
    await SharedPrefService.setString(PrefKeys.userEmail, email);
    await SharedPrefService.setString(PrefKeys.token, 'dummy_token_123');

    if(rememberMe){
      await SharedPrefService.setString(PrefKeys.rememberEmail, email);
      await SharedPrefService.setString(PrefKeys.rememberPassword, password);
    }else{
      await SharedPrefService.remove(PrefKeys.rememberEmail);
      await SharedPrefService.remove(PrefKeys.rememberPassword);
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}