import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/hospital_admission.dart';
import 'api_config.dart';

class HospitalAdmissionService {
  static final String baseUrl = ApiConfig.baseUrl;

  Future<String> createAdmission(Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admission-create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final body = response.body.trim();
      if (body.startsWith('"') && body.endsWith('"') && body.length >= 2) {
        return body.substring(1, body.length - 1);
      }
      return body;
    }
    throw Exception(
      'Failed to create admission (status ${response.statusCode}): '
      '${response.body}',
    );
  }

  Future<List<HospitalAdmission>> getAllAdmissions() async {
    final response = await http.get(Uri.parse('$baseUrl/admission-all'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => HospitalAdmission.fromJson(json)).toList();
    }
    throw Exception(
      'Failed to load admissions (status ${response.statusCode})',
    );
  }

  Future<List<HospitalAdmission>> getAdmissionsByPatientId(
    String patientId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admission/patient/$patientId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => HospitalAdmission.fromJson(json)).toList();
    }
    throw Exception(
      'Failed to load admissions for patient $patientId '
      '(status ${response.statusCode})',
    );
  }

  Future<HospitalAdmission> getAdmissionById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/admission/$id'));
    if (response.statusCode == 200) {
      return HospitalAdmission.fromJson(jsonDecode(response.body));
    }
    throw Exception(
      'Failed to load admission $id (status ${response.statusCode})',
    );
  }

  Future<HospitalAdmission> updateAdmission(
    int id,
    Map<String, dynamic> requestBody,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admission-update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      return HospitalAdmission.fromJson(jsonDecode(response.body));
    }
    throw Exception(
      'Failed to update admission $id (status ${response.statusCode})',
    );
  }

  Future<HospitalAdmission> transferSeat(
    int id,
    Map<String, dynamic> requestBody,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admission-transfer/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      return HospitalAdmission.fromJson(jsonDecode(response.body));
    }
    throw Exception(
      'Failed to transfer admission $id (status ${response.statusCode})',
    );
  }

  Future<String> dischargePatient(
    int id,
    Map<String, dynamic> requestBody,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admission-discharge/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception(
      'Failed to discharge admission $id (status ${response.statusCode})',
    );
  }
}