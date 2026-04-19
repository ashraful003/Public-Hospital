import 'package:flutter/material.dart';
import '../../data/shared_pref_service.dart';

class AdmissionScreen extends StatefulWidget {
  final String role;

  const AdmissionScreen({super.key, required this.role});

  @override
  State<AdmissionScreen> createState() => _AdmissionScreenState();
}

class _AdmissionScreenState extends State<AdmissionScreen> {
  String? email;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  void _loadEmail() {
    final savedEmail = SharedPrefService.getString("remember_email");
    setState(() {
      email = savedEmail ?? "No Email Found";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admission")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "User Role: ${widget.role}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text("Email: $email", style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
