import 'package:flutter/foundation.dart';
import '../../model/hospital_seat.dart';
import '../../service/seat_service.dart';

enum UpdateSeatViewState { idle, loading, success, error }

class SeatUpdateViewModel extends ChangeNotifier {
  final SeatService _seatService;

  SeatUpdateViewModel({required SeatService seatService})
    : _seatService = seatService;
  UpdateSeatViewState _state = UpdateSeatViewState.idle;
  String _errorMessage = '';
  HospitalSeat? seat;

  bool get isLoading => _state == UpdateSeatViewState.loading;

  bool get hasError => _state == UpdateSeatViewState.error;

  bool get isSuccess => _state == UpdateSeatViewState.success;

  String get errorMessage => _errorMessage;
  static const List<String> seatTypes = [
    "GENERAL",
    "VIP",
    "ICU",
    "EMERGENCY",
    "CABIN",
  ];
  static const List<String> currencies = ["BDT"];

  Future<void> loadSeatById(int id) async {
    _state = UpdateSeatViewState.loading;
    notifyListeners();
    try {
      seat = await _seatService.getSeatById(id);
      _state = UpdateSeatViewState.idle;
    } catch (e) {
      _errorMessage = e.toString();
      _state = UpdateSeatViewState.error;
    }
    notifyListeners();
  }

  Future<bool> updateSeat({
    required int id,
    required String type,
    required String seatNo,
    required double price,
    required String currency,
    required bool status,
  }) async {
    _state = UpdateSeatViewState.loading;
    notifyListeners();
    try {
      final requestBody = {
        "type": type,
        "seatNo": seatNo,
        "price": price,
        "currency": currency,
        "status": status,
      };
      await _seatService.updateSeat(id, requestBody);
      _state = UpdateSeatViewState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _state = UpdateSeatViewState.error;
      notifyListeners();
      return false;
    }
  }
}