import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/dashboard/staff_registration_view_model.dart';
import '../../model/user_model.dart';

class StaffRegistrationScreen extends StatefulWidget {
  const StaffRegistrationScreen({super.key});

  @override
  State<StaffRegistrationScreen> createState() =>
      _StaffRegistrationScreenState();
}

class _StaffRegistrationScreenState extends State<StaffRegistrationScreen> {
  bool get showBackButton {
    if (kIsWeb) return false;
    return [
      TargetPlatform.android,
      TargetPlatform.iOS,
      TargetPlatform.windows,
      TargetPlatform.macOS,
      TargetPlatform.linux,
    ].contains(defaultTargetPlatform);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StaffRegistrationViewModel(),
      child: Consumer<StaffRegistrationViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Staff Registration"),
              automaticallyImplyLeading: false,
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      vm.nationalIdController,
                      "National ID",
                      Icons.assignment,
                    ),
                    _buildField(vm.nameController, "Full Name", Icons.person),
                    _buildField(
                      vm.emailController,
                      "Email",
                      Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildField(
                      vm.phoneController,
                      "Phone Number",
                      Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildField(
                      vm.addressController,
                      "Address",
                      Icons.location_on,
                    ),
                    _buildField(
                      vm.dobController,
                      "Date of Birth",
                      Icons.calendar_month,
                      readOnly: true,
                      onTap: () => vm.selectDate(context),
                    ),
                    _buildField(
                      vm.instituteController,
                      "Institute Name",
                      Icons.account_balance,
                    ),
                    _buildField(vm.degreeController, "Degree", Icons.school),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<UserRole>(
                      value: vm.selectedRole,
                      decoration: const InputDecoration(
                        labelText: "Select Role",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: UserRole.doctor,
                          child: Text("Doctor"),
                        ),
                        DropdownMenuItem(
                          value: UserRole.nurse,
                          child: Text("Nurse"),
                        ),
                        DropdownMenuItem(
                          value: UserRole.doctorAssistant,
                          child: Text("Doctor Assistant"),
                        ),
                        DropdownMenuItem(
                          value: UserRole.cleaner,
                          child: Text("Cleaning Staff"),
                        ),
                      ],
                      onChanged: (role) {
                        if (role != null) vm.setRole(role);
                      },
                    ),
                    const SizedBox(height: 20),
                    if (vm.isDoctor || vm.isNurse)
                      _buildField(
                        vm.licenseController,
                        "License Number",
                        Icons.verified,
                      ),
                    if (vm.isDoctor)
                      _buildField(
                        vm.specialistController,
                        "Specialist Area",
                        Icons.medical_services,
                      ),
                    _buildPasswordField(
                      vm.passwordController,
                      "Password",
                      !vm.isPasswordVisible,
                      vm.togglePassword,
                    ),
                    _buildPasswordField(
                      vm.confirmPasswordController,
                      "Confirm Password",
                      !vm.isConfirmPasswordVisible,
                      vm.toggleConfirmPassword,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: vm.isButtonEnabled
                            ? () {
                                final user = vm.getStaffUserModel();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${user.name} registered successfully!",
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vm.isButtonEnabled
                              ? Colors.blue
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool obscure,
    VoidCallback toggle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: toggle,
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
