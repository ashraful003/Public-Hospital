import 'package:flutter/material.dart';
import 'package:public_hospital/model/doctor_assistant_model.dart';
class DoctorAssistantDetailsViewModel extends ChangeNotifier{
  final DoctorAssistantModel assistant;
  DoctorAssistantDetailsViewModel({required this.assistant});
}