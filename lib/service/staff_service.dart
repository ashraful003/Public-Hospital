import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import 'api_config.dart';

class StaffService {
  final url = ApiConfig.baseUrl;

  Future<List<UserModel>> fetchAllDoctors() async {
    final response = await http.get(
      Uri.parse("$url/all-doctor"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load doctors");
    }
  }

  Future<List<UserModel>> fetchActiveDoctors() async {
    final response = await http.get(
      Uri.parse("$url/active-doctor"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load active doctors");
    }
  }

  Future<List<UserModel>> fetchAllDoctorAssistant() async {
    final response = await http.get(
      Uri.parse("$url/all-assistant"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load doctors");
    }
  }

  Future<List<UserModel>> fetchActiveDoctorAssistant() async {
    final response = await http.get(
      Uri.parse("$url/active-assistant"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load active assistants");
    }
  }

  Future<List<UserModel>> fetchAllNurses() async {
    final response = await http.get(
      Uri.parse("$url/all-nurses"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load nurses");
    }
  }

  Future<List<UserModel>> fetchActiveNurses() async {
    final response = await http.get(
      Uri.parse("$url/active-nurses"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load active nurses");
    }
  }

  Future<List<UserModel>> fetchAllAccountants() async {
    final response = await http.get(
      Uri.parse("$url/all-accountants"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load nurses");
    }
  }

  Future<List<UserModel>> fetchActiveAccountants() async {
    final response = await http.get(
      Uri.parse("$url/active-accountants"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load active nurses");
    }
  }

  Future<List<UserModel>> fetchAllPharmacists() async {
    final response = await http.get(
      Uri.parse("$url/all-pharmacists"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load pharmacist");
    }
  }

  Future<List<UserModel>> fetchActivePharmacists() async {
    final response = await http.get(
      Uri.parse("$url/active-pharmacists"),
      headers: {"Content-Type": "application.json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load active pharmacists");
    }
  }

  Future<List<UserModel>> fetchAllReceptionists() async {
    final response = await http.get(
      Uri.parse("$url/all-receptionists"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load receptionists");
    }
  }

  Future<List<UserModel>> fetchActiveReceptionists() async {
    final response = await http.get(
      Uri.parse("$url/active-receptionists"),
      headers: {"Content-Type": "application.json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load active receptionists");
    }
  }

  Future<List<UserModel>> fetchAllDrivers() async {
    final response = await http.get(
      Uri.parse("$url/all-drivers"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load drivers");
    }
  }

  Future<List<UserModel>> fetchActiveDrivers() async {
    final response = await http.get(
      Uri.parse("$url/active-drivers"),
      headers: {"Content-Type": "application.json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load active drivers");
    }
  }

  Future<List<UserModel>> fetchAllCleaners() async {
    final response = await http.get(
      Uri.parse("$url/all-cleaners"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load cleaners");
    }
  }

  Future<List<UserModel>> fetchActiveCleaners() async {
    final response = await http.get(
      Uri.parse("$url/active-cleaners"),
      headers: {"Content-Type": "application.json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load active cleaners");
    }
  }
}
