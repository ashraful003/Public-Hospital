import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/bill_model.dart';
import '../../service/api_config.dart';
import '../../service/bill_service.dart';
import '../../viewModel/dashboard/payment_view_model.dart';

class PaymentScreen extends StatefulWidget {
  final BillModel bill;
  final String role;
  final String patientId;

  const PaymentScreen({
    super.key,
    required this.bill,
    required this.role,
    required this.patientId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController payController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  double get _discount =>
      double.tryParse(discountController.text) ?? widget.bill.discountAmount;

  double get _paid => double.tryParse(payController.text) ?? 0;

  double get _netBill => widget.bill.totalBill - widget.bill.discountAmount;

  double get _due => _netBill - _discount - _paid;

  Widget _rightRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            width: 35,
            child: Text(
              "BDT",
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputRightRow(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(
            width: 35,
            child: Text(
              "BDT",
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('yyyy/MM/dd').format(DateTime.now());
    List tests = [];
    try {
      tests = widget.bill.selectedTests is String
          ? jsonDecode(widget.bill.selectedTests)
          : widget.bill.selectedTests;
    } catch (_) {
      tests = [];
    }
    return ChangeNotifierProvider(
      create: (_) =>
          PaymentViewModel(billService: BillService(baseUrl: ApiConfig.baseUrl))
            ..loadCurrentUser(widget.role),
      child: Consumer<PaymentViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Invoice Payment")),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "INVOICE",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Voucher No: ${widget.bill.id}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
                                        "Patient ID: ${widget.bill.patientId}",
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Patient Name: ${widget.bill.patientName}",
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Age: ${widget.bill.patientAge}",
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Weight: ${widget.bill.patientWeight}",
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Text("Referred By: ${widget.bill.doctorName}"),
                                const Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Receiver Name: ${vm.accountant?.name ?? "-"}",
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Receiver ID: ${vm.accountant?.nationalId ?? "-"}",
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Status: ${widget.bill.status}",
                                      ),
                                    ),
                                    Expanded(child: Text("Date: $date")),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        const Text(
                          "Test List",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: const [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "No",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Item Name",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "Amount",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "${index + 1}",
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        item["testName"]?.toString() ?? "",
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${item["price"] ?? 0}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            item["currency"]?.toString() ??
                                                "BDT",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
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
                        _rightRow(
                          "Total Bill",
                          widget.bill.totalBill.toStringAsFixed(1),
                        ),
                        _rightRow("Net Bill", _netBill.toStringAsFixed(2)),
                        _inputRightRow("Discount", discountController),
                        _inputRightRow("Pay Amount", payController),
                        const Divider(),
                        _rightRow("Paid", _paid.toStringAsFixed(2)),
                        _rightRow("Due", _due.toStringAsFixed(2)),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: vm.isLoading
                                ? null
                                : () async {
                                    final pay =
                                        double.tryParse(
                                          payController.text.trim(),
                                        ) ??
                                        0;
                                    final discount =
                                        double.tryParse(
                                          discountController.text.trim(),
                                        ) ??
                                        widget.bill.discountAmount;
                                    final result = await vm.payBill(
                                      bill: widget.bill,
                                      payAmount: pay,
                                      discountAmount: discount,
                                    );
                                    if (!mounted) return;
                                    if (result != null) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            result["message"] ??
                                                "Payment successful",
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Payment failed"),
                                        ),
                                      );
                                    }
                                  },
                            child: vm.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "PAY NOW",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
