import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:public_hospital/service/api_config.dart';
import '../../model/appointment_schedule_model.dart';

class AppointmentScheduleService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<AppointmentSchedule> createAppointment({
    required String nationalId,
    required String day,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final uri = Uri.parse("$baseUrl/appointment-schedule_create");
    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nationalId": nationalId,
          "day": day,
          "date": date,
          "startTime": startTime,
          "endTime": endTime,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return AppointmentSchedule.fromJson(jsonDecode(response.body));
      } else {
        final String body = response.body;
        throw Exception(
          body.isNotEmpty
              ? body
              : "Failed to create appointment. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error creating appointment: $e");
    }
  }

  Future<List<AppointmentSchedule>> getAppointmentsByNationalId(
    String nationalId,
  ) async {
    final uri = Uri.parse(
      "$baseUrl/appointment-schedule/national-id/$nationalId",
    );
    try {
      final response = await http.get(
        uri,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AppointmentSchedule.fromJson(json)).toList();
      } else {
        throw Exception(
          "Failed to load appointments. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error fetching appointments: $e");
    }
  }

  Future<void> deleteAppointment(dynamic id) async {
    final uri = Uri.parse("$baseUrl/appointment-schedule-delete/$id");
    try {
      final response = await http.delete(
        uri,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          "Failed to delete appointment. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error deleting appointment: $e");
    }
  }

  Future<AppointmentSchedule> updateAppointment(
    dynamic id, {
    required String nationalId,
    required String day,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final uri = Uri.parse("$baseUrl/appointment-schedule-update/$id");
    try {
      final response = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nationalId": nationalId,
          "day": day,
          "date": date,
          "startTime": startTime,
          "endTime": endTime,
        }),
      );
      if (response.statusCode == 200) {
        return AppointmentSchedule.fromJson(jsonDecode(response.body));
      } else {
        final String body = response.body;
        throw Exception(
          body.isNotEmpty
              ? body
              : "Failed to update appointment. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error updating appointment: $e");
    }
  }
}
