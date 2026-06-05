import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/diagnostic_center_register_view_model.dart';
import 'diagnostic_center_screen.dart';

class DiagnosticCenterRegisterScreen extends StatelessWidget {
  const DiagnosticCenterRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiagnosticCenterRegisterViewModel(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return Consumer<DiagnosticCenterRegisterViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _field(vm.nationalIdController, "Registration ID"),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vm.isButtonEnable
                          ? AppColors.blue_200
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: vm.isButtonEnable && !vm.isLoading
                        ? () async {
                            final success = await vm.register(context);
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const DiagnosticCenterScreen(),
                                ),
                              );
                            }
                          }
                        : null,
                    child: vm.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
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