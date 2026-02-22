import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_hospital/model/DrawerItemModel.dart';
class DrawerViewModel extends ChangeNotifier {
  int selectedIndex = -1;

  void selectItem(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  final List<DrawerItemModel> drawerItems = [
    DrawerItemModel(
      title: 'Doctor Appointment',
      routeName: 'appointment',
      index: 0,
      iconName: 'appointment',
    ),
    DrawerItemModel(
      title: 'My Health Scanning result',
      routeName: 'health',
      index: 2,
      iconName: 'health',
    ),
    DrawerItemModel(
      title: 'Inpatient Bill Status',
      routeName: 'receipt',
      index: 3,
      iconName: 'receipt',
    ),
    DrawerItemModel(
      title: 'Inpatient Discharge Status',
      routeName: 'assignment',
      index: 4,
      iconName: 'assignment',
    ),
    DrawerItemModel(
      title: 'Setting',
      routeName: 'setting',
      index: 5,
      iconName: 'setting',
    ),
    DrawerItemModel(
      title: 'Logout',
      routeName: 'logout',
      index: 6,
      iconName: 'logout',
    ),
  ];

  IconData getIcon(String? iconName) {
    switch (iconName) {
      case 'appointment':
        return Icons.assignment;
      case 'health':
        return Icons.health_and_safety;
      case 'receipt':
        return Icons.receipt;
      case 'assignment':
        return Icons.assessment;
      case 'setting':
        return Icons.settings;
      case 'logout':
        return Icons.logout;
      default:
        return Icons.circle;
    }
  }
}
