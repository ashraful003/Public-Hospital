import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/pharmacist_details_screen.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/pharmacist_view_model.dart';

class PharmacistScreen extends StatelessWidget {
  const PharmacistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PharmacistViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F3F7),
        appBar: AppBar(
          backgroundColor: AppColors.blue_200,
          title: const Text(
            'Pharmacist',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<PharmacistViewModel>(
          builder: (context, vm, child) {
            String emptyMessage = vm.selectedTab == PharmacistTab.all
                ? "Pharmacist not found"
                : "Active pharmacist not found";
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      _buildTab(
                        title: 'Pharmacist',
                        isSelected: vm.selectedTab == PharmacistTab.all,
                        onTab: () => vm.changeTab(PharmacistTab.all),
                      ),
                      _buildTab(
                        title: 'Active Pharmacist',
                        isSelected: vm.selectedTab == PharmacistTab.active,
                        onTab: () => vm.changeTab(PharmacistTab.active),
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
                            hintText: 'Search by National ID',
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
                              : vm.pharmacists.isEmpty
                              ? Center(
                                  child: Text(
                                    emptyMessage,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: vm.pharmacists.length,
                                  itemBuilder: (context, index) {
                                    final pharmacist = vm.pharmacists[index];
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
                                              pharmacist.imageUrl != null
                                              ? pharmacist.imageUrl!.startsWith(
                                                      'assets',
                                                    )
                                                    ? AssetImage(
                                                        pharmacist.imageUrl!,
                                                      )
                                                    : NetworkImage(
                                                            pharmacist
                                                                .imageUrl!,
                                                          )
                                                          as ImageProvider
                                              : null,
                                          child: pharmacist.imageUrl == null
                                              ? const Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                )
                                              : null,
                                        ),
                                        title: Text(
                                          pharmacist.name ??
                                              "Unknown Pharmacist",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'ID: ${pharmacist.nationalId ?? "N/A"}',
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PharmacistDetailsScreen(
                                                    pharmacist: pharmacist,
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
