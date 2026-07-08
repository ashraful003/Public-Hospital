import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:public_hospital/model/inpatient_bill.dart';
import '../../viewModel/dashboard/inpatient_bill_details_view_model.dart';
import 'inpatient_bill_payment_screen.dart';
import 'inpatient_bill_update_screen.dart';

class InpatientBillDetailsScreen extends StatelessWidget {
  final String role;
  final int billId;

  const InpatientBillDetailsScreen({
    super.key,
    required this.role,
    required this.billId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          InpatientBillDetailsViewModel(role: role, billId: billId)..loadBill(),
      child: const _InpatientBillDetailsView(),
    );
  }
}

class _InpatientBillDetailsView extends StatelessWidget {
  const _InpatientBillDetailsView();

  String _text(String? value) {
    if (value == null || value.trim().isEmpty) return 'N/A';
    return value;
  }

  String _intText(int? value) {
    if (value == null) return 'N/A';
    return value.toString();
  }

  String _dateText(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _canManageBilling(String role) {
    final r = role.trim().toLowerCase();
    return r == 'admin' || r == 'receptionist' || r == 'accountant';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InpatientBillDetailsViewModel>();
    final canManageBilling = _canManageBilling(vm.role);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Details'),
        actions: [
          if (canManageBilling)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InpatientBillUpdateScreen(billId: vm.bill!.id!),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: vm.refresh,
        child: _buildBody(context, vm, canManageBilling),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    InpatientBillDetailsViewModel vm,
    bool canManageBilling,
  ) {
    switch (vm.status) {
      case BillDetailsStatus.initial:
      case BillDetailsStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case BillDetailsStatus.error:
        return ListView(
          children: [
            const SizedBox(height: 100),
            Icon(Icons.error_outline, color: Colors.red[400], size: 48),
            const SizedBox(height: 12),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  vm.errorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: vm.loadBill,
                child: const Text('Retry'),
              ),
            ),
          ],
        );
      case BillDetailsStatus.loaded:
        final bill = vm.bill;
        if (bill == null) {
          return ListView(
            children: const [
              SizedBox(height: 120),
              Center(child: Text('Bill not found.')),
            ],
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionCard(
              title: 'Patient & Admission',
              children: [
                _InfoRow('Patient Name', _text(bill.patientName)),
                _InfoRow('Patient ID', bill.patientId.toString()),
                _InfoRow('Admission ID', bill.admissionId.toString()),
                _InfoRow('Doctor', _text(bill.doctorName)),
                _InfoRow('Seat Type', _text(bill.seatType)),
                _InfoRow('Seat No', _text(bill.seatNo)),
                _InfoRow('Total Days', _intText(bill.totalDays)),
                _InfoRow('Bill Date', _dateText(bill.billDate)),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Created & Payment Information',
              children: [
                _InfoRow('Created By Name', _text(bill.createdByName)),
                if (canManageBilling)
                  _InfoRow('Created By ID', _text(bill.createdById.toString())),
                _InfoRow('Paid By Name', _text(bill.paidByName)),
                if (canManageBilling)
                  _InfoRow('Paid By ID', _text(bill.paidById.toString())),
                _InfoRow('Payment Method', _text(bill.paymentMethod)),
                _InfoRow('Payment Date', _dateText(bill.paymentDate)),
              ],
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Bill Information',
              children: [
                _AmountRow('Bed Charge', bill.bedCharge),
                _AmountRow('Doctor Charge', bill.doctorCharge),
                _AmountRow('Operation Charge', bill.operationCharge),
                _AmountRow('Medicine Charge', bill.medicineCharge),
                _AmountRow('Pathology Charge', bill.pathologyCharge),
                _AmountRow('Radiology Charge', bill.radiologyCharge),
                _AmountRow('Nursing Charge', bill.nursingCharge),
                _AmountRow('Oxygen Charge', bill.oxygenCharge),
                _AmountRow('Other Charge', bill.otherCharge),
                const Divider(height: 28),
                _AmountRow('Subtotal', bill.subtotal),
                _AmountRow('VAT (15%)', bill.vat),
                _AmountRow('Grand Total', bill.grandTotal, bold: true),
                _AmountRow('Discount', bill.discount),
                _AmountRow('Paid Amount', bill.paidAmount),
                _AmountRow(
                  'Due Amount',
                  bill.dueAmount,
                  bold: true,
                  valueColor: bill.dueAmount > 0 ? Colors.red : Colors.green,
                ),
                const Divider(height: 28),
                _InfoRow('Payment Status', _text(bill.paymentStatus)),
              ],
            ),
            const SizedBox(height: 20),
            if (_canMakePayment(vm.role, bill))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.payments_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InpatientBillPaymentScreen(billId: bill.id!),
                        ),
                      );
                      if (result == true) {
                        await vm.loadBill();
                      }
                    },
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        );
    }
  }

  bool _canMakePayment(String role, InpatientBill bill) {
    final r = role.trim().toLowerCase();
    final hasPermission =
        r == 'admin' || r == 'accountant' || r == 'receptionist';
    return hasPermission &&
        bill.paymentStatus.toUpperCase() != 'PAID' &&
        bill.billStatus.toUpperCase() != 'CANCELLED';
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool bold;
  final Color? valueColor;

  const _AmountRow(
    this.label,
    this.amount, {
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            amount.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}