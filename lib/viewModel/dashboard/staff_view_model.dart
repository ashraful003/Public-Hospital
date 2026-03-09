import 'package:flutter/material.dart';
import 'package:public_hospital/model/home_item_model.dart';
import 'package:public_hospital/view/dashboard/attendance_screen.dart';
import 'package:public_hospital/view/dashboard/cleaner_screen.dart';
import 'package:public_hospital/view/dashboard/doctor_assistant_screen.dart';
import 'package:public_hospital/view/dashboard/doctor_screen.dart';
import 'package:public_hospital/view/dashboard/nurse_screen.dart';

import '../../view/dashboard/staff_registration_screen.dart';

class StaffViewModel extends ChangeNotifier {
  final List<HomeItemModel> staffItems = [
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

  void onStaffTap(BuildContext context, HomeItemModel item) {
    if (item.title == 'Doctor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DoctorScreen()),
      );
    }
    if (item.title == 'Nurse') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NurseScreen()),
      );
    }
    if (item.title == 'Doctor Assistant') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DoctorAssistantScreen()),
      );
    }
    if (item.title == 'Cleaner') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CleanerScreen()),
      );
    }
    if (item.title == 'Attendance') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AttendanceScreen()),
      );
    }
  }

  void goToRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StaffRegistrationScreen()),
    );
  }
}
