import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../model/hospital_seat.dart';
import '../../viewModel/dashboard/admission_transfer_view_model.dart';

class AdmissionTransferScreen extends StatelessWidget {
  final int admissionId;

  const AdmissionTransferScreen({super.key, required this.admissionId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdmissionTransferViewModel()..init(admissionId),
      child: const _AdmissionTransferView(),
    );
  }
}

class _AdmissionTransferView extends StatelessWidget {
  const _AdmissionTransferView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdmissionTransferViewModel>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor_100,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        titleSpacing: 0,
        title: const Text(
          'Transfer Patient',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.blue_200),
        ),
      ),
      body: vm.isLoading
          ? const _LoadingState()
          : vm.admission == null
          ? _ErrorState(
              message: vm.errorMessage ?? 'Admission not found',
              onRetry: () => vm.init(vm.admissionId),
            )
          : const _TransferForm(),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryColor),
          const SizedBox(height: 16),
          Text(
            'Loading admission…',
            style: TextStyle(
              color: AppColors.iconColor.withValues(alpha: 0.65),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.red100.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.red100,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textColor, fontSize: 14),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: const BorderSide(color: AppColors.primaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransferForm extends StatelessWidget {
  const _TransferForm();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdmissionTransferViewModel>();
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vm.errorMessage != null) ...[
                _ErrorBanner(message: vm.errorMessage!),
                const SizedBox(height: 16),
              ],
              const _CurrentSeatSection(),
              const SizedBox(height: 16),
              const _SeatSelectionSection(),
              const SizedBox(height: 16),
              const _RemarksSection(),
            ],
          ),
        ),
        const Align(alignment: Alignment.bottomCenter, child: _SaveBar()),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.red100.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.red100.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.red100,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.red100, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentSeatSection extends StatelessWidget {
  const _CurrentSeatSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdmissionTransferViewModel>();
    final a = vm.admission;
    if (a == null) return const SizedBox.shrink();
    return _SectionCard(
      icon: Icons.bed_outlined,
      title: 'Current Placement',
      subtitle: 'Read-only · loaded from record',
      children: [
        _ReadOnlyRow(label: 'Patient Name', value: a.patientName),
        _ReadOnlyRow(label: 'Patient Id', value: a.patientId),
        _ReadOnlyRow(label: 'Patient Age', value: a!.patientAge.toString()),
        _ReadOnlyRow(
          label: 'Patient Weight',
          value: a!.patientWeight.toString(),
        ),
        _ReadOnlyRow(label: 'Seat Type', value: a.admissionType),
        _ReadOnlyRow(label: 'Seat No', value: a.seatNo, isLast: true),
      ],
    );
  }
}

class _SeatSelectionSection extends StatelessWidget {
  const _SeatSelectionSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdmissionTransferViewModel>();
    return _SectionCard(
      icon: Icons.swap_horiz_rounded,
      title: 'New Seat',
      subtitle: 'Select a seat type, then an available seat',
      children: [
        _FieldLabel('Seat Type'),
        const SizedBox(height: 6),
        if (vm.isLoadingSeatTypes)
          const _InlineLoading(label: 'Loading seat types…')
        else if (vm.admissionType.isEmpty)
          const _EmptyHint('No seat types found')
        else
          _DropdownShell(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: vm.selectedSeatType,
                hint: Text(
                  'Select seat type',
                  style: TextStyle(
                    color: AppColors.iconColor.withValues(alpha: 0.65),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.iconColor.withValues(alpha: 0.65),
                ),
                items: vm.admissionType
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: vm.selectSeatType,
              ),
            ),
          ),
        const SizedBox(height: 14),
        _FieldLabel('Seat Number'),
        const SizedBox(height: 6),
        if (vm.isLoadingAvailableSeats)
          const _InlineLoading(label: 'Loading available seats…')
        else if (!vm.isSeatNumberEnabled)
          const _DisabledSeatNumberShell()
        else if (vm.availableSeats.isEmpty)
          const _EmptyHint('No available seats for this type')
        else
          _DropdownShell(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<HospitalSeat>(
                isExpanded: true,
                value: vm.selectedSeat,
                hint: Text(
                  'Select seat number',
                  style: TextStyle(
                    color: AppColors.iconColor.withValues(alpha: 0.65),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.iconColor.withValues(alpha: 0.65),
                ),
                items: vm.availableSeats
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.seatNo ?? ''),
                      ),
                    )
                    .toList(),
                onChanged: vm.selectSeat,
              ),
            ),
          ),
      ],
    );
  }
}

class _DisabledSeatNumberShell extends StatelessWidget {
  const _DisabledSeatNumberShell();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.whiteColor_100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.iconColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 15,
            color: AppColors.iconColor.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Select a seat type first',
              style: TextStyle(
                fontSize: 13.5,
                color: AppColors.iconColor.withValues(alpha: 0.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RemarksSection extends StatelessWidget {
  const _RemarksSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdmissionTransferViewModel>();
    return _SectionCard(
      icon: Icons.notes_outlined,
      title: 'Remarks',
      subtitle: 'Optional note for this transfer',
      children: [_TextField(controller: vm.remarksController, maxLines: 3)],
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdmissionTransferViewModel>();
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.iconColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: vm.isSubmitting
              ? null
              : () async {
                  final success = await vm.submitTransfer();
                  if (!context.mounted) return;
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.blue_200,
                        content: Text('Patient transferred successfully'),
                      ),
                    );
                    Navigator.of(context).pop(true);
                  }
                },
          icon: vm.isSubmitting
              ? const SizedBox.shrink()
              : const Icon(Icons.swap_horiz_rounded, size: 20),
          label: vm.isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: AppColors.whiteColor,
                  ),
                )
              : const Text(
                  'Transfer Patient',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
            disabledBackgroundColor: AppColors.primaryColor.withValues(
              alpha: 0.6,
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const _SectionCard({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.iconColor.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.iconColor.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 18, color: AppColors.blue_200),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.iconColor.withValues(alpha: 0.65),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool isLast;

  const _ReadOnlyRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.iconColor.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.iconColor.withValues(alpha: 0.65),
                fontSize: 12.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              (value == null || value!.isEmpty) ? '—' : value!,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: AppColors.iconColor.withValues(alpha: 0.65),
        letterSpacing: 0.2,
      ),
    );
  }
}

class _DropdownShell extends StatelessWidget {
  final Widget child;

  const _DropdownShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.iconColor.withValues(alpha: 0.12)),
      ),
      child: child,
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLines;

  const _TextField({required this.controller, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13.5, color: AppColors.textColor),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.whiteColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.iconColor.withValues(alpha: 0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.iconColor.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _InlineLoading extends StatelessWidget {
  final String label;

  const _InlineLoading({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.iconColor.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;

  const _EmptyHint(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor_100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.iconColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 15,
            color: AppColors.iconColor.withValues(alpha: 0.65),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.iconColor.withValues(alpha: 0.65),
              ),
            ),
          ),
        ],
      ),
    );
  }
}