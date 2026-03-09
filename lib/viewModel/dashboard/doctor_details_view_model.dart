import 'package:flutter/material.dart';
import '../../model/doctor_model.dart';

class DoctorDetailsViewModel extends ChangeNotifier {
  final DoctorModel doctor;

  DoctorDetailsViewModel({required this.doctor});
}