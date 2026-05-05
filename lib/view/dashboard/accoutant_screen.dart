import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/accoutant_view_model.dart';
import 'accountant_details_screen.dart';

class AccountantScreen extends StatelessWidget {
  const AccountantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountantViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F3F7),
        appBar: AppBar(
          backgroundColor: AppColors.blue_200,
          title: const Text(
            'Accountant',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<AccountantViewModel>(
          builder: (context, vm, child) {
            String emptyMessage = vm.selectedTab == AccountantTab.all
                ? "Accountant not found"
                : "Active accountant not found";
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      _buildTab(
                        title: 'Accountant',
                        isSelected: vm.selectedTab == AccountantTab.all,
                        onTab: () => vm.changeTab(AccountantTab.all),
                      ),
                      _buildTab(
                        title: 'Active Accountant',
                        isSelected: vm.selectedTab == AccountantTab.active,
                        onTab: () => vm.changeTab(AccountantTab.active),
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
                              : vm.accountants.isEmpty
                              ? Center(
                                  child: Text(
                                    emptyMessage,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: vm.accountants.length,
                                  itemBuilder: (context, index) {
                                    final accountant = vm.accountants[index];
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
                                              accountant.imageUrl != null
                                              ? accountant.imageUrl!.startsWith(
                                                      'assets',
                                                    )
                                                    ? AssetImage(
                                                        accountant.imageUrl!,
                                                      )
                                                    : NetworkImage(
                                                            accountant
                                                                .imageUrl!,
                                                          )
                                                          as ImageProvider
                                              : null,
                                          child: accountant.imageUrl == null
                                              ? const Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                )
                                              : null,
                                        ),
                                        title: Text(
                                          accountant.name ??
                                              "Unknown Accountant",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'National ID: ${accountant.nationalId ?? "N/A"}',
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  AccountantDetailsScreen(
                                                    accountant: accountant,
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
