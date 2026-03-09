import 'package:flutter/material.dart';
import 'package:public_hospital/model/DoctorAssistantModel.dart';
class DoctorAssistantDetailsViewModel extends ChangeNotifier{
  final DoctorAssistantModel assistant;
  DoctorAssistantDetailsViewModel({required this.assistant});
}