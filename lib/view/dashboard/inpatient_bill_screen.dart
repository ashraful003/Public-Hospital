import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/inpatient_bill.dart';
import '../../viewModel/dashboard/inpatient_bill_view_model.dart';
import 'inpatient_bill_details_screen.dart';

class InpatientBillScreen extends StatelessWidget {
  final String role;
  final String patientId;

  const InpatientBillScreen({
    super.key,
    required this.role,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          InpatientBillViewModel(role: role, patientId: patientId)..loadBills(),
      child: const _InpatientBillView(),
    );
  }
}

class _InpatientBillView extends StatelessWidget {
  const _InpatientBillView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InpatientBillViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          vm.canViewAllBills ? 'All Inpatient Bills' : 'My Inpatient Bills',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: vm.loadBills,
        child: Column(
          children: [
            if (vm.canViewAllBills)
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search bills...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: vm.searchBills,
                ),
              ),
            Expanded(child: _buildBody(vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(InpatientBillViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        const _BillHeader(),
        Expanded(
          child: vm.filteredBills.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 120),
                    Center(
                      child: Text(
                        'No inpatient bills found.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: vm.filteredBills.length,
                  itemBuilder: (_, index) {
                    return _BillCard(
                      serial: index + 1,
                      bill: vm.filteredBills[index],
                      role: vm.role,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _BillHeader extends StatelessWidget {
  const _BillHeader();

  Widget item(String title, int flex, {TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: align,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          item("No", 1),
          item("Date", 2),
          item("Patient", 3),
          item("Patient ID", 2),
          item("Seat Type", 2),
          item("Seat No", 2),
          item("Status", 2, align: TextAlign.center),
        ],
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final InpatientBill bill;
  final int serial;
  final String role;

  const _BillCard({
    required this.bill,
    required this.serial,
    required this.role,
  });

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return Colors.green;
      case 'PARTIAL':
        return Colors.orange;
      case 'UNPAID':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget item(Widget child, int flex, {TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 13, color: Colors.black87),
        child: Align(
          alignment: align == TextAlign.right
              ? Alignment.centerRight
              : align == TextAlign.center
              ? Alignment.center
              : Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(bill.paymentStatus);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Card(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: bill.id == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InpatientBillDetailsScreen(
                        role: role,
                        billId: bill.id!,
                      ),
                    ),
                  );
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                item(Text(serial.toString()), 1),
                item(
                  Text(
                    bill.billDate == null
                        ? "-"
                        : "${bill.billDate!.day}/${bill.billDate!.month}/${bill.billDate!.year}",
                  ),
                  2,
                ),
                item(
                  Text(bill.patientName, overflow: TextOverflow.ellipsis),
                  3,
                ),
                item(
                  Text(
                    bill.patientId.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  2,
                ),
                item(
                  Text(
                    bill.seatType?.isNotEmpty == true ? bill.seatType! : "-",
                    overflow: TextOverflow.ellipsis,
                  ),
                  2,
                ),
                item(
                  Text(
                    bill.seatNo?.isNotEmpty == true ? bill.seatNo! : "-",
                    overflow: TextOverflow.ellipsis,
                  ),
                  2,
                ),
                item(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      bill.paymentStatus,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  2,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}