import 'package:flutter/material.dart';
import 'package:public_hospital/model/cleaner_model.dart';
class CleanerDetailsViewModel extends ChangeNotifier {
  final CleanerModel cleaner;
  CleanerDetailsViewModel({required this.cleaner});
}