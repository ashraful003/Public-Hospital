import 'package:flutter/material.dart';
import 'package:public_hospital/model/CleanerModel.dart';
class CleanerDetailsViewModel extends ChangeNotifier {
  final CleanerModel cleaner;
  CleanerDetailsViewModel({required this.cleaner});
}