import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:public_hospital/model/prescription_model.dart';
import '../data/shared_pref_service.dart';
import '../model/test_model.dart';
import '../model/user_model.dart';
import 'api_config.dart';

class PrescriptionService {
  Future<UserModel?> loadCurrentDoctor() async {
    try {
      final email = await SharedPrefService.getString("remember_email");
      if (email == null || email.isEmpty) {
        return null;
      }
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/profile?email=$email'),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> loadPatient(String nationalId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/$nationalId'),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> loadMedicineTypes(String nationalId) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/medicine_types/$nationalId"),
      );
      if (response.statusCode != 200) {
        return [];
      }
      final data = jsonDecode(response.body);
      if (data is! List) {
        return [];
      }
      return data
          .where((e) => e["medicineType"] != null)
          .map<String>((e) => e["medicineType"].toString())
          .toSet()
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> loadMedicines() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/all-medicine'),
      );
      if (response.statusCode != 200) {
        return [];
      }
      final data = jsonDecode(response.body);
      if (data is! List) {
        return [];
      }
      return data
          .where((e) => e["medicineName"] != null)
          .map<String>((e) => e["medicineName"].toString())
          .toSet()
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> loadDoses(String nationalId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/doses/$nationalId'),
      );
      if (response.statusCode != 200) {
        return [];
      }
      final data = jsonDecode(response.body);
      if (data is! List) {
        return [];
      }
      return data
          .where((e) => e["dose"] != null)
          .map<String>((e) => e["dose"].toString())
          .toSet()
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> loadDoseTimes(String nationalId) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/dose-time/$nationalId"),
      );
      if (response.statusCode != 200) {
        return [];
      }
      final data = jsonDecode(response.body);
      if (data is! List) {
        return [];
      }
      return data
          .where((e) => e["doseTime"] != null)
          .map<String>((e) => e["doseTime"].toString())
          .toSet()
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> loadDurations(String nationalId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/duration/$nationalId'),
      );
      if (response.statusCode != 200) {
        return [];
      }
      final data = jsonDecode(response.body);
      if (data is! List) {
        return [];
      }
      return data
          .where((e) => e["duration"] != null)
          .map<String>((e) => e["duration"].toString())
          .toSet()
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> loadTests() async {
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/all-test");
      final response = await http.get(url);
      if (response.statusCode != 200) {
        return [];
      }
      final List data = jsonDecode(response.body);
      final tests = data.map((e) => TestModel.fromJson(e)).toList();
      return tests
          .map((e) => e.testName)
          .where((e) => e.trim().isNotEmpty)
          .toSet()
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> loadNextMeet(String nationalId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/meet-time/$nationalId'),
      );
      if (response.statusCode != 200) {
        return [];
      }
      final data = jsonDecode(response.body);
      if (data is! List) {
        return [];
      }
      return data
          .where((e) => e["duration"] != null)
          .map<String>((e) => e["duration"].toString())
          .toSet()
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> loadAdvice(String nationalId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/doctor/advice/$nationalId'),
      );
      if (response.statusCode != 200) {
        return [];
      }
      final data = jsonDecode(response.body);
      if (data is! List) {
        return [];
      }
      return data
          .where((e) => e["advice"] != null)
          .map<String>((e) => e["advice"].toString())
          .toSet()
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> createPrescription(Map<String, dynamic> body) async {
    try {
      final token = await SharedPrefService.getToken();
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/patient/prescriptions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePrescriptionById(int id, Map<String, dynamic> body) async {
    try {
      final token = await SharedPrefService.getToken();
      final response = await http.put(
        Uri.parse("${ApiConfig.baseUrl}/patient/prescriptions/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<List<PrescriptionModel>> getPrescriptionsByPatient(
    String patientId,
  ) async {
    try {
      final token = await SharedPrefService.getToken();
      final response = await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/patient/prescriptions/patient/$patientId",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          final List<PrescriptionModel> prescriptions = [];
          for (var item in decoded) {
            try {
              prescriptions.add(PrescriptionModel.fromJson(item));
            } catch (e) {}
          }
          return prescriptions;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<PrescriptionModel> getPrescriptionById(int id) async {
    final token = await SharedPrefService.getToken();
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/patient/prescriptions/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return PrescriptionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load prescription");
    }
  }
}
