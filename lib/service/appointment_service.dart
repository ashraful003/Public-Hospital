import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/appointment_model.dart';
import '../model/user_model.dart';
import 'api_config.dart';

class AppointmentService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<UserModel>> getAllDoctors() async {
    final response = await http.get(Uri.parse("$baseUrl/all-doctor"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load doctors");
  }

  Future<List<AppointmentModel>> getDoctorSchedules(String nationalId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/appointment-schedule/national-id/$nationalId"),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => AppointmentModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load schedules");
  }

  Future<AppointmentModel> createAppointment(
    AppointmentModel appointment,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/createAppointment"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(appointment.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AppointmentModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to create appointment");
  }

  Future<List<AppointmentModel>> getAppointmentsByDoctor(
    String doctorId,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/getAppointmentsByDoctorId/$doctorId"),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => AppointmentModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load doctor appointments");
  }

  Future<List<AppointmentModel>> getAppointmentsByPatient(
    String patientId,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/getAppointmentsByPatientId/$patientId"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => AppointmentModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load patient appointments");
  }

  Future<Map<String, dynamic>> updateAppointmentStatus({
    required int appointmentId,
    required String status,
    String? reason,
  }) async {
    final uri = Uri.parse("$baseUrl/updateAppointmentStatus/$appointmentId")
        .replace(
          queryParameters: {
            "status": status,
            if (reason != null && reason.isNotEmpty) "reason": reason,
          },
        );
    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Failed to update appointment status");
  }
}
