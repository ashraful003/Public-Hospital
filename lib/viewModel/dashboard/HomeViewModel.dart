import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_hospital/model/HomeItemModel.dart';

import '../../view/dashboard/AdmissionScreen.dart';
import '../../view/dashboard/AppointMentScreen.dart';
import '../../view/dashboard/SearchPrescriptionScreen.dart';

class HomeViewModel extends ChangeNotifier {
  // ================= TOP ITEMS =================
  final List<HomeItemModel> topItems = [
    HomeItemModel(
      title: "Appointment",
      icon: Icons.event_note,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Admission",
      icon: Icons.person_add,
      bgColor: Colors.blue,
    ),
    HomeItemModel(title: "Emergency", icon: Icons.call, bgColor: Colors.red),
  ];

  // ================= PATIENT ITEMS =================
  final List<HomeItemModel> patientItems = [
    HomeItemModel(
      title: "Prescription",
      icon: Icons.receipt,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Report",
      icon: Icons.assignment,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Bill Status",
      icon: Icons.description,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Bill Settlement",
      icon: Icons.request_page,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Discharge",
      icon: Icons.accessible,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Emergency",
      icon: Icons.access_time,
      bgColor: Colors.red,
    ),
    HomeItemModel(
        title: "Meals",
        icon: Icons.restaurant,
        bgColor: Colors.blue
    ),
    HomeItemModel(
      title: "Health\nDeclaration",
      icon: Icons.checklist,
      bgColor: Colors.blue,
    ),
  ];

  // ================= SERVICE ITEMS =================
  final List<HomeItemModel> serviceItems = [
    HomeItemModel(
      title: "Facility",
      icon: Icons.local_hospital,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Blood Bank",
      icon: Icons.bloodtype,
      bgColor: Colors.red,
    ),
    HomeItemModel(
      title: "Ambulance",
      icon: Icons.local_taxi,
      bgColor: Colors.blue,
    ),
    HomeItemModel(title: "Booking", icon: Icons.bed, bgColor: Colors.blue),
    HomeItemModel(
      title: "Diagnostic\nCenter",
      icon: Icons.apartment,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Medicine\nCompany",
      icon: Icons.medical_services,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Medicine\nStore",
      icon: Icons.store,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Parking",
      icon: Icons.local_parking,
      bgColor: Colors.blue,
    ),
  ];

  // ================= Staff ITEMS =================
  final List<HomeItemModel> staffItem = [
    HomeItemModel(
      title: "Doctor",
      icon: Icons.person,
      bgColor: Colors.blue,
    ),
    HomeItemModel(
      title: "Nurse",
      icon: Icons.health_and_safety,
      bgColor: Colors.pink,
    ),
    HomeItemModel(
      title: "Human\nResource",
      icon: Icons.groups,
      bgColor: Colors.deepPurple,
    ),
    HomeItemModel(
      title: "Other\nStaff",
      icon: Icons.badge,
      bgColor: Colors.teal,
    ),
  ];

  // ================= CLICK HANDLER =================
  void onItemTap(BuildContext context, HomeItemModel item) {
    if (item.title == "Appointment") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AppointmentScreen()),
      );
      return;
    }

    if (item.title == "Admission") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdmissionScreen()),
      );
      return;
    }

    if (item.title == "Prescription") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchPrescriptionScreen()),
      );
      return;
    }

    Fluttertoast.showToast(
      msg: item.title.replaceAll("\n", " "),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
