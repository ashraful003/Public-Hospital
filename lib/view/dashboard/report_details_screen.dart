import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/report_update_screen.dart';
import '../../service/api_config.dart';
import '../../service/report_service.dart';
import '../../viewModel/dashboard/report_details_view_model.dart';

class ReportDetailsScreen extends StatelessWidget {
  final int reportId;
  final String role;

  const ReportDetailsScreen({
    super.key,
    required this.reportId,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ReportDetailsViewModel(
              service: ReportService(baseUrl: ApiConfig.baseUrl),
            )
            ..setRole(role)
            ..loadReportById(reportId),
      child: const _ReportDetailsBody(),
    );
  }
}

class _ReportDetailsBody extends StatelessWidget {
  const _ReportDetailsBody();

  static const int testsPerPage = 15;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportDetailsViewModel>();
    if (vm.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (vm.report == null) {
      return const Scaffold(body: Center(child: Text("No Report Found")));
    }
    final totalPages = vm.tests.isEmpty
        ? 1
        : (vm.tests.length / testsPerPage).ceil();
    return Scaffold(
      appBar: AppBar(
        actions: vm.canEdit
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final report = vm.report;
                      if (report == null) return;
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportUpdateScreen(
                            reportId: report.id!,
                            billId: report.billId ?? 0,
                          ),
                        ),
                      );
                      if (result == true && context.mounted) {
                        await context
                            .read<ReportDetailsViewModel>()
                            .loadReportById(report.id!);
                      }
                    },
                  ),
                ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(totalPages, (pageIndex) {
            final start = pageIndex * testsPerPage;
            final end = (start + testsPerPage).clamp(0, vm.tests.length);
            final pageTests = vm.tests.sublist(start, end);
            return _ReportPage(
              report: vm.report!,
              tests: pageTests,
              pageNumber: pageIndex + 1,
              totalPages: totalPages,
            );
          }),
        ),
      ),
    );
  }
}

class _ReportPage extends StatelessWidget {
  final dynamic report;
  final List<dynamic> tests;
  final int pageNumber;
  final int totalPages;
  static const double _pageWidth = 794;
  static const double _pageMinHeight = 1123;

  const _ReportPage({
    required this.report,
    required this.tests,
    required this.pageNumber,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: _pageWidth,
        constraints: const BoxConstraints(minHeight: _pageMinHeight),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black26),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildPatientInfo(),
                const SizedBox(height: 12),
                _tableHeader(),
                ...List.generate(tests.length, (index) {
                  final test = tests[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Center(
                              child: Text(
                                test["testName"] ?? "-",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                test["result"] ?? "-",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                test["unit"] ?? "-",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                test["range"] ?? "-",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 30),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                "Page $pageNumber of $totalPages",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
      child: Column(
        children: [
          Text(
            report.centerName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            report.centerAddress,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _row("Patient ID", report.patientId),
                _row("Name", report.patientName),
                _row("Age", report.patientAge),
                _row("Weight", report.patientWeight),
                _row("Referred By.", report.doctorName),
              ],
            ),
          ),
          const SizedBox(width: 50),
          Expanded(
            child: Column(
              children: [
                _row("Lab No", report.labNo),
                _row("Sample Date", report.sampleDate),
                _row("Review Date", report.reviewDate),
                _row("Report Date", report.reportDate),
                _row("Status", report.testStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey.shade200,
      child: const Row(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                "Test Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                "Result",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "Unit",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                "Reference",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Text(": ", style: TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
