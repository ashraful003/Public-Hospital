import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/inpatient_bill.dart';
import 'api_config.dart';

class InpatientBillService {
  static final String baseUrl = ApiConfig.baseUrl;

  Future<List<InpatientBill>> getAllBills() async {
    final response = await http.get(Uri.parse('$baseUrl/inpatient-bill-all'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => InpatientBill.fromJson(json)).toList();
    }
    throw Exception('Failed to load bills (status ${response.statusCode})');
  }

  Future<InpatientBill> getBillById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/inpatient-bill/$id'));
    if (response.statusCode == 200) {
      return InpatientBill.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load bill $id (status ${response.statusCode})');
  }

  Future<List<InpatientBill>> getBillsByPatientId(dynamic patientId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inpatient-bill/patient/$patientId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => InpatientBill.fromJson(json)).toList();
    }
    throw Exception(
      'Failed to load bills for patient $patientId '
      '(status ${response.statusCode})',
    );
  }

  Future<InpatientBill> updateBill(
    int billId,
    InpatientBill updatedBill,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/inpatient-bill-update/$billId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedBill.toJson()),
    );
    if (response.statusCode == 200) {
      return InpatientBill.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }
}