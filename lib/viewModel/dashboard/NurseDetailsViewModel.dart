import 'package:flutter/material.dart';
import 'package:public_hospital/model/NurseModel.dart';
class NurseDetailsViewModel extends ChangeNotifier{
  final NurseModel nurse;

  NurseDetailsViewModel({required this.nurse});
}