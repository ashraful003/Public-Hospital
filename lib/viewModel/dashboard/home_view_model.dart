import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/home_item_model.dart';
import '../../view/dashboard/admission_screen.dart';
import '../../view/dashboard/ambulance_screen.dart';
import '../../view/dashboard/appointment_screen.dart';
import '../../view/dashboard/blood_donor_screen.dart';
import '../../view/dashboard/search_prescription_screen.dart';
import '../../view/dashboard/staff_screen.dart';

class HomeSection {
  final List<HomeItemModel> items;

  HomeSection({required this.items});
}

class HomeViewModel extends ChangeNotifier {
  final String role;

  HomeViewModel(this.role) {
    _init();
  }

  final Map<String, List<String>> roleAccess = {
    "admin": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Report",
      "Bill Status",
      "Bill Settlement",
      "Discharge",
      "Meals",
      "Health\nDeclaration",
      "Facility",
      "Blood Bank",
      "Ambulance",
      "Booking",
      "Diagnostic\nCenter",
      "Medicine\nCompany",
      "Medicine\nStore",
      "Parking",
      "Staff",
    ],
    "patient": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Report",
      "Bill Status",
      "Bill Settlement",
      "Discharge",
      "Meals",
      "Health\nDeclaration",
      "Facility",
      "Blood Bank",
      "Ambulance",
      "Booking",
      "Medicine\nStore",
      "Parking",
    ],
    "doctor": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Report",
      "Bill Status",
      "Discharge",
      "Meals",
      "Facility",
      "Blood Bank",
      "Ambulance",
      "Booking",
      "Medicine\nStore",
      "Parking",
      "Staff",
    ],
    "nurse": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Report",
      "Bill Status",
      "Bill Settlement",
      "Discharge",
      "Meals",
      "Health\nDeclaration",
      "Facility",
      "Blood Bank",
      "Ambulance",
      "Booking",
      "Medicine\nStore",
      "Parking",
      "Staff",
    ],
    "doctor_assistant": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Report",
      "Bill Status",
      "Bill Settlement",
      "Discharge",
      "Meals",
      "Health\nDeclaration",
      "Facility",
      "Blood Bank",
      "Ambulance",
      "Booking",
      "Medicine\nStore",
      "Parking",
      "Staff",
    ],
    "cleaner": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Report",
      "Bill Status",
      "Bill Settlement",
      "Discharge",
      "Meals",
      "Health\nDeclaration",
      "Facility",
      "Blood Bank",
      "Ambulance",
      "Booking",
      "Medicine\nStore",
      "Parking",
      "Staff",
    ],
    "accountant": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Report",
      "Bill Status",
      "Bill Settlement",
      "Discharge",
      "Meals",
      "Facility",
      "Booking",
      "Medicine\nStore",
      "Parking",
      "Staff",
    ],
    "pharmacist": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Facility",
      "Medicine\nStore",
      "Parking",
      "Staff",
    ],
    "receptionist": [
      "Appointment",
      "Admission",
      "Emergency",
      "Report",
      "Bill Status",
      "Bill Settlement",
      "Discharge",
      "Meals",
      "Health\nDeclaration",
      "Facility",
      "Blood Bank",
      "Ambulance",
      "Booking",
      "Medicine\nStore",
      "Parking",
      "Staff",
    ],
    "driver": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Report",
      "Bill Status",
      "Bill Settlement",
      "Discharge",
      "Meals",
      "Health\nDeclaration",
      "Facility",
      "Blood Bank",
      "Ambulance",
      "Booking",
      "Medicine\nStore",
      "Parking",
      "Staff",
    ],
    "pharmaceutical": [
      "Emergency",
      "Facility",
      "Medicine\nCompany",
      "Medicine\nStore",
      "Parking",
    ],
    "diagnosticCenter": ["Emergency", "Report", "Facility", "Parking"],
  };

  List<HomeItemModel> get topItems {
    final items = [
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
    return _filterItems(items);
  }

  final HomeItemModel staffButton = HomeItemModel(
    title: "Staff",
    icon: Icons.groups,
    bgColor: Colors.deepPurple,
  );

  bool get showStaffButton => roleAccess[role]?.contains("Staff") ?? false;
  late List<HomeSection> sections;

  void _init() {
    sections = [HomeSection(items: _filterItems(_allItems()))];
  }

  List<HomeItemModel> _allItems() {
    return [
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
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Health\nDeclaration",
        icon: Icons.checklist,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Facility",
        icon: Icons.local_hospital,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Blood Bank",
        icon: Icons.bloodtype,
        bgColor: Colors.blue,
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
      HomeItemModel(
        title: "Staff",
        icon: Icons.groups,
        bgColor: Colors.deepPurple,
      ),
    ];
  }

  List<HomeItemModel> _filterItems(List<HomeItemModel> items) {
    final allowed = roleAccess[role] ?? [];
    return items.where((item) => allowed.contains(item.title)).toList();
  }

  void onItemTap(BuildContext context, HomeItemModel item) {
    switch (item.title) {
      case "Appointment":
        _navigate(context, const AppointmentScreen());
        break;
      case "Admission":
        _navigate(context, AdmissionScreen(role: role));
        break;
      case "Prescription":
        _navigate(context, const SearchPrescriptionScreen());
        break;
      case "Staff":
        _navigate(context, const StaffScreen());
        break;
      case "Blood Bank":
        _navigate(context, const BloodDonorScreen());
        break;
      case "Ambulance":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AmbulanceScreen()),
        );
        break;
      default:
        _showToast(item.title);
    }
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message.replaceAll("\n", " "),
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }
}
