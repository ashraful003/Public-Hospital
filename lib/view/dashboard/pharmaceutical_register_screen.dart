import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/pharmaceutical_register_view_model.dart';
import 'pharmaceutical_screen.dart';

class PharmaceuticalRegisterScreen extends StatelessWidget {
  const PharmaceuticalRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PharmaceuticalRegisterViewModel(),
      child: const _PharmaceuticalRegisterView(),
    );
  }
}

class _PharmaceuticalRegisterView extends StatelessWidget {
  const _PharmaceuticalRegisterView();

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmaceuticalRegisterViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Add Pharmaceutical",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.blue_200,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _field(vm.nationalIdController, "National ID"),
                _field(vm.nameController, "Name"),
                _field(vm.emailController, "Email"),
                _field(vm.phoneController, "Phone"),
                _field(vm.addressController, "Address"),
                _field(
                  vm.dobController,
                  "Registration Date",
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      initialDate: DateTime.now(),
                    );
                    if (date != null) {
                      vm.dobController.text =
                          "${date.day}/${date.month}/${date.year}";
                    }
                  },
                ),
                _field(vm.licenseController, "License"),
                const SizedBox(height: 10),
                _password(vm),
                const SizedBox(height: 10),
                _confirmPassword(vm),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: vm.isButtonEnable && !vm.isLoading
                        ? () async {
                            final success = await vm.register(context);
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PharmaceuticalScreen(),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vm.isButtonEnable
                          ? AppColors.blue_200
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: vm.isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Sign Up",
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
      },
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: c,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _password(vm) {
    return TextField(
      controller: vm.passwordController,
      obscureText: !vm.isPasswordVisible,
      decoration: InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(
            vm.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: vm.togglePassword,
        ),
      ),
    );
  }

  Widget _confirmPassword(vm) {
    return TextField(
      controller: vm.confirmPasswordController,
      obscureText: !vm.isConfirmPasswordVisible,
      decoration: InputDecoration(
        labelText: "Confirm Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(
            vm.isConfirmPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: vm.toggleConfirmPassword,
        ),
      ),
    );
  }
}
