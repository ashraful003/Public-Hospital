import 'package:flutter/material.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prescription"),
      ),
      body: const Center(
        child: Text(
          "Prescription Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}