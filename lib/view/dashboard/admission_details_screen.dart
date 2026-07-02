import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/hospital_admission.dart';
import '../../viewModel/dashboard/admission_details_view_model.dart';
import 'admission_discharge_screen.dart';
import 'admission_transfer_screen.dart';
import 'admission_update_screen.dart';

class AdmissionDetailsScreen extends StatelessWidget {
  final String role;
  final String? patientId;
  final int admissionId;

  const AdmissionDetailsScreen({
    super.key,
    required this.role,
    required this.admissionId,
    this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AdmissionDetailsViewModel()..loadAdmission(admissionId: admissionId),
      child: _AdmissionDetailsView(
        role: role,
        patientId: patientId,
        admissionId: admissionId,
      ),
    );
  }
}

class _AdmissionDetailsView extends StatelessWidget {
  final String role;
  final String? patientId;
  final int admissionId;

  const _AdmissionDetailsView({
    required this.role,
    required this.admissionId,
    this.patientId,
  });

  bool get _isPrivileged {
    final r = role.trim().toLowerCase();
    return r == 'admin' || r == 'receptionist';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Consumer<AdmissionDetailsViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) return const _LoadingView();
          if (vm.hasError) {
            return _ErrorView(
              message: vm.errorMessage,
              onRetry: () => vm.refresh(admissionId: admissionId),
            );
          }
          if (vm.admission == null) {
            return const _ErrorView(
              message: 'Admission not found.',
              onRetry: null,
            );
          }
          return _DetailsScrollView(
            admission: vm.admission!,
            isPrivileged: _isPrivileged,
            admissionId: admissionId,
            isLoading: vm.isLoading,
          );
        },
      ),
    );
  }
}

class _DetailsScrollView extends StatelessWidget {
  final HospitalAdmission admission;
  final bool isPrivileged;
  final int admissionId;
  final bool isLoading;

  const _DetailsScrollView({
    required this.admission,
    required this.isPrivileged,
    required this.admissionId,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF1A6B8A),
      onRefresh: () => context.read<AdmissionDetailsViewModel>().refresh(
        admissionId: admissionId,
      ),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _PatientAppBar(admission: admission, isLoading: isLoading),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _Section(
                  title: 'Patient Information',
                  icon: Icons.person_outline_rounded,
                  rows: [
                    _Detail('Name', admission.patientName),
                    _Detail('ID', admission.patientId),
                    _Detail('Age', admission.patientAge?.toString()),
                    _Detail(
                      'Weight',
                      admission.patientWeight != null
                          ? '${admission.patientWeight} kg'
                          : null,
                    ),
                    _Detail('Address', admission.patientAddress),
                  ],
                ),
                const SizedBox(height: 16),
                _Section(
                  title: 'Admission Info',
                  icon: Icons.assignment_outlined,
                  rows: [
                    _Detail('Seat Type', admission.admissionType),
                    _Detail('Seat No', admission.seatNo?.toString()),
                    _Detail('Diagnosis', admission.diagnosis),
                    _Detail('Remarks', admission.remarks),
                    _Detail('Status', admission.status),
                  ],
                ),
                const SizedBox(height: 16),
                _Section(
                  title: 'Medical Team',
                  icon: Icons.local_hospital_outlined,
                  rows: [
                    _Detail('Doctor', admission.doctorName),
                    if (isPrivileged && admission.doctorId != null)
                      _Detail('Doctor ID', admission.doctorId!.toString()),
                    _Detail('Admitted By', admission.admitedByName),
                    if (isPrivileged && admission.admitedById != null)
                      _Detail(
                        'Admitted By ID',
                        admission.admitedById!.toString(),
                      ),
                    _Detail('Discharged By', admission.dischargedByName),
                    if (isPrivileged && admission.dischargedById != null)
                      _Detail(
                        'Discharged By ID',
                        admission.dischargedById!.toString(),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _Section(
                  title: 'Timeline',
                  icon: Icons.schedule_outlined,
                  rows: [
                    _Detail('Admission Date', _fmt(admission.admissionDate)),
                    _Detail(
                      'Expected Discharge',
                      _fmt(admission.expectedDischargeDate),
                    ),
                    _Detail('Discharge Date', _fmt(admission.dischargeDate)),
                  ],
                ),
                if (isPrivileged) ...[
                  const SizedBox(height: 24),
                  _ActionBar(admission: admission),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return '—';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }
}

class _PatientAppBar extends StatelessWidget {
  final HospitalAdmission admission;
  final bool isLoading;

  const _PatientAppBar({required this.admission, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF1A6B8A),
      foregroundColor: Colors.white,
      pinned: true,
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_Detail> rows;

  const _Section({required this.title, required this.icon, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF1A6B8A)),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7A8D),
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE5E9EE)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (int i = 0; i < rows.length; i++) ...[
                _DetailRow(detail: rows[i]),
                if (i != rows.length - 1)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Color(0xFFE5E9EE),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Detail {
  final String label;
  final String? value;

  const _Detail(this.label, this.value);
}

class _DetailRow extends StatelessWidget {
  final _Detail detail;

  const _DetailRow({required this.detail});

  @override
  Widget build(BuildContext context) {
    final hasValue = detail.value?.trim().isNotEmpty == true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 124,
            child: Text(
              detail.label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7A8D)),
            ),
          ),
          Expanded(
            child: Text(
              hasValue ? detail.value!.trim() : '—',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: hasValue
                    ? const Color(0xFF1A2B3C)
                    : const Color(0xFF9EA8B3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final HospitalAdmission admission;

  const _ActionBar({super.key, required this.admission});

  bool get _isAlreadyDischarged =>
      (admission.status ?? '').trim().toLowerCase() == 'discharged';

  ButtonStyle _buttonStyle({required Color backgroundColor}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      disabledBackgroundColor: const Color(0xFFCDD5DF),
      disabledForegroundColor: Colors.black87,
      elevation: 0,
      minimumSize: const Size(double.infinity, 48),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              final updated = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) =>
                      AdmissionUpdateScreen(admissionId: admission.id!),
                ),
              );
              if (updated == true && context.mounted) {
                context.read<AdmissionDetailsViewModel>().refresh(
                  admissionId: admission.id!,
                );
              }
            },
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Update', overflow: TextOverflow.ellipsis),
            style: _buttonStyle(backgroundColor: const Color(0xFF1A6B8A)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isAlreadyDischarged
                ? null
                : () {
                    Navigator.of(context)
                        .push<bool>(
                          MaterialPageRoute(
                            builder: (_) => AdmissionTransferScreen(
                              admissionId: admission.id!,
                            ),
                          ),
                        )
                        .then((updated) {
                          if (updated == true && context.mounted) {
                            context.read<AdmissionDetailsViewModel>().refresh(
                              admissionId: admission.id!,
                            );
                          }
                        });
                  },
            icon: const Icon(Icons.swap_horiz_rounded, size: 18),
            label: const Text('Transfer', overflow: TextOverflow.ellipsis),
            style: _buttonStyle(backgroundColor: const Color(0xFFE65100)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isAlreadyDischarged
                ? null
                : () {
                    Navigator.of(context)
                        .push<bool>(
                          MaterialPageRoute(
                            builder: (_) => AdmissionDischargeScreen(
                              admissionId: admission.id!,
                            ),
                          ),
                        )
                        .then((updated) {
                          if (updated == true && context.mounted) {
                            context.read<AdmissionDetailsViewModel>().refresh(
                              admissionId: admission.id!,
                            );
                          }
                        });
                  },
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(
              _isAlreadyDischarged ? 'Discharged' : 'Discharge',
              overflow: TextOverflow.ellipsis,
            ),
            style: _buttonStyle(backgroundColor: const Color(0xFF2E7D32)),
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1A6B8A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF1A6B8A)),
            SizedBox(height: 16),
            Text(
              'Loading admission…',
              style: TextStyle(color: Color(0xFF6B7A8D)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1A6B8A),
        foregroundColor: Colors.white,
        title: const Text('Admission Details'),
      ),
      body: Center(
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
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6B8A),
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
            ],
          ),
        ),
      ),
    );
  }
}
