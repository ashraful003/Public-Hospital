import 'package:flutter/material.dart';
import '../../model/user_model.dart';
class AmbulanceDetailsViewModel extends ChangeNotifier {
  final UserModel driver;
  AmbulanceDetailsViewModel({required this.driver});
}