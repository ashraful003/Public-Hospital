import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/hospital_admission.dart';
import '../../viewModel/dashboard/admission_view_model.dart';
import 'admission_details_screen.dart';
import 'admission_patient_screen.dart';

class AdmissionScreen extends StatelessWidget {
  final String role;
  final String? patientId;

  const AdmissionScreen({super.key, required this.role, this.patientId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdmissionViewModel(),
      child: _AdmissionView(role: role, patientId: patientId),
    );
  }
}

class _AdmissionView extends StatefulWidget {
  final String role;
  final String? patientId;

  const _AdmissionView({required this.role, this.patientId});

  @override
  State<_AdmissionView> createState() => _AdmissionViewState();
}

class _AdmissionViewState extends State<_AdmissionView> {
  final TextEditingController _searchController = TextEditingController();

  bool get _isPrivileged {
    final r = widget.role.trim().toLowerCase();
    return r == 'admin' || r == 'receptionist';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdmissionViewModel>().loadAdmissions(
        isPrivileged: widget.role,
        currentPatientId: widget.patientId,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          if (_isPrivileged) _SearchBar(controller: _searchController),
          _TableHeader(role: widget.role),
          Expanded(
            child: _Body(role: widget.role, patientId: widget.patientId),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1A6B8A),
      foregroundColor: Colors.white,
      title: const Text(
        'Admissions',
        style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.4),
      ),
      actions: [
        if (_isPrivileged)
          IconButton(
            iconSize: 25, // Change to your desired size
            icon: const Icon(
              Icons.add_circle_outline_rounded,
            ),
            tooltip: 'Admit patient',
            onPressed: () => _openAdmitPatient(context),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Consumer<AdmissionViewModel>(
            builder: (_, vm, __) => IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
              onPressed: vm.isLoading
                  ? null
                  : () {
                      if (_isPrivileged) _searchController.clear();
                      vm.refresh(
                        isPrivileged: widget.role,
                        currentPatientId: widget.patientId,
                      );
                    },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openAdmitPatient(BuildContext context) async {
    final admitted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AdmissionPatientScreen(role: widget.role),
      ),
    );
    if (admitted == true && context.mounted) {
      context.read<AdmissionViewModel>().refresh(
        isPrivileged: widget.role,
        currentPatientId: widget.patientId,
      );
    }
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<AdmissionViewModel>();
    return Container(
      color: const Color(0xFF1A6B8A),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: TextField(
          controller: controller,
          onChanged: vm.onSearchChanged,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search by national ID or patient name…',
            hintStyle: const TextStyle(color: Color(0xFF9EA8B3)),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF1A6B8A),
              size: 22,
            ),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, __) => value.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () {
                        controller.clear();
                        vm.clearSearch();
                      },
                    ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String role;

  const _TableHeader({required this.role});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdmissionViewModel>(
      builder: (_, vm, __) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF1A6B8A),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xFF155A74),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 1,
                      child: _HeaderCell('No.', align: TextAlign.center),
                    ),
                    Expanded(flex: 3, child: _HeaderCell('Patient Name')),
                    Expanded(flex: 2, child: _HeaderCell('Patient ID')),
                    Expanded(flex: 2, child: _HeaderCell('Admission')),
                    Expanded(flex: 2, child: _HeaderCell('Exp. Discharge')),
                    Expanded(
                      flex: 2,
                      child: _HeaderCell('Status', align: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final TextAlign align;

  const _HeaderCell(this.text, {this.align = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String role;
  final String? patientId;

  const _Body({required this.role, this.patientId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdmissionViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) return const _LoadingView();
        if (vm.hasError) {
          return _ErrorView(
            message: vm.errorMessage,
            onRetry: () =>
                vm.refresh(isPrivileged: role, currentPatientId: patientId),
          );
        }
        if (vm.isEmpty) return _EmptyView(query: vm.searchQuery);
        return RefreshIndicator(
          color: const Color(0xFF1A6B8A),
          onRefresh: () =>
              vm.refresh(isPrivileged: role, currentPatientId: patientId),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
            itemCount: vm.admissions.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: Color(0xFFEBEFF4),
              indent: 0,
              endIndent: 0,
            ),
            itemBuilder: (_, i) => _AdmissionRow(
              index: i + 1,
              admission: vm.admissions[i],
              role: role,
              patientId: patientId,
            ),
          ),
        );
      },
    );
  }
}

class _AdmissionRow extends StatelessWidget {
  final int index;
  final HospitalAdmission admission;
  final String role;
  final String? patientId;

  const _AdmissionRow({
    required this.index,
    required this.admission,
    required this.role,
    this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    final isEven = index % 2 == 0;
    return InkWell(
      onTap: () => _openDetails(context),
      child: Container(
        color: isEven ? const Color(0xFFF9FAFB) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '$index',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A6B8A),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _MiniAvatar(name: admission.patientName ?? '?'),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      admission.patientName ?? '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A2B3C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                admission.patientId ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7A8D)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _fmtShort(admission.admissionDate),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF4A5568)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _fmtShort(admission.expectedDischargeDate),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF4A5568)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(child: _StatusChip(status: admission.status)),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    if (admission.id == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AdmissionDetailsScreen(
          role: role,
          patientId: patientId,
          admissionId: admission.id!,
        ),
      ),
    );
  }

  String _fmtShort(DateTime? dt) {
    if (dt == null) return '—';
    return DateFormat('dd MMM yy').format(dt);
  }
}

class _MiniAvatar extends StatelessWidget {
  final String name;

  const _MiniAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase();
    return CircleAvatar(
      radius: 14,
      backgroundColor: const Color(0xFFD6EAF3),
      child: Text(
        initials,
        style: const TextStyle(
          color: Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String? status;

  const _StatusChip({this.status});

  @override
  Widget build(BuildContext context) {
    final s = (status ?? 'unknown').toLowerCase();
    final Color bg;
    final Color fg;
    switch (s) {
      case 'admitted':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        break;
      case 'discharged':
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        break;
      case 'pending':
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFF57F17);
        break;
      default:
        bg = const Color(0xFFF5F5F5);
        fg = const Color(0xFF616161);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status ?? 'Unknown',
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFF1A6B8A)),
          SizedBox(height: 16),
          Text(
            'Loading admissions…',
            style: TextStyle(color: Color(0xFF6B7A8D)),
          ),
        ],
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
                backgroundColor: const Color(0xFF1A6B8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
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

class _EmptyView extends StatelessWidget {
  final String query;

  const _EmptyView({required this.query});

  @override
  Widget build(BuildContext context) {
    final isSearch = query.isNotEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearch ? Icons.search_off_rounded : Icons.folder_open_rounded,
              size: 56,
              color: const Color(0xFFCDD5DF),
            ),
            const SizedBox(height: 16),
            Text(
              isSearch ? 'No results for "$query"' : 'No admissions found',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A5568),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearch
                  ? 'Try a different national ID or name.'
                  : 'Pull down to refresh.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF9EA8B3)),
            ),
          ],
        ),
      ),
    );
  }
}