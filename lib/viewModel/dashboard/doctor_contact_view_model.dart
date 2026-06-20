import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/emergency_contact.dart';
import '../../service/emergency_contact_service.dart';

class DoctorContactViewModel extends ChangeNotifier {
  final EmergencyContactService _service = EmergencyContactService();
  EmergencyContact? contact;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> loadContact() async {
    try {
      isLoading = true;
      notifyListeners();
      final contacts = await _service.getAllEmergencyContacts();
      if (contacts.isNotEmpty) {
        contact = contacts.first;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> callDoctor() async {
    if (contact == null) return;
    final Uri uri = Uri(scheme: 'tel', path: contact!.emergencyDoctorNumber);
    await launchUrl(uri);
  }

  Future<void> openWhatsApp() async {
    if (contact == null) return;
    final String number = contact!.emergencyDoctorWhatsappNumber;
    final Uri uri = Uri.parse("https://wa.me/$number");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
