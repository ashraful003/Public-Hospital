import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/hospital_seat.dart';
import 'api_config.dart';

class SeatService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, dynamic>> createSeat(Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl/seat-create");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    final decoded = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return decoded;
    }
    throw Exception(decoded["message"] ?? "Failed to create seat");
  }

  Future<List<HospitalSeat>> getAvailableSeatsByType(String type) async {
    try {
      final url = Uri.parse("$baseUrl/available/type/$type");
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => HospitalSeat.fromJson(e)).toList();
      }
      throw SeatServiceException("Failed to load available seats");
    } catch (e) {
      throw SeatServiceException(e.toString());
    }
  }

  Future<HospitalSeat> getSeatById(int id) async {
    final url = Uri.parse("$baseUrl/seat/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return HospitalSeat.fromJson(jsonDecode(response.body));
    }
    throw Exception("Seat not found: ${response.body}");
  }

  Future<HospitalSeat> updateSeat(int id, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl/seats/$id");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw Exception(
        "Update failed (${response.statusCode}): ${response.body}",
      );
    }
    return HospitalSeat.fromJson(jsonDecode(response.body));
  }
}

class SeatServiceException implements Exception {
  final String message;
  const SeatServiceException(this.message);

  @override
  String toString() => message;
}
