import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../data/shared_pref_service.dart';
import '../../viewModel/dashboard/dashboard_view_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = SharedPrefService.getRole() ?? "";
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(role),
      child: Consumer<DashboardViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (vm.errorMessage != null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(vm.errorMessage!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        vm.loadCurrentUser();
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            body: IndexedStack(index: vm.currentIndex, children: vm.screens),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: vm.currentIndex,
              onTap: vm.changeTab,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.blue_200,
              unselectedItemColor: AppColors.black100,
              items: vm.navItems.map((item) {
                return BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
