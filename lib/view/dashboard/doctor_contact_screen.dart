import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModel/dashboard/doctor_contact_view_model.dart';

class DoctorContactScreen extends StatelessWidget {
  const DoctorContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DoctorContactViewModel()..loadContact(),
      child: const _DoctorContactView(),
    );
  }
}

class _DoctorContactView extends StatelessWidget {
  const _DoctorContactView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Doctor Contact"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DoctorContactViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.contact == null) {
            return const Center(child: Text("No Doctor Contact Found"));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: _ContactCard(
                  title: "Chat with our Medical Officer",
                  subtitle: "24 / 7 Availability",
                  icon: Image.asset(
                    'assets/icons/whatsapp.png',
                    width: 56,
                    height: 56,
                    errorBuilder: (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFF25D366),
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      child: const Icon(
                        Icons.chat,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  onTap: vm.openWhatsApp,
                ),
              ),
              const SizedBox(height: 8),
              _ContactCard(
                title: "For 24 Hours Emergency",
                subtitle: "Tap here to call now",
                icon: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF34C759),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  child: const Icon(Icons.call, color: Colors.white, size: 30),
                ),
                onTap: vm.callDoctor,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final VoidCallback onTap;

  const _ContactCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: const Color(0xFFEEEEEE),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                icon,
                const SizedBox(width: 16),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}