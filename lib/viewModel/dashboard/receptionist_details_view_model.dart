import 'package:flutter/material.dart';
import '../../model/user_model.dart';

class ReceptionistDetailsViewModel extends ChangeNotifier {
  final UserModel receptionist;

  ReceptionistDetailsViewModel({required this.receptionist});
}
