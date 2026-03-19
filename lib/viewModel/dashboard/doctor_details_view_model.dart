import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';

class DoctorDetailsViewModel extends ChangeNotifier {
  final UserModel doctor;

  DoctorDetailsViewModel({required this.doctor});
}