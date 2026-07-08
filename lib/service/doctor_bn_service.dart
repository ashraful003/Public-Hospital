import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/doctor_bn.dart';
import 'api_config.dart';

class DoctorBnService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<String> createDoctorBn(DoctorBn doctor) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/doctorBn-profile-create"),
        headers: const {"Content-Type": "application/json"},
        body: jsonEncode(doctor.toJson()),
      );
      if (response.statusCode == 200) {
        return response.body;
      }
      throw DoctorBnServiceException(
        response.body.isNotEmpty
            ? response.body
            : 'Failed to create doctor profile (Status ${response.statusCode})',
      );
    } catch (e) {
      throw DoctorBnServiceException(e.toString());
    }
  }

  Future<DoctorBn> getDoctorProfile(String doctorBnId) async {
    try {
      final url = Uri.parse('$baseUrl/doctorBn-profile-/doctor-id/$doctorBnId');
      final response = await http.get(
        url,
        headers: const {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return DoctorBn.fromJson(jsonDecode(response.body));
      }
      throw DoctorBnServiceException(
        'Failed to load doctor profile (Status ${response.statusCode})',
      );
    } catch (e) {
      throw DoctorBnServiceException(e.toString());
    }
  }

  Future<DoctorBn> getDoctorBnById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/doctorBn-profile/$id"));
    if (response.statusCode == 200) {
      return DoctorBn.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Doctor not found.");
    }
  }

  Future<String> updateDoctorBn(String id, DoctorBn doctor) async {
    final response = await http.put(
      Uri.parse("$baseUrl/doctorBn-profile-update/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(doctor.toJson()),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to update doctor profile.");
    }
  }
}

class DoctorBnServiceException implements Exception {
  final String message;
  const DoctorBnServiceException(this.message);
  @override
  String toString() => message;
}