import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/color/app_color.dart';
import 'package:public_hospital/view/dashboard/doctor_details_screen.dart';
import 'package:public_hospital/viewModel/dashboard/doctor_view_model.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F3F7),
        appBar: AppBar(
          backgroundColor: AppColors.blue_200,
          title: const Text(
            'Doctor',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<DoctorViewModel>(
          builder: (context, vm, child) {
            String emptyMessage = vm.selectedTab == DoctorTab.all
                ? "Doctor not found"
                : "Active doctor not found";
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      _buildTab(
                        title: 'Doctor',
                        isSelected: vm.selectedTab == DoctorTab.all,
                        onTab: () => vm.changeTab(DoctorTab.all),
                      ),
                      _buildTab(
                        title: 'Active Doctor',
                        isSelected: vm.selectedTab == DoctorTab.active,
                        onTab: () => vm.changeTab(DoctorTab.active),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Search by National ID",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: vm.searchByNationalId,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: vm.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : vm.doctors.isEmpty
                              ? Center(
                                  child: Text(
                                    emptyMessage,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: vm.doctors.length,
                                  itemBuilder: (context, index) {
                                    final doctor = vm.doctors[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.grey.shade200,
                                          backgroundImage:
                                              doctor.imageUrl != null
                                              ? doctor.imageUrl!.startsWith(
                                                      'assets',
                                                    )
                                                    ? AssetImage(
                                                        doctor.imageUrl!,
                                                      )
                                                    : NetworkImage(
                                                            doctor.imageUrl!,
                                                          )
                                                          as ImageProvider
                                              : null,
                                          child: doctor.imageUrl == null
                                              ? const Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                )
                                              : null,
                                        ),
                                        title: Text(
                                          doctor.name ?? "Unknown Doctor",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'National Id: ${doctor.nationalId ?? "N/A"}',
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  DoctorDetailsScreen(
                                                    doctor: doctor,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTab,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTab,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.blue_200 : Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 3,
              color: isSelected ? AppColors.blue_200 : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
