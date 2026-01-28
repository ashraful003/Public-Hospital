import 'package:flutter/material.dart';

import '../../color/AppColor.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.red100,
      appBar: AppBar(
        title: Text("Profile Screen"),
        backgroundColor: AppColors.red100,
      ),
    );
  }
}
