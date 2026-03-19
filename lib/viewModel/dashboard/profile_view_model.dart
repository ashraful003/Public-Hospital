import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_model.dart';
import '../../view/login/login_input_screen.dart';

class ProfileViewModel extends ChangeNotifier {
  bool showChangePassword = false;
  UserModel _user;
  File? _pickedImage;
  int selectedIndex = 2;

  ProfileViewModel({required UserModel user}) : _user = user;

  UserModel get user => _user;
  File? get pickedImage => _pickedImage;

  void changeTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }
  void toggleChangePassword() {
    showChangePassword = !showChangePassword;
    notifyListeners();
  }
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginInputScreen()),
          (route) => false,
    );
  }

  void updateUser({
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? dob,
    String? password,
    String? weight,
    String? imagePath,
    String? degree,
    String? institute,
    String? specialist,
    String? license,
  }) {
    _user = _user.copyWith(
      name: name,
      email: email,
      phone: phone,
      address: address,
      dob: dob,
      password: password,
      weight: weight,
      imageUrl: imagePath,
      degree: degree,
      institute: institute,
      specialist: specialist,
      license: license,
    );
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  List<String> get visibleFields {
    switch (_user.role) {
      case UserRole.doctor:
        return ['nationalId','name','email','phone','address','weight','dob','degree','institute','specialist','license','imageUrl'];
      case UserRole.nurse:
        return ['nationalId','name','email','phone','address','weight','dob','degree','institute','license','imageUrl'];
      case UserRole.patient:
        return ['nationalId','name','email','phone','address','weight','dob','degree','institute','imageUrl'];
      case UserRole.doctorAssistant:
        return ['nationalId','name','email','phone','address','weight','dob','degree','institute','imageUrl'];
      case UserRole.cleaner:
        return ['nationalId','name','email','phone','address','weight','dob','degree','institute','imageUrl'];
      default:
        return ['nationalId','name','email','phone','address','weight','dob','imageUrl'];
    }
  }

  bool isEditable(String field) {
    if (field == 'nationalId' || field == 'license') return false;
    return true;
  }

  String getFieldValue(String field) {
    switch (field) {
      case 'nationalId': return _user.nationalId ?? '';
      case 'name': return _user.name ?? '';
      case 'email': return _user.email ?? '';
      case 'phone': return _user.phone ?? '';
      case 'address': return _user.address ?? '';
      case 'weight': return _user.weight ?? '';
      case 'dob': return _user.dob != null ? "${_user.dob!.day}-${_user.dob!.month}-${_user.dob!.year}" : '';
      case 'degree': return _user.degree ?? '';
      case 'institute': return _user.institute ?? '';
      case 'specialist': return _user.specialist ?? '';
      case 'license': return _user.license ?? '';
      case 'imageUrl': return _user.imageUrl ?? '';
      default: return '';
    }
  }
}
