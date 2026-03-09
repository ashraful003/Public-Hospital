import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/dashboard/staff_registration_view_model.dart';

class StaffRegistrationScreen extends StatefulWidget {
  const StaffRegistrationScreen({super.key});

  @override
  State<StaffRegistrationScreen> createState() =>
      _StaffRegistrationScreenState();
}

class _StaffRegistrationScreenState extends State<StaffRegistrationScreen> {
  bool get showBackButton {
    if (kIsWeb) return false;

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StaffRegistrationViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Registration Form"),

          automaticallyImplyLeading: false,

          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
        ),

        body: SafeArea(
          child: Consumer<StaffRegistrationViewModel>(
            builder: (context, vm, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    _buildField(
                      controller: vm.nationalIdController,
                      label: "National ID",
                      icon: Icons.assignment,
                    ),

                    _buildField(
                      controller: vm.nameController,
                      label: "Full Name",
                      icon: Icons.person,
                    ),

                    _buildField(
                      controller: vm.emailController,
                      label: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    _buildField(
                      controller: vm.phoneController,
                      label: "Phone Number",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),

                    _buildField(
                      controller: vm.addressController,
                      label: "Address",
                      icon: Icons.location_on,
                    ),

                    _buildField(
                      controller: vm.dobController,
                      label: "Date of Birth",
                      icon: Icons.calendar_month,
                      readOnly: true,
                      onTap: () => vm.selectDate(context),
                    ),

                    _buildField(
                      controller: vm.instituteController,
                      label: "Institute Name",
                      icon: Icons.account_balance,
                    ),

                    _buildField(
                      controller: vm.degreeController,
                      label: "Degree",
                      icon: Icons.school,
                    ),

                    DropdownButtonFormField<String>(
                      initialValue: vm.selectedRole,
                      decoration: const InputDecoration(
                        labelText: "Select Role",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Doctor",
                          child: Text("Doctor"),
                        ),
                        DropdownMenuItem(value: "Nurse", child: Text("Nurse")),
                        DropdownMenuItem(
                          value: "Doctor Assistant",
                          child: Text("Doctor Assistant"),
                        ),
                        DropdownMenuItem(
                          value: "Cleaning Staff",
                          child: Text("Cleaning Staff"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          vm.setRole(value);
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    if (vm.isDoctor || vm.isNurse)
                      _buildField(
                        controller: vm.licenseController,
                        label: "License Number",
                        icon: Icons.card_membership,
                      ),

                    if (vm.isDoctor)
                      _buildField(
                        controller: vm.specialistController,
                        label: "Specialist Area",
                        icon: Icons.medical_services,
                      ),

                    _buildPasswordField(
                      controller: vm.passwordController,
                      label: "Password",
                      obscure: !vm.isPasswordVisible,
                      toggle: vm.togglePassword,
                    ),

                    const SizedBox(height: 20),

                    _buildPasswordField(
                      controller: vm.confirmPasswordController,
                      label: "Confirm Password",
                      obscure: !vm.isConfirmPasswordVisible,
                      toggle: vm.toggleConfirmPassword,
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: vm.isButtonEnable
                            ? () {
                                // Backend code here
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vm.isButtonEnable
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
  }) {
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
