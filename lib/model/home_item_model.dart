import 'package:flutter/cupertino.dart';

class HomeItemModel {
  final String title;
  final IconData icon;
  final Color bgColor;
  final String? type;

  HomeItemModel({
    required this.title,
    required this.icon,
    required this.bgColor,
    this.type,
  });
}
