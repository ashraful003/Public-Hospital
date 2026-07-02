import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/hospital_admission.dart';
import '../../viewModel/dashboard/admission_discharge_view_model.dart';

class AdmissionDischargeScreen extends StatelessWidget {
  final int admissionId;

  const AdmissionDischargeScreen({super.key, required this.admissionId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AdmissionDischargeViewModel()
            ..loadAdmission(admissionId: admissionId),
      child: _AdmissionDischargeView(admissionId: admissionId),
    );
  }
}

class _AdmissionDischargeView extends StatelessWidget {
  final int admissionId;

  const _AdmissionDischargeView({required this.admissionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        title: const Text('Discharge Patient'),
      ),
      body: Consumer<AdmissionDischargeViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            );
          }
          if (vm.hasError) {
            return _ErrorView(
              message: vm.errorMessage,
              onRetry: () => vm.refresh(admissionId: admissionId),
            );
          }
          if (vm.admission == null) {
            return const Center(child: Text('Admission not found.'));
          }
          return _DischargeForm(vm: vm, admissionId: admissionId);
        },
      ),
    );
  }
}

class _DischargeForm extends StatelessWidget {
  final AdmissionDischargeViewModel vm;
  final int admissionId;

  const _DischargeForm({required this.vm, required this.admissionId});

  @override
  Widget build(BuildContext context) {
    final admission = vm.admission!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (vm.isAlreadyDischarged)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFA5D6A7)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This patient has already been discharged.',
                      style: TextStyle(color: Color(0xFF2E7D32)),
                    ),
                  ),
                ],
              ),
            ),
          _SummaryCard(admission: admission),
          const SizedBox(height: 16),
          _SectionLabel('Discharge Details'),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E9EE)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReadOnlyField(
                    label: 'Discharged By Name',
                    value: vm.dischargedByName,
                  ),
                  const SizedBox(height: 14),
                  _ReadOnlyField(
                    label: 'Discharged By ID',
                    value: vm.dischargedById?.toString() ?? '—',
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: vm.remarksController,
                    enabled: !vm.isAlreadyDischarged,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Remarks',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (vm.submitError.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              vm.submitError,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: vm.isAlreadyDischarged || vm.isSubmitting
                  ? null
                  : () async {
                      final success = await vm.submitDischarge(
                        admissionId: admissionId,
                      );
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Patient discharged successfully'),
                            backgroundColor: Color(0xFF2E7D32),
                          ),
                        );
                        Navigator.of(context).pop(true);
                      }
                    },
              icon: vm.isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.logout_rounded),
              label: Text(
                vm.isAlreadyDischarged
                    ? 'Already Discharged'
                    : vm.isSubmitting
                    ? 'Submitting...'
                    : 'Discharge Patient',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFCDD5DF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7A8D)),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E9EE)),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A2B3C),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final HospitalAdmission admission;

  const _SummaryCard({required this.admission});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E9EE)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Patient Name', admission.patientName),
            _row('Patient Name', admission.patientId),
            _row('Age', admission.patientAge.toString()),
            _row('Weight', admission.patientWeight.toString()),
            _row('Address', admission.patientAddress),
            _row('Doctor Name', admission.doctorName),
            _row('Diagnosis', admission.diagnosis),
            _row('Status', admission.status),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7A8D)),
            ),
          ),
          Expanded(
            child: Text(
              (value?.trim().isNotEmpty ?? false) ? value!.trim() : '—',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A2B3C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6B7A8D),
        letterSpacing: 0.6,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: Color(0xFFE57373),
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A2B3C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7A8D)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
