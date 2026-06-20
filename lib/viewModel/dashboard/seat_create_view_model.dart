import 'package:flutter/foundation.dart';
import '../../service/seat_service.dart';

enum CreateSeatViewState { idle, loading, success, error }

class SeatCreateViewModel extends ChangeNotifier {
  final SeatService _seatService;

  SeatCreateViewModel({SeatService? seatService})
    : _seatService = seatService ?? SeatService();
  CreateSeatViewState _state = CreateSeatViewState.idle;
  String _errorMessage = '';
  String _successMessage = '';

  CreateSeatViewState get state => _state;

  String get errorMessage => _errorMessage;

  String get successMessage => _successMessage;

  bool get isLoading => _state == CreateSeatViewState.loading;

  bool get hasError => _state == CreateSeatViewState.error;

  bool get isSuccess => _state == CreateSeatViewState.success;
  static const List<String> seatTypes = [
    'GENERAL',
    'CABIN',
    'ICU',
    'EMERGENCY',
    'VIP',
  ];
  static const List<String> currencies = ['BDT'];

  Future<void> createSeat({
    required String type,
    required String seatNo,
    required double price,
    required String currency,
  }) async {
    _setState(CreateSeatViewState.loading);
    _errorMessage = '';
    _successMessage = '';
    try {
      final result = await _seatService.createSeat({
        'type': type,
        'seatNo': seatNo,
        'price': price,
        'currency': currency,
        'status': true,
      });
      _successMessage = result['message'] ?? 'Seat created successfully!';
      _setState(CreateSeatViewState.success);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setState(CreateSeatViewState.error);
    }
  }

  void reset() {
    _errorMessage = '';
    _successMessage = '';
    _setState(CreateSeatViewState.idle);
  }

  void _setState(CreateSeatViewState newState) {
    _state = newState;
    notifyListeners();
  }
}
