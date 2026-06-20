import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:public_hospital/service/api_config.dart';
import '../model/parking_model.dart';

class ParkingService {
  Future<void> createParking({
    required String floor,
    required String parkingNo,
    required double parkingFee,
    required bool isActive,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/create-parking'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "floor": floor,
        "parkingNo": parkingNo,
        "parkingFee": parkingFee,
        "isActive": isActive,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Failed to create parking');
    }
  }

  Future<List<ParkingModel>> getAllParking() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/parking/all'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> parkingList = jsonData['data'] ?? [];
      return parkingList.map((item) => ParkingModel.fromJson(item)).toList();
    } else {
      throw Exception(
        'Failed to load parking data. Status Code: ${response.statusCode}',
      );
    }
  }

  Future<void> updateParking(int id, ParkingModel model) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/update-parking/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "floor": model.floor,
        "parkingNo": model.parkingNo,
        "parkingFee": model.parkingFee,
        "isActive": model.isActive,
      }),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Update failed');
    }
  }

  Future<void> deleteParking(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/parking/delete/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete parking. Code: ${response.statusCode}');
    }
  }
}
