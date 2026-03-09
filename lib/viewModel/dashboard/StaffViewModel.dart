import 'package:flutter/material.dart';
import 'package:public_hospital/model/HomeItemModel.dart';
import 'package:public_hospital/view/dashboard/AttendanceScreen.dart';
import 'package:public_hospital/view/dashboard/CleanerScreen.dart';
import 'package:public_hospital/view/dashboard/DoctorAssistantScreen.dart';
import 'package:public_hospital/view/dashboard/DoctorScreen.dart';
import 'package:public_hospital/view/dashboard/NurseScreen.dart';

import '../../view/dashboard/StaffRegistrationScreen.dart';

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
