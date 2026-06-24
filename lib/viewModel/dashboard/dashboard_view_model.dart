import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:public_hospital/color/app_color.dart';
import '../../data/shared_pref_service.dart';
import '../../model/bottom_nav_item_model.dart';
import '../../model/user_model.dart';
import '../../service/api_client.dart';
import '../../service/api_config.dart';
import '../../view/dashboard/home_screen.dart';
import '../../view/dashboard/profile_screen.dart';
import '../../view/dashboard/user_appointment_screen.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel(this.role) {
    loadCurrentUser();
  }

  final String role;
  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;
  int currentIndex = 0;
  List<BottomNavItemModel> navItems = [];
  List<Widget> screens = [
    const Center(child: CircularProgressIndicator()),
    const Center(child: CircularProgressIndicator()),
    const Center(child: CircularProgressIndicator()),
  ];

  Future<void> loadCurrentUser() async {
    try {
      isLoading = true;
      notifyListeners();
      final email =
          SharedPrefService.getString("remember_email") ??
          SharedPrefService.getString("user_email");
      final savedRole =
          SharedPrefService.getString("role") ??
          SharedPrefService.getString("user_role");
      if (email == null || email.isEmpty) {
        errorMessage = "Email not found";
        return;
      }
      final url = "${ApiConfig.baseUrl}/profile?email=$email&role=$savedRole";
      final response = await ApiClient.get(url);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        currentUser = UserModel.fromJson(json);
        _initializeNavItems();
        _initializeScreens();
      } else {
        errorMessage = json["message"] ?? "Failed to load profile";
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _initializeNavItems() {
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
  }

  void _initializeScreens() {
    if (currentUser == null) return;
    screens = [
      HomeScreen(role: role),
      UserAppointmentScreen(patientId: currentUser!.nationalId!),
      ProfileScreen(dashboardRole: role),
    ];
  }

  void changeTab(int index) {
    currentIndex = index;
    notifyListeners();
  }

  String get userName => currentUser?.name ?? "";

  String get email => currentUser?.email ?? "";

  String get nationalId => currentUser?.nationalId ?? "";

  String get userRole => currentUser?.roleValue ?? "";
}