import 'package:flutter/foundation.dart';
import '../../model/hospital_admission.dart';
import '../../service/hospital_admission_service.dart';

enum AdmissionLoadState { idle, loading, loaded, error }

const _privilegedRoles = {'admin', 'receptionist'};

class AdmissionViewModel extends ChangeNotifier {
  final HospitalAdmissionService _service = HospitalAdmissionService();
  final String targetStatus;

  AdmissionViewModel({this.targetStatus = 'admitted'});

  AdmissionLoadState _state = AdmissionLoadState.idle;
  String _errorMessage = '';
  List<HospitalAdmission> _allAdmissions = [];
  List<HospitalAdmission> _filteredAdmissions = [];
  String _searchQuery = '';

  AdmissionLoadState get state => _state;

  String get errorMessage => _errorMessage;

  List<HospitalAdmission> get admissions => _filteredAdmissions;

  String get searchQuery => _searchQuery;

  bool get isLoading => _state == AdmissionLoadState.loading;

  bool get hasError => _state == AdmissionLoadState.error;

  bool get isEmpty =>
      _state == AdmissionLoadState.loaded && _filteredAdmissions.isEmpty;

  static bool isPrivilegedRole(String role) =>
      _privilegedRoles.contains(role.trim().toLowerCase());

  bool _matchesTargetStatus(HospitalAdmission a) =>
      (a.status ?? '').trim().toLowerCase() ==
      targetStatus.trim().toLowerCase();

  Future<void> loadAdmissions({
    required String isPrivileged,
    String? currentPatientId,
  }) async {
    _setState(AdmissionLoadState.loading);
    _allAdmissions = [];
    _filteredAdmissions = [];
    try {
      if (isPrivilegedRole(isPrivileged)) {
        _allAdmissions = await _service.getAllAdmissions();
      } else {
        if (currentPatientId == null || currentPatientId.trim().isEmpty) {
          throw Exception('Patient ID is required for non-privileged users.');
        }
        _allAdmissions = await _service.getAdmissionsByPatientId(
          currentPatientId.trim(),
        );
      }
      _sortByLatestFirst(_allAdmissions);
      _applySearch();
      _setState(AdmissionLoadState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(AdmissionLoadState.error);
    }
  }

  void onSearchChanged(String query) {
    _searchQuery = query.trim();
    _applySearch();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    final statusMatched = _allAdmissions.where(_matchesTargetStatus).toList();
    if (_searchQuery.isEmpty) {
      _filteredAdmissions = statusMatched;
    } else {
      final q = _searchQuery.toLowerCase();
      _filteredAdmissions = statusMatched.where((a) {
        return (a.patientId?.toLowerCase().contains(q) ?? false) ||
            (a.patientName?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    _sortByLatestFirst(_filteredAdmissions);
  }

  void _sortByLatestFirst(List<HospitalAdmission> list) {
    list.sort((a, b) {
      final aDate = a.admissionDate;
      final bDate = b.admissionDate;
      if (aDate != null && bDate != null) {
        final cmp = bDate.compareTo(aDate);
        if (cmp != 0) return cmp;
      } else if (aDate != null) {
        return -1;
      } else if (bDate != null) {
        return 1;
      }
      final aId = a.id ?? 0;
      final bId = b.id ?? 0;
      return bId.compareTo(aId);
    });
  }

  Future<void> refresh({
    required String isPrivileged,
    String? currentPatientId,
  }) => loadAdmissions(
    isPrivileged: isPrivileged,
    currentPatientId: currentPatientId,
  );

  void _setState(AdmissionLoadState s) {
    _state = s;
    notifyListeners();
  }
}
