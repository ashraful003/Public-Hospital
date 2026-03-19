import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user_model.dart';
import '../../viewModel/dashboard/change_old_password_view_model.dart';
class ChangeOldPasswordScreen extends StatelessWidget {
  final UserModel user;
  const ChangeOldPasswordScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangeOldPasswordViewModel(user: user),
      child: const _ChangeOldPasswordView(),
    );
  }
}
class _ChangeOldPasswordView extends StatelessWidget {
  const _ChangeOldPasswordView();
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChangeOldPasswordViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Stack(
        children: [
          Form(
            key: vm.formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: vm.oldPasswordController,
                  obscureText: vm.obscureOld,
                  validator: vm.validateOld,
                  decoration: InputDecoration(
                    labelText: "Old Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(vm.obscureOld
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: vm.toggleOld,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: vm.newPasswordController,
                  obscureText: vm.obscureNew,
                  validator: vm.validateNew,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(vm.obscureNew
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: vm.toggleNew,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: vm.confirmPasswordController,
                  obscureText: vm.obscureConfirm,
                  validator: vm.validateConfirm,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(vm.obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: vm.toggleConfirm,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (vm.errorMessage != null)
                  Text(vm.errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                if (vm.successMessage != null)
                  Text(vm.successMessage!,
                      style: const TextStyle(color: Colors.green)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      vm.isButtonEnabled ? Colors.blue : Colors.grey,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: (vm.isButtonEnabled && !vm.isLoading)
                        ? () => vm.changePassword(context)
                        : null,
                    child: vm.isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "Submit",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (vm.isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}