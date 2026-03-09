import 'package:flutter/material.dart';
import 'package:public_hospital/model/nurse_model.dart';
class NurseDetailsViewModel extends ChangeNotifier{
  final NurseModel nurse;

  NurseDetailsViewModel({required this.nurse});
}