import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/doctor_bn_profile_update_view_model.dart';

class DoctorBnProfileUpdateScreen extends StatelessWidget {
  final String id;
  final String doctorBnId;

  const DoctorBnProfileUpdateScreen({
    super.key,
    required this.id,
    required this.doctorBnId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorBnProfileUpdateViewModel()..loadDoctor(id),
      child: Consumer<DoctorBnProfileUpdateViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.blue_200,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Update Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: vm.isLoading && vm.doctor == null
                ? const Center(child: CircularProgressIndicator())
                : vm.error != null && vm.doctor == null
                ? Center(child: Text(vm.error!))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildField(
                          "Doctor ID",
                          vm.doctorBnIdController,
                          enabled: false,
                        ),
                        _buildField("Name", vm.nameController),
                        _buildField("Degree", vm.degreeController),
                        _buildField("Specialist", vm.specialistController),
                        _buildField("Institute", vm.instituteController),
                        _buildField(
                          "Registration No",
                          vm.LicenseController,
                        ),
                        _buildField("Visiting Time", vm.visitingTimeController),
                        const SizedBox(height: 24),
                        if (vm.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              vm.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: vm.isLoading
                                ? null
                                : () async {
                                    final success = await vm.updateDoctor(id);
                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            vm.successMessage ??
                                                "Profile updated successfully.",
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      Navigator.pop(context, true);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue_200,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade400,
                              disabledForegroundColor: Colors.white70,
                              elevation: 3,
                              shadowColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: vm.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "Update Profile",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        enabled: enabled,
        readOnly: !enabled,
        style: TextStyle(color: enabled ? Colors.black : Colors.grey.shade700),
        decoration: InputDecoration(
          labelText: label,
          filled: !enabled,
          fillColor: !enabled ? Colors.grey.shade200 : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}