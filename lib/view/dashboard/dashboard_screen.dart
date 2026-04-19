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
          return Scaffold(
            body: vm.screens[vm.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: vm.currentIndex,
              onTap: vm.changeTab,
              type: BottomNavigationBarType.fixed,
              items: vm.navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = vm.currentIndex == index;
                return BottomNavigationBarItem(
                  icon: Icon(
                    item.icon,
                    color: isSelected ? AppColors.blue_200 : item.iconColor,
                  ),
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
