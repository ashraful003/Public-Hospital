import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/blood_donor_view_model.dart';
import 'add_donor_screen.dart';

class BloodBankScreen extends StatelessWidget {
  const BloodBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BloodBankViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Blood Donors"), centerTitle: true),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddDonorScreen()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Consumer<BloodBankViewModel>(
                builder: (context, vm, child) {
                  return TextField(
                    decoration: InputDecoration(
                      hintText: "Search by blood group",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: vm.searchByBloodGroup,
                  );
                },
              ),
            ),
            Expanded(
              child: Consumer<BloodBankViewModel>(
                builder: (context, vm, child) {
                  if (vm.donors.isEmpty) {
                    return const Center(child: Text("No donors found"));
                  }
                  return ListView.builder(
                    itemCount: vm.donors.length,
                    itemBuilder: (context, index) {
                      final donor = vm.donors[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(
                              donor.bloodGroup,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(donor.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Donated: ${donor.daysAgo} days ago"),
                              Text("Address: ${donor.address}"),
                              Text("Phone: ${donor.phoneNumber}"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
