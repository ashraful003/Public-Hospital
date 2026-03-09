import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../color/AppColor.dart';
import '../../viewModel/dashboard/DoctorViewModel.dart';
import 'DoctorDetailsScreen.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

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
      create: (_) => DoctorViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F3F7),

        appBar: AppBar(
          backgroundColor: AppColors.blue_200,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text("Doctors",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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

        body: Consumer<DoctorViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      _buildTab(
                        title: "Doctor List",
                        isSelected: vm.selectedTab == DoctorTab.all,
                        onTap: () => vm.changeTab(DoctorTab.all),
                      ),
                      _buildTab(
                        title: "Active Doctor",
                        isSelected: vm.selectedTab == DoctorTab.active,
                        onTap: () => vm.changeTab(DoctorTab.active),
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
                          child: vm.doctors.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No Doctors Found",
                                    style: TextStyle(fontSize: 16),
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
                                              ? NetworkImage(doctor.imageUrl!)
                                              : null,
                                          child: doctor.imageUrl == null
                                              ? const Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                )
                                              : null,
                                        ),
                                        title: Text(
                                          doctor.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "National ID: ${doctor.nationalId}",
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
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
