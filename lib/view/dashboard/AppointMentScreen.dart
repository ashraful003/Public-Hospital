import 'package:flutter/material.dart';

import '../../color/AppColor.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue_200,
      appBar: AppBar(
        title: Text('Appointment Screen'),
          backgroundColor: AppColors.blue_200
      ),
    );
  }
}
