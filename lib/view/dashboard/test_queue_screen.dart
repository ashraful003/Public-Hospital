import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/api_config.dart';
import '../../service/report_service.dart';
import '../../viewModel/dashboard/test_queue_view_model.dart';
import 'make_report_screen.dart';

class TestQueueScreen extends StatelessWidget {
  final String role;
  final String patientId;

  const TestQueueScreen({
    super.key,
    required this.role,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          TestQueueViewModel(service: ReportService(baseUrl: ApiConfig.baseUrl))
            ..loadBills(),
      child: _TestQueueBody(role: role, patientId: patientId),
    );
  }
}

class _TestQueueBody extends StatelessWidget {
  final String role;
  final String patientId;

  const _TestQueueBody({required this.role, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TestQueueViewModel>();
    return Scaffold(
      appBar: AppBar(),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: vm.searchByPatientId,
                    decoration: InputDecoration(
                      hintText: "Search by Patient ID",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  color: Colors.grey.shade300,
                  child: const Row(
                    children: [
                      _HeaderText("No"),
                      _HeaderText("Patient ID"),
                      _HeaderText("Date"),
                      _HeaderText("Bill Status"),
                      _HeaderText("Test Status"),
                    ],
                  ),
                ),
                Expanded(
                  child: vm.bills.isEmpty
                      ? const Center(child: Text("No Test Queue Found"))
                      : ListView.builder(
                          itemCount: vm.bills.length,
                          itemBuilder: (context, index) {
                            final bill = vm.bills[index];
                            final dateText = bill.createdDate != null
                                ? "${bill.createdDate!.day}/${bill.createdDate!.month}/${bill.createdDate!.year}"
                                : "-";
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MakeReportScreen(
                                      role: role,
                                      billId: bill.id.toInt(),
                                      patientId: bill.patientId,
                                    ),
                                  ),
                                );
                                if (context.mounted) {
                                  context
                                      .read<TestQueueViewModel>()
                                      .loadBills();
                                }
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                elevation: 2,
                                child: SizedBox(
                                  height: 55,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        _RowText(text: "${index + 1}"),
                                        _RowText(text: bill.patientId),
                                        _RowText(text: dateText),
                                        _RowText(
                                          text: bill.status,
                                          color: bill.status == "PAID"
                                              ? Colors.black54
                                              : Colors.orange,
                                        ),
                                        _RowText(
                                          text: bill.testStatus,
                                          color:
                                              bill.testStatus.toUpperCase() ==
                                                  "PENDING"
                                              ? Colors.blueGrey
                                              : bill.testStatus.toUpperCase() ==
                                                    "PROCESSING"
                                              ? Colors.blue
                                              : bill.testStatus.toUpperCase() ==
                                                    "FINAL"
                                              ? Colors.green
                                              : Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  final String text;
  final Color? color;

  const _RowText({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color),
      ),
    );
  }
}
