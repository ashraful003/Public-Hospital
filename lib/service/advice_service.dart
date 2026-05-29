import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/advice_model.dart';
import 'api_config.dart';

class AdviceService {
  Future<List<AdviceModel>> getAdviceList(String nationalId) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/doctor/advice/$nationalId"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => AdviceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load advice");
    }
  }

  Future<void> addAdvice(AdviceModel advice) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/add-advice"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(advice.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add advice");
    }
  }

  Future<bool> deleteAdvice(String adviceId) async {
    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/delete-advice/$adviceId"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception("Failed to delete advice");
    }
  }

  Future<bool> updateAdvice({
    required String id,
    required AdviceModel advice,
  }) async {
    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/update-advice/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(advice.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to update advice");
    }
  }
}
