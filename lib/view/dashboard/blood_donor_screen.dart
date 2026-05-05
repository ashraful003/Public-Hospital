import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/blood_donor_view_model.dart';
import 'add_donor_screen.dart';
import 'blood_donor_details_screen.dart';

class BloodDonorScreen extends StatelessWidget {
  const BloodDonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BloodDonorViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Blood Donors"), centerTitle: true),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Consumer<BloodDonorViewModel>(
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
              child: Consumer<BloodDonorViewModel>(
                builder: (context, vm, child) {
                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (vm.donors.isEmpty) {
                    return const Center(child: Text("Donors not found"));
                  }
                  return ListView.builder(
                    itemCount: vm.donors.length,
                    itemBuilder: (context, index) {
                      final donor = vm.donors[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BloodDonorDetailsScreen(donor: donor),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(
                              donor.bloodGroup,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            donor.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Donated: ${donor.daysAgo} days ago"),
                              Text("Address: ${donor.address}"),
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
