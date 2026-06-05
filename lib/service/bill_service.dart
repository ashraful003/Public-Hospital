import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/bill_model.dart';

class BillService {
  final String baseUrl;

  BillService({required this.baseUrl});

  Future<List<BillModel>> getPatientBills(String patientId) async {
    final url = Uri.parse("$baseUrl/patient/bills/$patientId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => BillModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load bills");
    }
  }

  Future<dynamic> payBill({
    required int billId,
    required double payAmount,
    required double discountAmount,
    required String accountantName,
    required String accountantId,
  }) async {
    final url = Uri.parse("$baseUrl/bill/payment/$billId");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "totalPay": payAmount,
        "discountAmount": discountAmount,
        "accountantName": accountantName,
        "accountantId": accountantId,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Payment failed: ${response.body}");
    }
  }
}