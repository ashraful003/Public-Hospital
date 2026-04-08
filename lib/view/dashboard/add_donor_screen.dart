import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/blood_donor_model.dart';
import '../../viewModel/dashboard/add_donor_view_model.dart';

class AddDonorScreen extends StatelessWidget {
  const AddDonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddDonorViewModel(),
      child: const _AddDonorScreenBody(),
    );
  }
}

class _AddDonorScreenBody extends StatelessWidget {
  const _AddDonorScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddDonorViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text("Add Blood Donor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: vm.nationalIdController,
              decoration: const InputDecoration(
                labelText: "NID/Passport number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: vm.nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: vm.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => vm.validateForm(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: vm.phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: vm.addressController,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: vm.selectedBloodGroup,
              items: vm.bloodGroups
                  .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                  .toList(),
              onChanged: (value) {
                vm.setBloodGroup(value);
                vm.validateForm();
              },
              decoration: const InputDecoration(
                labelText: "Blood Group",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: vm.lastDonationDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Last Donation Date",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    await vm.selectDate(context);
                    vm.validateForm();
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: vm.isValid
                  ? () {
                      BloodBankModel donor = vm.getDonorModel();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Donor ${donor.name} added successfully!",
                          ),
                        ),
                      );
                      vm.clearForm();
                      Navigator.pop(context, donor);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: vm.isValid
                    ? Colors.blue
                    : Colors.grey,
              ),
              child: const Text("Submit", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
