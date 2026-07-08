import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/inpatient_bill.dart';
import '../../viewModel/dashboard/inpatient_bill_update_view_model.dart';

class _BillStyle {
  static InputDecoration fieldDecoration(
    BuildContext context, {
    required String label,
    String? helperText,
    String? prefixText,
    Widget? suffixIcon,
    bool readOnly = false,
  }) {
    final radius = BorderRadius.circular(10);
    final scheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      helperText: helperText,
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: radius),
      enabledBorder: OutlineInputBorder(borderRadius: radius),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      filled: true,
      fillColor: readOnly ? scheme.surfaceContainerHigh : scheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}

class InpatientBillUpdateScreen extends StatelessWidget {
  const InpatientBillUpdateScreen({super.key, required this.billId});

  final int billId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InpatientBillUpdateViewModel()..init(billId),
      child: _InpatientBillUpdateView(billId: billId),
    );
  }
}

class _InpatientBillUpdateView extends StatelessWidget {
  const _InpatientBillUpdateView({required this.billId});

  final int billId;

  Future<void> _handleSubmit(BuildContext context) async {
    final vm = context.read<InpatientBillUpdateViewModel>();
    final success = await vm.submitUpdate();
    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bill updated successfully.'),
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
          content: Text(vm.submitError ?? 'Failed to update bill.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InpatientBillUpdateViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Bill'),
        actions: [
          if (!vm.isLoading && vm.loadError == null && vm.bill != null)
            IconButton(
              tooltip: 'Reset changes',
              icon: const Icon(Icons.restore),
              onPressed: () => context
                  .read<InpatientBillUpdateViewModel>()
                  .resetToLoadedBill(),
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.loadError != null) {
            return _ErrorRetry(
              message: vm.loadError!,
              onRetry: () =>
                  context.read<InpatientBillUpdateViewModel>().init(billId),
            );
          }
          final bill = vm.bill;
          if (bill == null) {
            return const Center(child: Text('No bill found.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PatientHeaderCard(bill: bill),
                const SizedBox(height: 24),
                _ReadOnlyField(
                  label: 'Total Days',
                  value: '${vm.computedTotalDays}',
                ),
                const SizedBox(height: 24),
                _ReadOnlyField(
                  label: 'Bed Charge (per day)',
                  value: '\$${vm.bedRatePerDay.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 12),
                _ReadOnlyField(
                  label: 'Bed Charge (Total)',
                  value: '\$${vm.bedCharge.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 12),
                _NumberField(
                  label: 'Doctor Charge',
                  controller: vm.doctorChargeController,
                ),
                const SizedBox(height: 12),
                _NumberField(
                  label: 'Operation Charge',
                  controller: vm.operationChargeController,
                ),
                const SizedBox(height: 12),
                _NumberField(
                  label: 'Medicine Charge',
                  controller: vm.medicineChargeController,
                ),
                const SizedBox(height: 12),
                _NumberField(
                  label: 'Pathology Charge',
                  controller: vm.pathologyChargeController,
                ),
                const SizedBox(height: 12),
                _NumberField(
                  label: 'Radiology Charge',
                  controller: vm.radiologyChargeController,
                ),
                const SizedBox(height: 12),
                _NumberField(
                  label: 'Nursing Charge',
                  controller: vm.nursingChargeController,
                ),
                const SizedBox(height: 12),
                _NumberField(
                  label: 'Oxygen Charge',
                  controller: vm.oxygenChargeController,
                ),
                const SizedBox(height: 12),
                _NumberField(
                  label: 'Other Charge',
                  controller: vm.otherChargeController,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Preview',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(label: 'Subtotal', value: vm.computedSubtotal),
                        const SizedBox(height: 6),
                        _InfoRow(label: 'Discount', value: vm.discount),
                        const SizedBox(height: 6),
                        _InfoRow(label: 'VAT', value: vm.vat),
                        const SizedBox(height: 6),
                        _InfoRow(
                          label: 'Grand Total',
                          value: vm.computedGrandTotal,
                          emphasize: true,
                        ),
                        const SizedBox(height: 6),
                        _InfoRow(
                          label: 'Already Paid',
                          value: vm.existingPaidAmount,
                        ),
                        const SizedBox(height: 6),
                        _InfoRow(
                          label: 'Due Amount',
                          value: vm.computedDueAmount,
                          emphasize: true,
                          valueColor: vm.computedDueAmount > 0
                              ? Theme.of(context).colorScheme.error
                              : Color(0xFF2E7D32),
                        ),
                      ],
                    ),
                  ),
                ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: vm.submitState == BillUpdateSubmitState.submitting
                      ? null
                      : () => _handleSubmit(context),
                  child: vm.submitState == BillUpdateSubmitState.submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Changes'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PatientHeaderCard extends StatelessWidget {
  const _PatientHeaderCard({required this.bill});

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
            Text('Patient Id : ${bill.patientId}'),
            const SizedBox(height: 4),
            if (bill.doctorName != null)
              Text(
                'Doctor : ${bill.doctorName}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 4),
            if (bill.seatNo != null || bill.seatType != null)
              Text(
                'Seat : ${bill.seatNo ?? '-'} (${bill.seatType ?? '-'})',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 4),
            Text(
              'Bill Status : ${bill.billStatus}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Payment Status : ${bill.paymentStatus}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: _BillStyle.fieldDecoration(
        context,
        label: label,
        prefixText: '\$ ',
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.helperText,
    super.key,
  });

  final String label;
  final String value;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      enableInteractiveSelection: false,
      decoration: _BillStyle.fieldDecoration(
        context,
        label: label,
        helperText: helperText,
        readOnly: true,
        suffixIcon: const Icon(Icons.lock_outline, size: 18),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    this.value,
    this.value0,
    this.valueColor,
    this.emphasize = false,
  }) : assert(value != null || value0 != null);
  final String label;
  final double? value;
  final String? value0;
  final Color? valueColor;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final baseStyle = emphasize
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;
    final displayValue = value != null
        ? '\$${value!.toStringAsFixed(2)}'
        : value0!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: baseStyle),
        Text(displayValue, style: baseStyle?.copyWith(color: valueColor)),
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