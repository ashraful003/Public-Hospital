import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/color/app_color.dart';
import 'package:public_hospital/view/dashboard/nurse_details_screen.dart';
import 'package:public_hospital/viewModel/dashboard/nurse_view_model.dart';

class NurseScreen extends StatelessWidget {
  const NurseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NurseViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F3F7),
        appBar: AppBar(
          backgroundColor: AppColors.blue_200,
          title: const Text(
            'Nurse',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<NurseViewModel>(
          builder: (context, vm, child) {
            String emptyMessage = vm.selectedTab == NurseTab.all
                ? "Nurse not found"
                : "Active nurse not found";
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      _buildTab(
                        title: 'Nurse',
                        isSelected: vm.selectedTab == NurseTab.all,
                        onTab: () => vm.changeTab(NurseTab.all),
                      ),
                      _buildTab(
                        title: 'Active Nurse',
                        isSelected: vm.selectedTab == NurseTab.active,
                        onTab: () => vm.changeTab(NurseTab.active),
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
                              : vm.nurses.isEmpty
                              ? Center(
                                  child: Text(
                                    emptyMessage,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: vm.nurses.length,
                                  itemBuilder: (context, index) {
                                    final nurse = vm.nurses[index];
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
                                              nurse.imageUrl != null
                                              ? nurse.imageUrl!.startsWith(
                                                      'assets',
                                                    )
                                                    ? AssetImage(
                                                        nurse.imageUrl!,
                                                      )
                                                    : NetworkImage(
                                                            nurse.imageUrl!,
                                                          )
                                                          as ImageProvider
                                              : null,
                                          child: nurse.imageUrl == null
                                              ? const Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                )
                                              : null,
                                        ),
                                        title: Text(
                                          nurse.name ?? "Unknown Nurse",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Id: ${nurse.nationalId ?? "N/A"}',
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  NurseDetailsScreen(
                                                    nurse: nurse,
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
