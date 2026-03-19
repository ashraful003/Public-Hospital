import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../viewModel/dashboard/dashboard_view_model.dart';
import '../../model/bottom_nav_item_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Consumer<DashboardViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body: vm.screens[vm.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: vm.currentIndex,
              onTap: vm.changeTab,
              type: BottomNavigationBarType.fixed,
              items: vm.navItems.asMap().entries.map((entry) {
                int index = entry.key;
                BottomNavItemModel item = entry.value;

                bool isSelected = vm.currentIndex == index;

                return BottomNavigationBarItem(
                  icon: Icon(
                    item.icon,
                    color: isSelected ? AppColors.blue_200 : item.iconColor,
                  ),
                  label: item.label,
                  tooltip: '',
                );
              }).toList(),

              selectedItemColor: AppColors.blue_200,
              unselectedItemColor: AppColors.black100,
            ),
          );
        },
      ),
    );
  }
}
