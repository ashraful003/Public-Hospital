import 'package:flutter/material.dart';
import 'package:public_hospital/color/app_color.dart';
import '../../model/bottom_nav_item_model.dart';
import '../../view/dashboard/home_screen.dart';
import '../../view/dashboard/appointment_screen.dart';
import '../../view/dashboard/profile_screen.dart';

class DashboardViewModel extends ChangeNotifier {
  final String role;

  DashboardViewModel(this.role) {
    _init();
  }

  int currentIndex = 0;

  late final List<BottomNavItemModel> navItems;
  late final List<Widget> screens;

  void _init() {
    navItems = [
      BottomNavItemModel(
        label: "Home",
        icon: Icons.home,
        iconColor: AppColors.black100,
        textColor: AppColors.black100,
      ),
      BottomNavItemModel(
        label: "Appointment",
        icon: Icons.list_alt,
        iconColor: AppColors.black100,
        textColor: AppColors.black100,
      ),
      BottomNavItemModel(
        label: "Profile",
        icon: Icons.person,
        iconColor: AppColors.black100,
        textColor: AppColors.black100,
      ),
    ];

    screens = [
      HomeScreen(role: role),
      const AppointmentScreen(),
      ProfileScreen(dashboardRole: role),
    ];
  }

  void changeTab(int index) {
    currentIndex = index;
    notifyListeners();
  }
}