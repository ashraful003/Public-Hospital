import 'package:flutter/material.dart';
import '../../model/user_model.dart';

class PharmacistDetailsViewModel extends ChangeNotifier {
  final UserModel pharmacist;

  PharmacistDetailsViewModel({required this.pharmacist});
}
