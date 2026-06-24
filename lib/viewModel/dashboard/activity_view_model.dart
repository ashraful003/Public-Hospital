import 'package:flutter/material.dart';
import 'package:public_hospital/model/home_item_model.dart';
import 'package:public_hospital/view/dashboard/advice_screen.dart';
import 'package:public_hospital/view/dashboard/doctor_appointment_screen.dart';
import 'package:public_hospital/view/dashboard/dose_time_screen.dart';
import 'package:public_hospital/view/dashboard/doses_screen.dart';
import 'package:public_hospital/view/dashboard/medicine_type_screen.dart';
import 'package:public_hospital/view/dashboard/next_meet_screen.dart';
import '../../view/dashboard/duration_screen.dart';

class ActivityViewModel extends ChangeNotifier {
  final String role;
  final String nationalId;

  ActivityViewModel({required this.role, required this.nationalId});

  List<HomeItemModel> _allItems = [];
  List<HomeItemModel> items = [];

  Future<void> init() async {
    _setItems();
    _filterItems();
  }

  void _setItems() {
    _allItems = [
      HomeItemModel(
        title: "Appointment",
        icon: Icons.calendar_month,
        bgColor: Colors.blue,
      ),
      HomeItemModel(
        title: "Advice",
        icon: Icons.medical_information,
        bgColor: Colors.green,
      ),
      HomeItemModel(
        title: "Medicine Type",
        icon: Icons.timer,
        bgColor: Colors.blueGrey,
      ),
      HomeItemModel(
        title: "Next Meet",
        icon: Icons.timer,
        bgColor: Colors.purple,
      ),
      HomeItemModel(
        title: "Doses",
        icon: Icons.watch_later,
        bgColor: Colors.brown,
      ),
      HomeItemModel(
        title: "Dose Time",
        icon: Icons.watch_later,
        bgColor: Colors.blueAccent,
      ),
      HomeItemModel(
        title: "Duration",
        icon: Icons.hourglass_bottom,
        bgColor: Colors.orange,
      ),
    ];
  }

  void _filterItems() {
    items = _allItems;
    notifyListeners();
  }

  void onItemTap(BuildContext context, HomeItemModel item) {
    final title = item.title.replaceAll("\n", " ");
    switch (title) {
      case "Advice":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdviceScreen(role: role, nationalId: nationalId),
          ),
        );
        break;
      case "Medicine Type":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MedicineTypeScreen(role: role, nationalId: nationalId),
          ),
        );
        break;
      case "Next Meet":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NextMeetScreen(role: role, nationalId: nationalId),
          ),
        );
        break;
      case "Doses":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoseScreen(role: role, nationalId: nationalId),
          ),
        );
        break;
      case "Dose Time":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoseTimeScreen(role: role, nationalId: nationalId),
          ),
        );
        break;
      case "Duration":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DurationScreen(role: role, nationalId: nationalId),
          ),
        );
        break;
      case "Appointment":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DoctorAppointmentScreen(role: role, nationalId: nationalId),
          ),
        );
        break;
      default:
        break;
    }
  }
}