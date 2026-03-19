import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
class DoctorAssistantDetailsViewModel extends ChangeNotifier{
  final UserModel assistant;
  DoctorAssistantDetailsViewModel({required this.assistant});
}