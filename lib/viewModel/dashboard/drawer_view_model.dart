import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_hospital/view/dashboard/test_queue_screen.dart';
import '../../data/shared_pref_service.dart';
import '../../model/drawer_item_model.dart';
import '../../model/user_model.dart';
import '../../service/api_client.dart';
import '../../service/api_config.dart';
import '../../view/dashboard/activity_screen.dart';
import '../../view/dashboard/search_doctor_activity_screen.dart';
import '../../view/dashboard/test_screen.dart';
import '../../view/login/login_input_screen.dart';

class DrawerViewModel extends ChangeNotifier {
  DrawerViewModel() {
    loadCurrentUser();
  }

  int selectedIndex = -1;
  bool isLoading = false;
  UserModel? currentUser;
  List<DrawerItemModel> drawerItems = [];

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
        isLoading = false;
        notifyListeners();
        return;
      }
      final url = "${ApiConfig.baseUrl}/profile?email=$email&role=$savedRole";
      final response = await ApiClient.get(url);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        currentUser = UserModel.fromJson(json);
        _buildDrawerItems();
      } else {
        Fluttertoast.showToast(
          msg: json["message"] ?? "Failed to load profile",
        );
      }
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _buildDrawerItems() {
    final role = currentUser?.roleValue ?? "";
    if (role == "ADMIN") {
      drawerItems = _allItems;
    } else if (role == "DOCTOR") {
      drawerItems = [
        _item('Doctor Activity', '/activity', 'activity', 0),
        _item('Inpatient Discharge', '/discharge', 'discharge', 1),
        _item('Logout', '/logout', 'logout', 2),
      ];
    } else if (role == "PATIENT") {
      drawerItems = [_item('Logout', '/logout', 'logout', 0)];
    } else if (role == "DIAGNOSTIC_CENTER") {
      drawerItems = [
        _item('Test', '/test', 'test', 0),
        _item('Make Report', '/report', 'report', 0),
        _item('Logout', '/logout', 'logout', 1),
      ];
    } else if (role == "ACCOUNTANT") {
      drawerItems = [
        _item('Bill Status', '/status', 'status', 1),
        _item('Logout', '/logout', 'logout', 2),
      ];
    } else if (role == "RECEPTIONIST") {
      drawerItems = [
        _item('Bill Status', '/status', 'status', 0),
        _item('Logout', '/logout', 'logout', 1),
      ];
    } else {
      drawerItems = [_item('Logout', '/logout', 'logout', 0)];
    }
    notifyListeners();
  }

  DrawerItemModel _item(String title, String route, String icon, int index) {
    return DrawerItemModel(
      title: title,
      routeName: route,
      iconName: icon,
      index: index,
    );
  }

  final List<DrawerItemModel> _allItems = [
    DrawerItemModel(
      title: 'Doctor Activity',
      routeName: '/activity',
      index: 0,
      iconName: 'activity',
    ),
    DrawerItemModel(
      title: 'Test',
      routeName: '/test',
      index: 1,
      iconName: 'test',
    ),
    DrawerItemModel(
      title: 'Make Report',
      routeName: '/report',
      index: 2,
      iconName: 'report',
    ),
    DrawerItemModel(
      title: 'Bill Status',
      routeName: '/status',
      index: 3,
      iconName: 'status',
    ),
    DrawerItemModel(
      title: 'Inpatient Discharge',
      routeName: '/discharge',
      index: 4,
      iconName: 'discharge',
    ),
    DrawerItemModel(
      title: 'Logout',
      routeName: '/logout',
      index: 5,
      iconName: 'logout',
    ),
  ];

  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'activity':
        return Icons.insights;
      case 'test':
        return Icons.description;
      case 'report':
        return Icons.receipt_long;
      case 'status':
        return Icons.assignment;
      case 'discharge':
        return Icons.accessible;
      case 'logout':
        return Icons.logout;
      default:
        return Icons.circle;
    }
  }

  void selectItem(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  Future<void> logout(BuildContext context) async {
    await SharedPrefService.clear();
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginInputScreen()),
      (route) => false,
    );
  }

  Future<void> handleNavigation(
    BuildContext context,
    DrawerItemModel item,
  ) async {
    switch (item.iconName) {
      case 'activity':
        if (role == "DOCTOR") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ActivityScreen(role: role, nationalId: nationalId),
            ),
          );
        } else if (role == "ADMIN") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchDoctorActivityScreen(role: role),
            ),
          );
        }
        break;
      case 'test':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TestScreen(role: role)),
        );
        break;
      case 'report':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TestQueueScreen(role: role, patientId: nationalId)),
        );
        break;
      case 'status':
        Navigator.pushNamed(context, '/status');
        break;
      case 'discharge':
        Navigator.pushNamed(context, '/discharge');
        break;
      case 'logout':
        await logout(context);
        break;
    }
  }

  String get imageUrl {
    final img = currentUser?.imageUrl;
    if (img == null || img.isEmpty) return "";
    return img.startsWith("http") ? img : "http://10.0.2.2:9090$img";
  }

  String get userName => currentUser?.name ?? "Unknown User";

  String get email => currentUser?.email ?? "";

  String get nationalId => currentUser?.nationalId ?? "";

  String get role => currentUser?.roleValue ?? "";
}
