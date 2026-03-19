import 'package:flutter/material.dart';

class BottomNavItemModel {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  BottomNavItemModel({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.textColor,
  });
}