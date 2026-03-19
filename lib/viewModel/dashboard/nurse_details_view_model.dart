import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
class NurseDetailsViewModel extends ChangeNotifier{
  final UserModel nurse;

  NurseDetailsViewModel({required this.nurse});
}