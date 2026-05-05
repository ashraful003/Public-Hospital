import 'package:flutter/material.dart';
import '../../model/user_model.dart';

class DriverDetailsViewModel extends ChangeNotifier {
  final UserModel driver;

  DriverDetailsViewModel({required this.driver});
}
