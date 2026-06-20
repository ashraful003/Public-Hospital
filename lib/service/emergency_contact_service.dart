import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/emergency_contact.dart';
import 'api_config.dart';

class EmergencyContactService {
  static final String _baseUrl = ApiConfig.baseUrl;

  Future<String> createEmergencyContact({
    required String emergencyNumber,
    required String emergencyDoctorNumber,
    required String emergencyDoctorWhatsappNumber,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-contact'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "emergencyNumber": emergencyNumber,
        "emergencyDoctorNumber": emergencyDoctorNumber,
        "emergencyDoctorWhatsappNumber": emergencyDoctorWhatsappNumber,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return data['message'];
    }
    throw Exception(data['message'] ?? 'Create failed');
  }

  Future<List<EmergencyContact>> getAllEmergencyContacts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/contact/all'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => EmergencyContact.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load contacts. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching emergency contacts: $e');
    }
  }

  Future<String> updateEmergencyContact({
    required int id,
    required String emergencyNumber,
    required String emergencyDoctorNumber,
    required String emergencyDoctorWhatsappNumber,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/update-contact/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "emergencyNumber": emergencyNumber,
        "emergencyDoctorNumber": emergencyDoctorNumber,
        "emergencyDoctorWhatsappNumber": emergencyDoctorWhatsappNumber,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['message'];
    }
    throw Exception(data['message'] ?? 'Update failed');
  }

  Future<String> deleteEmergencyContact(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/contact/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['message'];
    }
    throw Exception(data['message'] ?? 'Delete failed');
  }
}
