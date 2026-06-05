import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/bill_model.dart';
import '../model/report_model.dart';

class ReportService {
  final String baseUrl;

  ReportService({required this.baseUrl});

  Future<ReportModel> createReport(ReportModel model) async {
    final url = Uri.parse("$baseUrl/patient/create-report");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReportModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to create report: ${response.body}");
  }

  Future<List<ReportModel>> getAllReports() async {
    final response = await http.get(Uri.parse("$baseUrl/patient/all-report"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ReportModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load reports");
  }

  Future<ReportModel> getReportById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/report/$id"));
    if (response.statusCode == 200) {
      return ReportModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Report not found");
  }

  Future<List<BillModel>> getAllBills() async {
    final response = await http.get(Uri.parse("$baseUrl/all/bills"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => BillModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load bills");
  }

  Future<List<ReportModel>> getReportsByPatientId(String patientId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/patient/report/$patientId"),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ReportModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load reports");
  }

  Future<List<ReportModel>> getReportsByCenterName(String centerName) async {
    final response = await http.get(
      Uri.parse("$baseUrl/report/center/$centerName"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ReportModel.fromJson(e)).toList();
    }
    throw Exception("Failed to load reports");
  }

  Future<BillModel> getBillById(int billId) async {
    final response = await http.get(Uri.parse("$baseUrl/bills/$billId"));
    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Bill not found");
  }

  Future<void> updateReport({
    required int reportId,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse("$baseUrl/patient/update-report/$reportId");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update report: ${response.body}");
    }
  }
}
