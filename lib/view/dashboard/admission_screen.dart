import 'package:flutter/material.dart';
import '../../data/shared_pref_service.dart';
import '../../utils/pref_keys.dart';
import '../login/login_input_screen.dart';

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
    _loadData();
  }

  void _loadData() {
    final savedEmail = SharedPrefService.getString(PrefKeys.rememberEmail);
    setState(() {
      email = savedEmail ?? "No Email Found";
    });
  }

  Future<void> _logout() async {
    await SharedPrefService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginInputScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admission"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
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
