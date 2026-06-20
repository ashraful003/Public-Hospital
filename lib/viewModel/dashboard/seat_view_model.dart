import 'package:flutter/foundation.dart';
import '../../model/hospital_seat.dart';
import '../../service/seat_service.dart';

enum SeatViewState { idle, loading, success, error }

class SeatViewModel extends ChangeNotifier {
  final SeatService _seatService;

  SeatViewModel({SeatService? seatService})
    : _seatService = seatService ?? SeatService();
  SeatViewState _state = SeatViewState.idle;
  List<HospitalSeat> _seats = [];
  String _errorMessage = '';
  String _selectedType = 'GENERAL';

  SeatViewState get state => _state;

  List<HospitalSeat> get seats => List.unmodifiable(_seats);

  String get errorMessage => _errorMessage;

  String get selectedType => _selectedType;

  bool get isLoading => _state == SeatViewState.loading;

  bool get hasError => _state == SeatViewState.error;

  bool get hasData => _state == SeatViewState.success;
  static const List<String> seatTypes = [
    'GENERAL',
    'CABIN',
    'ICU',
    'EMERGENCY',
    'VIP',
  ];

  Future<void> fetchAvailableSeats() async {
    _setState(SeatViewState.loading);
    _errorMessage = '';
    try {
      _seats = await _seatService.getAvailableSeatsByType(_selectedType);
      _setState(SeatViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _seats = [];
      _setState(SeatViewState.error);
    }
  }

  Future<void> changeType(String type) async {
    if (_selectedType == type) return;
    _selectedType = type;
    notifyListeners();
    await fetchAvailableSeats();
  }

  void reset() {
    _seats = [];
    _errorMessage = '';
    _setState(SeatViewState.idle);
  }

  void _setState(SeatViewState newState) {
    _state = newState;
    notifyListeners();
  }
}