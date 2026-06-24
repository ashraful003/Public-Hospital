import 'package:flutter/material.dart';
import '../../model/home_item_model.dart';
import '../../view/dashboard/appointment_schedule_screen.dart';
import '../../view/dashboard/patient_appointment_screen.dart';

class DoctorAppointmentViewModel extends ChangeNotifier {
  final String role;
  final String nationalId;

  DoctorAppointmentViewModel({required this.role, required this.nationalId});

  List<HomeItemModel> items = [];

  void init() {
    items = [
      HomeItemModel(
        title: "Patient\nAppointment",
        icon: Icons.person,
        bgColor: Colors.teal,
        type: "patient_appointment",
      ),
      HomeItemModel(
        title: "Appointment\nSchedule",
        icon: Icons.schedule,
        bgColor: Colors.indigo,
        type: "appointment_schedule",
      ),
    ];
    notifyListeners();
  }

  void onItemTap(BuildContext context, HomeItemModel item) {
    switch (item.type) {
      case "patient_appointment":
        if (role == "DOCTOR" || role == "ADMIN") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PatientAppointmentScreen(role: role, patientId: nationalId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "You are not authorized to view patient appointments.",
              ),
            ),
          );
        }
        break;
      case "appointment_schedule":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentScheduleScreen(
              userRole: role,
              nationalId: nationalId,
            ),
          ),
        );
        break;
      default:
        break;
    }
  }
}