import 'package:flutter/material.dart';
import 'package:public_hospital/color/app_color.dart';
import '../../model/bottom_nav_item_model.dart';
import '../../view/dashboard/home_screen.dart';
import '../../view/dashboard/appointment_screen.dart';
import '../../view/dashboard/profile_screen.dart';

class DashboardViewModel extends ChangeNotifier {
  int currentIndex = 0;

  final List<BottomNavItemModel> navItems = [
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

  final List<Widget> screens = [
    const HomeScreen(),
    const AppointmentScreen(),
    const ProfileScreen(),
  ];

  void changeTab(int index) {
    currentIndex = index;
    notifyListeners();
  }
}