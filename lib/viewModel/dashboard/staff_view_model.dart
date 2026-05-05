import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:public_hospital/model/home_item_model.dart';
import 'package:public_hospital/view/dashboard/attendance_list_screen.dart';
import 'package:public_hospital/view/dashboard/doctor_screen.dart';
import 'package:public_hospital/view/dashboard/nurse_screen.dart';
import 'package:public_hospital/view/dashboard/doctor_assistant_screen.dart';
import 'package:public_hospital/view/dashboard/cleaner_screen.dart';
import 'package:public_hospital/view/dashboard/pharmacist_screen.dart';
import 'package:public_hospital/view/dashboard/receptionist_screen.dart';
import 'package:public_hospital/view/dashboard/driver_screen.dart';
import '../../view/dashboard/accoutant_screen.dart';
import '../../view/dashboard/staff_registration_screen.dart';

class StaffViewModel extends ChangeNotifier {
  List<HomeItemModel> _allItems = [];
  List<HomeItemModel> staffItems = [];
  String userRole = '';

  Future<void> init() async {
    await _loadRole();
    _setAllItems();
    _filterItems();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('user_role') ?? '';
  }

  void _setAllItems() {
    _allItems = [
      HomeItemModel(
        title: "Doctor",
        icon: Icons.medical_services,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Doctor Assistant",
        icon: Icons.support_agent,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Nurse",
        icon: Icons.health_and_safety,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Accountant",
        icon: Icons.calculate,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Pharmacist",
        icon: Icons.local_pharmacy,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Receptionist",
        icon: Icons.person,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Driver",
        icon: Icons.drive_eta_rounded,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Cleaner",
        icon: Icons.cleaning_services,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Attendance",
        icon: Icons.fact_check,
        bgColor: Colors.blue,
      ),
    ];
  }

  void _filterItems() {
    if (userRole.toUpperCase() == 'ADMIN') {
      staffItems = _allItems;
    } else {
      staffItems = _allItems.where((item) {
        return item.title != "Attendance";
      }).toList();
    }
    notifyListeners();
  }

  void onStaffTap(BuildContext context, HomeItemModel item) {
    switch (item.title) {
      case 'Doctor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DoctorScreen()),
        );
        break;
      case 'Nurse':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NurseScreen()),
        );
        break;
      case 'Doctor Assistant':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DoctorAssistantScreen()),
        );
        break;
      case 'Accountant':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AccountantScreen()),
        );
        break;
      case 'Pharmacist':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PharmacistScreen()),
        );
        break;
      case 'Receptionist':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReceptionistScreen()),
        );
        break;
      case 'Driver':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DriverScreen()),
        );
        break;
      case 'Cleaner':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CleanerScreen()),
        );
        break;
      case 'Attendance':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AttendanceListScreen()),
        );
        break;
    }
  }

  void goToRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StaffRegistrationScreen()),
    );
  }

  bool get isAdmin => userRole.toUpperCase() == 'ADMIN';
}
