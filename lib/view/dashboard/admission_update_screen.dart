import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../model/user_model.dart';
import '../../viewModel/dashboard/admission_update_view_model.dart';

class AdmissionUpdateScreen extends StatelessWidget {
  final int admissionId;

  const AdmissionUpdateScreen({super.key, required this.admissionId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdmissionUpdateViewModel()..init(admissionId),
      child: const _AdmissionUpdateView(),
    );
  }
}

class _AdmissionUpdateView extends StatelessWidget {
  const _AdmissionUpdateView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdmissionUpdateViewModel>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor_100,
      appBar: _buildAppBar(),
      body: vm.isLoading
          ? const _LoadingState()
          : vm.admission == null
          ? _ErrorState(
              message: vm.errorMessage ?? 'Admission not found',
              onRetry: () => vm.init(vm.admissionId),
            )
          : _AdmissionForm(vm: vm),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
      elevation: 0,
      titleSpacing: 0,
      title: const Text(
        'Update Admission',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.blue_200),
      ),
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

class _AdmissionForm extends StatelessWidget {
  final AdmissionUpdateViewModel vm;

  const _AdmissionForm({required this.vm});

  @override
  Widget build(BuildContext context) {
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
              _PatientSection(vm: vm),
              const SizedBox(height: 16),
              _MedicalTeamSection(vm: vm),
              const SizedBox(height: 16),
              _AdmissionDetailsSection(vm: vm),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _SaveBar(vm: vm),
        ),
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

class _SaveBar extends StatelessWidget {
  final AdmissionUpdateViewModel vm;

  const _SaveBar({required this.vm});

  @override
  Widget build(BuildContext context) {
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
                  final success = await vm.submitUpdate();
                  if (!context.mounted) return;
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.blue_200,
                        content: Text('Admission updated successfully'),
                      ),
                    );
                    Navigator.of(context).pop(true);
                  }
                },
          icon: vm.isSubmitting
              ? const SizedBox.shrink()
              : const Icon(Icons.check_rounded, size: 20),
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
                  'Save Changes',
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

class _PatientSection extends StatelessWidget {
  final AdmissionUpdateViewModel vm;

  const _PatientSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    final a = vm.admission;
    if (a == null) return const SizedBox.shrink();
    return _SectionCard(
      icon: Icons.badge_outlined,
      title: 'Patient & Admission Information',
      subtitle: 'Read-only · loaded from record',
      children: [
        _ReadOnlyRow(label: 'Name', value: a.patientName),
        _ReadOnlyRow(label: 'Patient ID', value: a.patientId),
        _ReadOnlyRow(label: 'Age', value: a.patientAge?.toString()),
        _ReadOnlyRow(
          label: 'Weight',
          value: a.patientWeight != null ? '${a.patientWeight} kg' : null,
        ),
        _ReadOnlyRow(label: 'Seat Type', value: a.admissionType),
        _ReadOnlyRow(
          label: 'Seat Number',
          value: a.seatNo?.toString(),
          isLast: true,
        ),
        _ReadOnlyRow(label: 'Address', value: a.patientAddress),
      ],
    );
  }
}

class _MedicalTeamSection extends StatefulWidget {
  final AdmissionUpdateViewModel vm;

  const _MedicalTeamSection({required this.vm});

  @override
  State<_MedicalTeamSection> createState() => _MedicalTeamSectionState();
}

class _MedicalTeamSectionState extends State<_MedicalTeamSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.vm.loadDoctors();
    });
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;
    return _SectionCard(
      icon: Icons.medical_services_outlined,
      title: 'Medical Team',
      subtitle: 'Assign the responsible doctor',
      children: [
        _FieldLabel('Doctor Name'),
        const SizedBox(height: 6),
        if (vm.isLoadingDoctors)
          const _InlineLoading(label: 'Loading doctors…')
        else if (vm.doctors.isEmpty)
          const _EmptyHint('No doctors found in staff directory')
        else
          _DropdownShell(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UserModel>(
                isExpanded: true,
                value: vm.selectedDoctor,
                hint: Text(
                  'Select doctor',
                  style: TextStyle(
                    color: AppColors.iconColor.withValues(alpha: 0.65),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.iconColor.withValues(alpha: 0.65),
                ),
                items: vm.doctors
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primaryColor
                                  .withValues(alpha: 0.10),
                              child: Text(
                                _initials(d.name),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blue_200,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                d.specialist != null && d.specialist!.isNotEmpty
                                    ? '${d.name} · ${d.specialist}'
                                    : d.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: vm.selectDoctor,
              ),
            ),
          ),
        const SizedBox(height: 14),
        _FieldLabel('Doctor ID'),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.whiteColor_100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.iconColor.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 15,
                color: AppColors.iconColor.withValues(alpha: 0.65),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  vm.selectedDoctorIdentifier?.isNotEmpty == true
                      ? vm.selectedDoctorIdentifier!
                      : 'Auto-filled after selecting a doctor',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: vm.selectedDoctorIdentifier?.isNotEmpty == true
                        ? AppColors.textColor
                        : AppColors.iconColor.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdmissionDetailsSection extends StatelessWidget {
  final AdmissionUpdateViewModel vm;

  const _AdmissionDetailsSection({required this.vm});

  Future<void> _pickDischargeDate(BuildContext context) async {
    final now = DateTime.now();
    final existing = vm.expectedDischargeDate;
    final firstDate = (existing != null && existing.isBefore(now))
        ? existing
        : now;
    final initialDate = existing ?? now;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(
            ctx,
          ).colorScheme.copyWith(primary: AppColors.primaryColor),
        ),
        child: child!,
      ),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(existing ?? now),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(
            ctx,
          ).colorScheme.copyWith(primary: AppColors.primaryColor),
        ),
        child: child!,
      ),
    );
    if (time == null) return;
    vm.setExpectedDischargeDate(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final pm = dt.hour >= 12 ? 'PM' : 'AM';
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} · $h:$m $pm';
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.event_note_outlined,
      title: 'Admission Details',
      subtitle: 'Diagnosis, remarks and discharge planning',
      children: [
        _FieldLabel('Diagnosis'),
        const SizedBox(height: 6),
        _TextField(controller: vm.diagnosisController, maxLines: 2),
        const SizedBox(height: 14),
        _FieldLabel('Remarks'),
        const SizedBox(height: 6),
        _TextField(controller: vm.remarksController, maxLines: 2),
        const SizedBox(height: 14),
        _FieldLabel('Expected Discharge Date'),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _pickDischargeDate(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.iconColor.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    vm.expectedDischargeDate != null
                        ? _formatDateTime(vm.expectedDischargeDate!)
                        : 'Select date & time',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: vm.expectedDischargeDate != null
                          ? AppColors.textColor
                          : AppColors.iconColor.withValues(alpha: 0.65),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.iconColor.withValues(alpha: 0.65),
                ),
              ],
            ),
          ),
        ),
      ],
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