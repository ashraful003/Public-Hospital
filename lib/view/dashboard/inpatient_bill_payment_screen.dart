import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/inpatient_bill.dart';
import '../../viewModel/dashboard/inpatient_bill_payment_view_model.dart';

class _PaymentStyle {
  static InputDecoration fieldDecoration(
    BuildContext context, {
    String? prefixText,
    String? hintText,
  }) {
    final radius = BorderRadius.circular(10);
    final scheme = Theme.of(context).colorScheme;
    return InputDecoration(
      prefixText: prefixText,
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: radius),
      enabledBorder: OutlineInputBorder(borderRadius: radius),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      filled: true,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}

class InpatientBillPaymentScreen extends StatelessWidget {
  const InpatientBillPaymentScreen({super.key, required this.billId});

  final int billId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InpatientBillPaymentViewModel()..init(billId),
      child: _InpatientBillPaymentView(billId: billId),
    );
  }
}

class _InpatientBillPaymentView extends StatelessWidget {
  const _InpatientBillPaymentView({required this.billId});

  final int billId;

  Future<void> _handleSubmit(BuildContext context) async {
    final vm = context.read<InpatientBillPaymentViewModel>();
    final success = await vm.submitPayment();
    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment recorded successfully.'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 600));
      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.submitError ?? 'Failed to record payment.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InpatientBillPaymentViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Bill Payment')),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.loadError != null) {
            return _ErrorRetry(
              message: vm.loadError!,
              onRetry: () =>
                  context.read<InpatientBillPaymentViewModel>().init(billId),
            );
          }
          final bill = vm.bill;
          final user = vm.currentUser;
          if (bill == null || user == null) {
            return const Center(child: Text('No bill found.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BillSummaryCard(bill: bill),
                const SizedBox(height: 24),
                Text(
                  'Recorded by',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(user.name ?? '-'),
                const SizedBox(height: 4),
                Text(user.nationalId ?? '-'),
                const SizedBox(height: 24),
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: vm.paymentMethods.map((method) {
                    final selected = vm.paymentMethod == method;
                    return ChoiceChip(
                      label: Text(method),
                      selected: selected,
                      onSelected: (_) => context
                          .read<InpatientBillPaymentViewModel>()
                          .setPaymentMethod(method),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                _InfoRow(label: 'VAT (15%)', value: vm.vatAmount),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'Grand Total',
                  value: vm.grandTotal,
                  emphasize: true,
                ),
                const SizedBox(height: 24),
                Text('Discount', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextField(
                  controller: vm.discountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _PaymentStyle.fieldDecoration(
                    context,
                    prefixText: '\$ ',
                    hintText: 'Enter discount amount',
                  ),
                ),
                if (vm.hasDiscountInput) ...[
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Due', value: vm.currentDue, emphasize: true),
                ],
                const SizedBox(height: 24),
                Text(
                  'Total Pay',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: vm.totalPayController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _PaymentStyle.fieldDecoration(
                    context,
                    prefixText: '\$ ',
                    hintText: 'Max: ${vm.currentDue.toStringAsFixed(2)}',
                  ),
                ),
                if (vm.hasTotalPayInput) ...[
                  const SizedBox(height: 12),
                  if (vm.isUnderpaid)
                    _InfoRow(
                      label: 'Due After Payment',
                      value: vm.remainingDue,
                      valueColor: Theme.of(context).colorScheme.error,
                      emphasize: true,
                    )
                  else if (vm.isOverpaid)
                    _InfoRow(
                      label: 'Change',
                      value: vm.changeAmount,
                      valueColor: Color(0xFF2E7D32),
                      emphasize: true,
                    )
                  else
                    Text(
                      'Fully paid — no due, no change.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
                if (vm.submitError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    vm.submitError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  onPressed: vm.submitState == PaymentSubmitState.submitting
                      ? null
                      : () => _handleSubmit(context),
                  child: vm.submitState == PaymentSubmitState.submitting
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const Text('Submit Payment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BillSummaryCard extends StatelessWidget {
  const _BillSummaryCard({required this.bill});

  final InpatientBill bill;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Name : ${bill.patientName}'),
            const SizedBox(height: 4),
            Text('Patient ID : ${bill.patientId}'),
            const SizedBox(height: 4),
            Text('Seat : ${bill.seatNo}(${bill.seatType})'),
            const SizedBox(height: 4),
            _SummaryRow(label: 'Subtotal', value: bill.subtotal),
            _SummaryRow(label: 'Paid Amount', value: bill.paidAmount),
            _SummaryRow(
              label: 'Due Amount',
              value: bill.dueAmount,
              emphasize: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final double value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value.toStringAsFixed(2), style: style),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasize = false,
  });

  final String label;
  final double value;
  final Color? valueColor;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final baseStyle = emphasize
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: baseStyle),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: baseStyle?.copyWith(color: valueColor),
        ),
      ],
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
