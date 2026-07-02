import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../color/app_color.dart';
import '../../model/user_model.dart';
import '../../model/hospital_seat.dart';
import '../../viewModel/dashboard/admission_patient_view_model.dart';

class AdmissionPatientScreen extends StatelessWidget {
  final String role;

  const AdmissionPatientScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdmissionPatientViewModel()..init(),
      child: const _AdmissionPatientView(),
    );
  }
}

class _AdmissionPatientView extends StatefulWidget {
  const _AdmissionPatientView();

  @override
  State<_AdmissionPatientView> createState() => _AdmissionPatientViewState();
}

class _AdmissionPatientViewState extends State<_AdmissionPatientView> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdCtrl = TextEditingController();
  final _patientNameCtrl = TextEditingController();
  final _patientAgeCtrl = TextEditingController();
  final _patientWeightCtrl = TextEditingController();
  final _patientAddressCtrl = TextEditingController();
  final _diagnosisCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();
  DateTime? _admissionDateTime;
  DateTime? _expectedDischargeDateTime;

  @override
  void dispose() {
    _patientIdCtrl.dispose();
    _patientNameCtrl.dispose();
    _patientAgeCtrl.dispose();
    _patientWeightCtrl.dispose();
    _patientAddressCtrl.dispose();
    _diagnosisCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor_100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        title: const Text(
          'New Admission',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.4),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            const _AdmittedByCard(),
            const SizedBox(height: 20),
            _SectionTitle('Patient Information'),
            const SizedBox(height: 10),
            _TextField(
              controller: _patientIdCtrl,
              label: 'Patient ID',
              hint: 'e.g. PT-00123',
              required: true,
            ),
            _TextField(
              controller: _patientNameCtrl,
              label: 'Patient Name',
              hint: 'Full name',
              required: true,
            ),
            Row(
              children: [
                Expanded(
                  child: _TextField(
                    controller: _patientAgeCtrl,
                    label: 'Age',
                    hint: 'Years',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TextField(
                    controller: _patientWeightCtrl,
                    label: 'Weight (kg)',
                    hint: 'e.g. 62.5',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),
            _TextField(
              controller: _patientAddressCtrl,
              label: 'Address',
              hint: 'Patient address',
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            _SectionTitle('Medical Team'),
            const SizedBox(height: 10),
            const _DoctorPickerField(),
            const SizedBox(height: 8),
            _SectionTitle('Admission Details'),
            const SizedBox(height: 10),
            _TextField(
              controller: _diagnosisCtrl,
              label: 'Diagnosis',
              hint: 'Provisional diagnosis',
              maxLines: 2,
            ),
            _TextField(
              controller: _remarksCtrl,
              label: 'Remarks',
              hint: 'Any additional notes',
              maxLines: 2,
            ),
            Row(
              children: [
                Expanded(
                  child: _DateTimePickerField(
                    label: 'Admission Date',
                    value: _admissionDateTime,
                    onPick: (d) => setState(() => _admissionDateTime = d),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTimePickerField(
                    label: 'Exp. Discharge',
                    value: _expectedDischargeDateTime,
                    onPick: (d) =>
                        setState(() => _expectedDischargeDateTime = d),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _SectionTitle('Seat Assignment'),
            const SizedBox(height: 10),
            const _SeatTypePickerField(),
            const SizedBox(height: 12),
            const _SeatNoPickerField(),
            const SizedBox(height: 28),
            const _SubmitErrorBanner(),
            _SubmitButton(
              onValidate: () => _formKey.currentState?.validate() ?? false,
              patientId: _patientIdCtrl,
              patientName: _patientNameCtrl,
              patientAge: _patientAgeCtrl,
              patientWeight: _patientWeightCtrl,
              patientAddress: _patientAddressCtrl,
              diagnosis: _diagnosisCtrl,
              remarks: _remarksCtrl,
              admissionDate: () => _admissionDateTime,
              expectedDischargeDate: () => _expectedDischargeDateTime,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.blue_200,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _AdmittedByCard extends StatelessWidget {
  const _AdmittedByCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<AdmissionPatientViewModel>(
      builder: (_, vm, __) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.whiteColor_100),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.blue100,
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Admitted By',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.blue100,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (vm.isLoadingUser)
                      const Text(
                        'Loading current user...',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: AppColors.black100,
                        ),
                      )
                    else if (vm.userError != null)
                      Text(
                        vm.userError!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.red100,
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vm.currentUser?.name ?? 'Unknown user',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ID: ${vm.currentUser?.nationalId ?? '--'}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.blue100,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (vm.isLoadingUser)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryColor,
                  ),
                )
              else if (vm.userError != null)
                IconButton(
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: vm.loadCurrentUserProfile,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;

  const _TextField({
    required this.controller,
    required this.label,
    this.hint,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: AppColors.textColor),
        validator: required
            ? (v) =>
                  (v == null || v.trim().isEmpty) ? '$label is required' : null
            : null,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
          labelStyle: const TextStyle(fontSize: 13, color: AppColors.black100),
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.blue100),
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.whiteColor_100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.whiteColor_100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final bool required;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  const _PickerField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.required = false,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: enabled && !isLoading ? onTap : null,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: required ? '$label *' : label,
            labelStyle: const TextStyle(
              fontSize: 13,
              color: AppColors.black100,
            ),
            filled: true,
            fillColor: enabled
                ? AppColors.whiteColor
                : AppColors.whiteColor_100,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.whiteColor_100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.whiteColor_100),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value ?? placeholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: value == null
                        ? AppColors.blue100
                        : AppColors.textColor,
                    fontWeight: value == null
                        ? FontWeight.w400
                        : FontWeight.w600,
                  ),
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryColor,
                  ),
                )
              else
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: enabled ? AppColors.primaryColor : AppColors.blue100,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorPickerField extends StatelessWidget {
  const _DoctorPickerField();

  @override
  Widget build(BuildContext context) {
    return Consumer<AdmissionPatientViewModel>(
      builder: (_, vm, __) {
        return _PickerField(
          label: 'Doctor Name',
          value: vm.selectedDoctor?.name,
          placeholder: vm.isLoadingDoctors
              ? 'Loading doctors…'
              : (vm.doctorError != null
                    ? 'Failed to load doctors — tap to retry'
                    : 'Select a doctor'),
          required: true,
          isLoading: vm.isLoadingDoctors,
          onTap: () {
            if (vm.doctorError != null) {
              vm.loadDoctors();
              return;
            }
            _showDoctorDialog(context, vm);
          },
        );
      },
    );
  }

  void _showDoctorDialog(BuildContext context, AdmissionPatientViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _DoctorSearchDialog(
        doctors: vm.doctors,
        onSelected: (doctor) => vm.selectDoctor(doctor),
      ),
    );
  }
}

class _DoctorSearchDialog extends StatefulWidget {
  final List<UserModel> doctors;
  final ValueChanged<UserModel> onSelected;

  const _DoctorSearchDialog({required this.doctors, required this.onSelected});

  @override
  State<_DoctorSearchDialog> createState() => _DoctorSearchDialogState();
}

class _DoctorSearchDialogState extends State<_DoctorSearchDialog> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<UserModel> get _filtered {
    if (_query.trim().isEmpty) return widget.doctors;
    final q = _query.trim().toLowerCase();
    return widget.doctors
        .where((d) => (d.name ?? '').toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    return _CenteredDialogShell(
      title: 'Select Doctor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(fontSize: 14, color: AppColors.textColor),
              decoration: InputDecoration(
                hintText: 'Search doctor by name…',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: AppColors.blue100,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: AppColors.iconColor,
                        ),
                        onPressed: () => setState(() {
                          _searchCtrl.clear();
                          _query = '';
                        }),
                      ),
                filled: true,
                fillColor: AppColors.whiteColor_100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.whiteColor_100),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.whiteColor_100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.4,
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.whiteColor_100),
          Flexible(
            child: results.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text(
                        'No doctors found',
                        style: TextStyle(color: AppColors.blue100),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: AppColors.whiteColor_100,
                    ),
                    itemBuilder: (_, i) {
                      final doctor = results[i];
                      return ListTile(
                        title: Text(
                          doctor.name ?? 'Unnamed doctor',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        subtitle: Text(
                          doctor.specialist ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.blue100,
                          ),
                        ),
                        onTap: () {
                          widget.onSelected(doctor);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SeatTypePickerField extends StatelessWidget {
  const _SeatTypePickerField();

  @override
  Widget build(BuildContext context) {
    return Consumer<AdmissionPatientViewModel>(
      builder: (_, vm, __) {
        return _PickerField(
          label: 'Seat Type / Admission Type',
          value: vm.selectedSeatType,
          placeholder: vm.isLoadingSeatTypes
              ? 'Loading seat types…'
              : (vm.seatTypeError != null
                    ? 'Failed to load seat types — tap to retry'
                    : (vm.seatTypes.isEmpty
                          ? 'No seat types available'
                          : 'Select a seat type')),
          required: true,
          isLoading: vm.isLoadingSeatTypes,
          onTap: () {
            if (vm.seatTypeError != null) {
              vm.loadSeatTypes();
              return;
            }
            if (vm.seatTypes.isEmpty) return;
            _showSeatTypeDialog(context, vm);
          },
        );
      },
    );
  }

  void _showSeatTypeDialog(BuildContext context, AdmissionPatientViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PickerDialog<String>(
        title: 'Select Seat Type',
        items: vm.seatTypes,
        itemLabel: (t) => t,
        onSelected: (type) => vm.selectSeatType(type),
      ),
    );
  }
}

class _SeatNoPickerField extends StatelessWidget {
  const _SeatNoPickerField();

  @override
  Widget build(BuildContext context) {
    return Consumer<AdmissionPatientViewModel>(
      builder: (_, vm, __) {
        final typeChosen = vm.selectedSeatType != null;
        final display = vm.selectedSeat == null
            ? null
            : '${vm.selectedSeat!.seatNo}  ·  ${vm.selectedSeat!.currency} '
                  '${vm.selectedSeat!.price.toStringAsFixed(0)}';
        return _PickerField(
          label: 'Seat No.',
          value: display,
          placeholder: !typeChosen
              ? 'Select a seat type first'
              : (vm.availableSeats.isEmpty
                    ? 'No available seats of this type'
                    : 'Select a seat'),
          required: true,
          enabled: typeChosen,
          onTap: () {
            if (!typeChosen || vm.availableSeats.isEmpty) return;
            _showSeatDialog(context, vm);
          },
        );
      },
    );
  }

  void _showSeatDialog(BuildContext context, AdmissionPatientViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PickerDialog<HospitalSeat>(
        title: 'Select Seat (${vm.selectedSeatType})',
        items: vm.availableSeats,
        itemLabel: (s) => s.seatNo,
        itemSubtitle: (s) => '${s.currency} ${s.price.toStringAsFixed(0)}',
        onSelected: (seat) => vm.selectSeat(seat),
      ),
    );
  }
}

class _CenteredDialogShell extends StatelessWidget {
  final String title;
  final Widget child;

  const _CenteredDialogShell({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width < 480 ? screenSize.width * 0.92 : 420.0;
    final maxHeight = screenSize.height * 0.7;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: maxWidth,
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 10, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColors.iconColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(child: child),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _PickerDialog<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemLabel;
  final String Function(T)? itemSubtitle;
  final ValueChanged<T> onSelected;

  const _PickerDialog({
    required this.title,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    this.itemSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _CenteredDialogShell(
      title: title,
      child: items.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text(
                  'No items available',
                  style: TextStyle(color: AppColors.blue100),
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.whiteColor_100),
              itemBuilder: (_, i) {
                final item = items[i];
                return ListTile(
                  title: Text(
                    itemLabel(item),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  subtitle: itemSubtitle != null
                      ? Text(
                          itemSubtitle!(item),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.blue100,
                          ),
                        )
                      : null,
                  onTap: () {
                    onSelected(item);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
    );
  }
}

class _DateTimePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onPick;

  const _DateTimePickerField({
    required this.label,
    required this.value,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final display = value == null
        ? null
        : '${value!.day.toString().padLeft(2, '0')}/'
              '${value!.month.toString().padLeft(2, '0')}/'
              '${value!.year}  '
              '${_formatTime(value!)}';
    return _PickerField(
      label: label,
      value: display,
      placeholder: 'Select date & time',
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: Theme.of(
                ctx,
              ).colorScheme.copyWith(primary: AppColors.primaryColor),
            ),
            child: child!,
          ),
        );
        if (pickedDate == null) return;
        if (!context.mounted) return;
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: value != null
              ? TimeOfDay(hour: value!.hour, minute: value!.minute)
              : TimeOfDay.now(),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: Theme.of(
                ctx,
              ).colorScheme.copyWith(primary: AppColors.primaryColor),
            ),
            child: child!,
          ),
        );
        final combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime?.hour ?? 0,
          pickedTime?.minute ?? 0,
        );
        onPick(combined);
      },
    );
  }

  static String _formatTime(DateTime dt) {
    final hour24 = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return '$hour12:$minute $period';
  }
}

class _SubmitErrorBanner extends StatelessWidget {
  const _SubmitErrorBanner();

  @override
  Widget build(BuildContext context) {
    return Consumer<AdmissionPatientViewModel>(
      builder: (_, vm, __) {
        if (vm.submitError == null) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.red100.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.red100,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  vm.submitError!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.red100,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool Function() onValidate;
  final TextEditingController patientId;
  final TextEditingController patientName;
  final TextEditingController patientAge;
  final TextEditingController patientWeight;
  final TextEditingController patientAddress;
  final TextEditingController diagnosis;
  final TextEditingController remarks;
  final DateTime? Function() admissionDate;
  final DateTime? Function() expectedDischargeDate;

  const _SubmitButton({
    required this.onValidate,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientWeight,
    required this.patientAddress,
    required this.diagnosis,
    required this.remarks,
    required this.admissionDate,
    required this.expectedDischargeDate,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AdmissionPatientViewModel>(
      builder: (_, vm, __) {
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: vm.isSubmitting
                ? null
                : () async {
                    if (!onValidate()) return;
                    final ok = await vm.submitAdmission(
                      patientId: patientId.text,
                      patientName: patientName.text,
                      patientAge: int.tryParse(patientAge.text.trim()),
                      patientWeight: double.tryParse(patientWeight.text.trim()),
                      patientAddress: patientAddress.text,
                      diagnosis: diagnosis.text,
                      remarks: remarks.text,
                      admissionDate: admissionDate(),
                      expectedDischargeDate: expectedDischargeDate(),
                    );
                    if (!context.mounted) return;
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Patient admitted successfully'),
                          backgroundColor: AppColors.primaryColor,
                        ),
                      );
                      Navigator.of(context).pop(true);
                    } else if (vm.submitError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(vm.submitError!),
                          backgroundColor: AppColors.red100,
                        ),
                      );
                    }
                  },
            icon: vm.isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.whiteColor,
                    ),
                  )
                : const Icon(Icons.check_circle_outline_rounded),
            label: Text(vm.isSubmitting ? 'Submitting…' : 'Admit Patient'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.whiteColor,
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
