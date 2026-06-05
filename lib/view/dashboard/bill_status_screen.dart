import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/view/dashboard/bill_history_screen.dart';
import 'package:public_hospital/view/dashboard/payment_screen.dart';
import '../../model/bill_model.dart';
import '../../service/api_config.dart';
import '../../service/bill_service.dart';
import '../../viewModel/dashboard/bill_status_view_model.dart';

class BillStatusScreen extends StatefulWidget {
  final String patientId;
  final String role;

  const BillStatusScreen({
    super.key,
    required this.patientId,
    required this.role,
  });

  @override
  State<BillStatusScreen> createState() => _BillStatusScreenState();
}

class _BillStatusScreenState extends State<BillStatusScreen> {
  late BillStatusViewModel vm;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        vm = BillStatusViewModel(
          billService: BillService(baseUrl: ApiConfig.baseUrl),
        );
        vm.refresh(widget.patientId, widget.role);
        return vm;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BillHistoryScreen(
                        patientId: widget.patientId,
                        role: widget.role,
                      ),
                    ),
                  ).then((_) {
                    vm.refresh(widget.patientId, widget.role);
                  });
                },
                child: const Text(
                  "History",
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Consumer<BillStatusViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error.isNotEmpty) {
              return Center(child: Text(vm.error));
            }
            if (vm.bills.isEmpty) {
              return const Center(child: Text("No bills found"));
            }
            return Column(
              children: [
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.grey.shade200,
                  child: const Row(
                    children: [
                      Expanded(flex: 1, child: Center(child: Text("No"))),
                      Expanded(flex: 3, child: Center(child: Text("Date"))),
                      Expanded(flex: 2, child: Center(child: Text("Due"))),
                      Expanded(flex: 2, child: Center(child: Text("Status"))),
                      Expanded(flex: 2, child: Center(child: Text("Action"))),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.bills.length,
                    itemBuilder: (context, index) {
                      final bill = vm.bills[index];
                      final status = (bill.status ?? "").toUpperCase();
                      Color color = status == "PAID"
                          ? Colors.green
                          : status == "PARTIAL"
                          ? Colors.orange
                          : Colors.red;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Center(child: Text("${index + 1}")),
                              ),
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text(
                                    bill.createdDate != null
                                        ? bill.createdDate!
                                              .toString()
                                              .split("T")
                                              .first
                                        : "-",
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    (bill.totalDue ?? 0).toStringAsFixed(2),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: TextButton(
                                    onPressed: () {
                                      final role = widget.role.toLowerCase();
                                      if (role == "admin" ||
                                          role == "accountant") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PaymentScreen(
                                              bill: bill,
                                              role: widget.role,
                                              patientId: widget.patientId,
                                            ),
                                          ),
                                        ).then((_) {
                                          vm.refresh(
                                            widget.patientId,
                                            widget.role,
                                          );
                                        });
                                      } else {
                                        showInvoiceDialog(context, bill);
                                      }
                                    },
                                    child: const Text("Next"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showInvoiceDialog(BuildContext context, BillModel bill) {
    List tests = [];
    try {
      final raw = bill.selectedTests;
      if (raw is String && raw.isNotEmpty) {
        tests = jsonDecode(raw);
      } else if (raw is List) {
        tests = raw as List<dynamic>;
      }
    } catch (e) {
      tests = [];
    }
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 700,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        color: Colors.blue,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "INVOICE",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Bill ID : ${bill.id ?? "-"}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Patient ID : ${bill.patientId ?? "-"}",
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Patient Name : ${bill.patientName ?? "-"}",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Age : ${bill.patientAge ?? "-"}"),
                          ),
                          Expanded(
                            child: Text(
                              "Weight : ${bill.patientWeight ?? "-"}",
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text("Referred By : ${bill.doctorName ?? "-"}"),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Received By : ${bill.accountantName}"),
                          ),
                          Expanded(
                            child: Text("Receiver ID : ${bill.accountantId}"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Selected Tests",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(),
                  if (tests.isEmpty)
                    const Text("No tests available")
                  else
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: const [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "No",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "Item Name",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Amount",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        ...List.generate(tests.length, (index) {
                          final item = tests[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Text("${index + 1}")),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    item["testName"]?.toString() ?? "",
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${item["price"] ?? 0}"),
                                      const SizedBox(width: 5),
                                      Text(
                                        item["currency"]?.toString() ?? "BDT",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  const Divider(),
                  Column(
                    children: [
                      _amountRow("Total Bill", bill.totalBill, Colors.black),
                      _amountRow(
                        "Discount",
                        bill.discountAmount,
                        Colors.orange,
                      ),
                      _amountRow("Paid", bill.totalPay, Colors.green),
                      const Divider(),
                      _amountRow(
                        "Due",
                        bill.totalDue,
                        bill.totalDue > 0 ? Colors.red : Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _amountRow(String title, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${amount.toStringAsFixed(2)} BDT",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
