import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/drawer_view_model.dart';

class DrawerLayout extends StatelessWidget {
  const DrawerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawerViewModel(),
      child: Consumer<DrawerViewModel>(
        builder: (context, vm, child) {
          return Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blue100,
                          AppColors.blue100.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: vm.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.white,
                                backgroundImage: vm.imageUrl.isNotEmpty
                                    ? NetworkImage(vm.imageUrl)
                                    : null,
                                child: vm.imageUrl.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                vm.userName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                vm.email,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vm.drawerItems.length,
                      itemBuilder: (context, index) {
                        final item = vm.drawerItems[index];
                        final isLogout = item.iconName == "logout";
                        final isSelected = vm.selectedIndex == item.index;
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: isSelected
                                ? AppColors.blue100.withOpacity(0.15)
                                : Colors.transparent,
                          ),
                          child: ListTile(
                            leading: Icon(
                              vm.getIcon(item.iconName),
                              color: isLogout
                                  ? Colors.red
                                  : isSelected
                                  ? AppColors.blue100
                                  : Colors.grey.shade700,
                            ),
                            title: Text(item.title),
                            onTap: () async {
                              vm.selectItem(item.index);
                              final isLogout = item.iconName == "logout";
                              if (isLogout) {
                                _showLogoutDialog(context, vm);
                                return;
                              }
                              Navigator.pop(context);
                              await Future.delayed(
                                const Duration(milliseconds: 150),
                              );
                              await vm.handleNavigation(context, item);
                              vm.showToast("${item.title} clicked");
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, DrawerViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure to logout?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await Future.delayed(const Duration(milliseconds: 100));
                await vm.logout(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
