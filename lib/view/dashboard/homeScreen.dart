import 'package:flutter/material.dart';
import 'package:public_hospital/color/AppColor.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue100,
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: AppColors.blue100,
      ),
    );
  }
}
