import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/add_donor_view_model.dart';

class AddDonorScreen extends StatelessWidget {
  const AddDonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddDonorViewModel()..loadProfile(),
      child: const _AddDonorBody(),
    );
  }
}

class _AddDonorBody extends StatelessWidget {
  const _AddDonorBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddDonorViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text("Add Blood Donor")),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _readonly(
                    "Name",
                    vm.nameController.text,
                    vm.nameController,
                    vm,
                  ),
                  _readonly(
                    "Email",
                    vm.emailController.text,
                    vm.emailController,
                    vm,
                  ),
                  _readonly(
                    "Phone",
                    vm.phoneController.text,
                    vm.phoneController,
                    vm,
                  ),
                  _readonly(
                    "Address",
                    vm.addressController.text,
                    vm.addressController,
                    vm,
                  ),
                  DropdownButtonFormField<String>(
                    value: vm.selectedBloodGroup,
                    items: vm.bloodGroups
                        .map(
                          (bg) => DropdownMenuItem(value: bg, child: Text(bg)),
                        )
                        .toList(),
                    onChanged: vm.setBloodGroup,
                    decoration: const InputDecoration(
                      labelText: "Blood Group",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => vm.selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        vm.selectedDate == null
                            ? "Select Donation Date"
                            : vm.selectedDate.toString().split(" ")[0],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: vm.isValid
                          ? () async {
                              final success = await vm.submit();
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: const Text(
                                      "Saved Successfully",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vm.isValid ? Colors.blue : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _readonly(
    String label,
    String value,
    TextEditingController controller,
    AddDonorViewModel vm,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onChanged: (_) => vm.validateForm(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
