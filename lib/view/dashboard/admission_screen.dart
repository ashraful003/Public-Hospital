import 'package:flutter/material.dart';

class AdmissionScreen extends StatelessWidget {
  const AdmissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admission"),
      ),
      body: const Center(
        child: Text(
          "Admission Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}