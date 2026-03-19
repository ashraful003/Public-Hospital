import 'package:flutter/material.dart';
import 'package:public_hospital/model/user_model.dart';
class CleanerDetailsViewModel extends ChangeNotifier {
  final UserModel cleaner;
  CleanerDetailsViewModel({required this.cleaner});
}