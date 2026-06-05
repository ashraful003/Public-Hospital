import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_hospital/data/shared_pref_service.dart';
import 'package:public_hospital/model/home_item_model.dart';
import 'package:public_hospital/model/user_model.dart';
import 'package:public_hospital/service/api_client.dart';
import 'package:public_hospital/service/api_config.dart';
import 'package:public_hospital/view/dashboard/admission_screen.dart';
import 'package:public_hospital/view/dashboard/ambulance_screen.dart';
import 'package:public_hospital/view/dashboard/appointment_screen.dart';
import 'package:public_hospital/view/dashboard/blood_donor_screen.dart';
import 'package:public_hospital/view/dashboard/diagnostic_center_screen.dart';
import 'package:public_hospital/view/dashboard/medicine_screen.dart';
import 'package:public_hospital/view/dashboard/pharmaceutical_screen.dart';
import 'package:public_hospital/view/dashboard/prescription_screen.dart';
import 'package:public_hospital/view/dashboard/reports_screen.dart';
import 'package:public_hospital/view/dashboard/search_prescription_screen.dart';
import 'package:public_hospital/view/dashboard/search_report_screen.dart';
import 'package:public_hospital/view/dashboard/staff_screen.dart';
import 'package:public_hospital/viewModel/dashboard/search_bill_status_view_model.dart';

import '../../view/dashboard/bill_status_screen.dart';
import '../../view/dashboard/search_bill_status_screen.dart';

class HomeSection {
  final List<HomeItemModel> items;

  HomeSection({required this.items});
}

class HomeViewModel extends ChangeNotifier {
  final String role;

  HomeViewModel(this.role) {
    _init();
    loadCurrentUser();
  }

  UserModel? currentUser;
  bool isLoading = false;

  Future<void> loadCurrentUser() async {
    try {
      isLoading = true;
      notifyListeners();
      final email =
          SharedPrefService.getString("remember_email") ??
          SharedPrefService.getString("user_email");
      final savedRole =
          SharedPrefService.getString("role") ??
          SharedPrefService.getString("user_role") ??
          role;
      if (email == null || email.isEmpty) {
        debugPrint("Email not found");
        return;
      }
      final url = "${ApiConfig.baseUrl}/profile?email=$email&role=$savedRole";
      final response = await ApiClient.get(url);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        currentUser = UserModel.fromJson(json);
      } else {
        Fluttertoast.showToast(
          msg: json["message"] ?? "Failed to load profile",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  final Map<String, List<String>> roleAccess = {
    "admin": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Reports",
      "Bill Status",
      "Discharge",
      "Meals",
      "Health\nDeclaration",
      "Facility",
      "Blood Bank",
      "Ambulance",
      "Booking",
      "Diagnostic\nCenter",
      "Pharmaceutical",
      "Medicine\nStore",
      "Parking",
      "Staff",
    ],
    "patient": [
      "Appointment",
      "Admission",
      "Emergency",
      "Prescription",
      "Reports",
      "Bill Status",
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
      "Reports",
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
      "Reports",
      "Bill Status",
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
      "Reports",
      "Bill Status",
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
      "Reports",
      "Bill Status",
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
      "Reports",
      "Bill Status",
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
      "Reports",
      "Bill Status",
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
      "Reports",
      "Bill Status",
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
    "pharmaceutical": ["Emergency", "Facility", "Medicine\nStore", "Parking"],
    "diagnostic_center": ["Emergency", "Reports", "Facility", "Parking"],
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
        title: "Reports",
        icon: Icons.assignment,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Bill Status",
        icon: Icons.description,
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
        title: "Pharmaceutical",
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
    final allowed = roleAccess[role.toLowerCase()] ?? [];
    return items.where((item) {
      return allowed.contains(item.title);
    }).toList();
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
        if (role.toLowerCase() == "doctor") {
          _navigate(context, SearchPrescriptionScreen(role: role));
        } else {
          _navigate(
            context,
            PrescriptionScreen(
              patientId: currentUser?.nationalId ?? "",
              role: role,
            ),
          );
        }
        break;

      case "Reports":
        if (role.toLowerCase() == "doctor") {
          _navigate(context, SearchReportScreen(role: role));
        } else {
          _navigate(
            context,
            ReportsScreen(
              patientId: currentUser?.nationalId ?? "",
              role: role,
            ),
          );
        }
        break;

      case "Diagnostic\nCenter":
        _navigate(context, const DiagnosticCenterScreen());
        break;

      case "Pharmaceutical":
        _navigate(context, const PharmaceuticalScreen());
        break;

      case "Medicine\nStore":
        _navigate(context, const MedicineScreen());
        break;

      case "Staff":
        _navigate(context, const StaffScreen());
        break;

      case "Blood Bank":
        _navigate(context, const BloodDonorScreen());
        break;

      case "Ambulance":
        _navigate(context, const AmbulanceScreen());
        break;

      case "Bill Status":
        final userRole = role.toLowerCase();
        final patientId = currentUser?.nationalId ?? "";
        if (userRole == "admin" || userRole == "accountant") {
          _navigate(context, SearchBillStatusScreen(role: role));
        } else {
          _navigate(
            context,
            BillStatusScreen(
              role: role,
              patientId: patientId,
            ),
          );
        }
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
