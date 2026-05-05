import 'package:flutter/material.dart';
import '../../model/user_model.dart';
class AccountantDetailsViewModel extends ChangeNotifier {
  final UserModel accountant;
  AccountantDetailsViewModel({required this.accountant});
}