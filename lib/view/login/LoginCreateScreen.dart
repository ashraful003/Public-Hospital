import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:public_hospital/color/AppColor.dart';
import 'package:public_hospital/view/login/LoginInputScreen.dart';
import 'package:public_hospital/viewModel/SignUpViewModel.dart';
import 'package:provider/provider.dart';
class LoginCreateScreen extends StatefulWidget {
  const LoginCreateScreen({super.key});

  @override
  State<LoginCreateScreen> createState() => _LoginCreateScreenState();
}

class _LoginCreateScreenState extends State<LoginCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
    create:(_) => SignUpViewModel(),
      child:Scaffold(
        backgroundColor: AppColors.whiteColor_100,
        body: SafeArea(
            child: Consumer<SignUpViewModel>(
              builder:(context,vm, _){
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30,),
                      const Text('Create Account',
                                 style: TextStyle(
                                   fontSize: 28,
                                   fontWeight: FontWeight.bold,
                                 ),
                      ),
                      const SizedBox(height: 30,),
                       _buildfield(
                          controller: vm.nameController,
                        label : 'Full Name',
                        icon: Icons.person,
                         keyboardType: TextInputType.name
                      ),
                      _buildfield(
                          controller: vm.emailController,
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                      ),
                      _buildfield(
                          controller: vm.phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone
                      ),
                      _buildfield(
                          controller: vm.addressController,
                          label: 'Address',
                          icon: Icons.location_on,
                          keyboardType: TextInputType.text
                      ),
                      _buildfield(
                          controller: vm.dobController,
                          label: 'Date of Birth',
                          icon: Icons.calendar_month,
                          readOnly: true,
                          onTop: () async{
                            final data = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                                initialDate: DateTime.now()
                            );
                            if(data != null){
                              vm.dobController.text = "${data.day}/${data.month}/${data.year}";
                            }
                        }
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
                                    :Icons.visibility_off,
                              ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: vm.confirmPasswordController,
                        obscureText: !vm.isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                              onPressed: vm.toggleConfirmPassword,
                              icon: Icon(
                                vm.isConfirmPasswordVisible
                                    ?Icons.visibility
                                    :Icons.visibility_off,
                              ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                            onPressed: vm.isButtonEnable? (){

                              //BackEnd code

                            }:null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: vm.isButtonEnable? AppColors.blue_200:AppColors.whiteColor_100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 16,color: AppColors.whiteColor),
                            ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          const SizedBox(width: 5),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginInputScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.blue_200,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              }
            )
        ),
      )
    );
  }

 Widget _buildfield({
    required TextEditingController controller,
   required String label,
   required IconData icon,
   TextInputType keyboardType = TextInputType.text,
   bool readOnly = false,
   VoidCallback? onTop,
}){
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
 }
}
