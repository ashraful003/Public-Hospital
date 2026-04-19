import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/add_donor_screen.dart';
import '../../viewModel/dashboard/blood_profile_view_model.dart';

class BloodProfileScreen extends StatelessWidget {
  const BloodProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BloodProfileViewModel()..init(),
      child: const _BloodProfileView(),
    );
  }
}

class _BloodProfileView extends StatelessWidget {
  const _BloodProfileView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BloodProfileViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Profile"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 10),
            child: IconButton(
              icon: Icon(vm.profile == null ? Icons.add : Icons.edit),
              onPressed: () async {
                if (vm.profile == null) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddDonorScreen()),
                  );
                  vm.init();
                } else {
                  _showEditDonationDialog(context, vm);
                }
              },
            ),
          ),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.profile == null
          ? const Center(child: Text("No profile found"))
          : _profile(vm),
    );
  }

  Widget _profile(BloodProfileViewModel vm) {
    final p = vm.profile!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _item("Name", p.name),
              _item("Email", p.email),
              _item("Phone", p.phoneNumber),
              _item("Address", p.address),
              _item("Blood Group", p.bloodGroup),
              _item(
                "Donation date",
                p.lastDonateDate == null
                    ? "Not available"
                    : p.lastDonateDate.toString().split(" ")[0],
              ),
              _item("Duration", "${p.daysAgo} days"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showEditDonationDialog(BuildContext context, BloodProfileViewModel vm) {
    DateTime? selectedDate;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Donation Date"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedDate == null
                        ? "No date selected"
                        : selectedDate.toString().split(" ")[0],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: const Text("Pick Date"),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDate != null) {
                  await vm.updateDonationDate(selectedDate!);
                  Navigator.pop(context);
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
