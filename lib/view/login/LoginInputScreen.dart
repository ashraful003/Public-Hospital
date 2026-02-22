import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:public_hospital/color/AppColor.dart';
import 'package:public_hospital/view/dashboard/homeScreen.dart';
import 'package:public_hospital/view/login/LoginCreateScreen.dart';
import 'package:public_hospital/view/login/LoginForgotPasswordScreen.dart';
import 'package:public_hospital/viewModel/LoginInputViewModel.dart';

class LoginInputScreen extends StatefulWidget {
  const LoginInputScreen({super.key});


  @override
  State<LoginInputScreen> createState() => _LoginInputScreenState();
}

class _LoginInputScreenState extends State<LoginInputScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginInputViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor_100,
        body: SafeArea(
          child: Consumer<LoginInputViewModel>(
            builder: (context, vm, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 150,
                        width: 150,
                      ),
                      const Text(
                        'Public Hospital',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'This is a placeholder text',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 50),
                      _buildfield(
                        controller: vm.emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        controller: vm.passwordController,
                        obscureText: !vm.isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: vm.togglePassword,
                            icon: Icon(
                              vm.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Checkbox(
                            value: vm.rememberMe,
                            onChanged: vm.toggleRememberMe,
                          ),
                          const Text('Remember Me'),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>LoginForgotPasswordScreen()),
                              );
                            },
                            child: const Text('Forgot Password',style: TextStyle(color: AppColors.blue_200),),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: vm.isButtonEnable? () async{

                            await vm.login();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()),);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login Successful'))
                            );
                          }:null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vm.isButtonEnable? AppColors.blue_200:AppColors.whiteColor_100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 16,color: AppColors.whiteColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("You don't have an account"),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginCreateScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'SignUp',
                              style: TextStyle(
                                color: AppColors.blue_200,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _buildfield({
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
