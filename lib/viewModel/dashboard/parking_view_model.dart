import 'package:flutter/material.dart';
import '../../model/parking_model.dart';
import '../../service/parking_service.dart';

class ParkingViewModel extends ChangeNotifier {
  final ParkingService _service = ParkingService();
  List<ParkingModel> parkingList = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> createParking({
    required String floor,
    required String parkingNo,
    required double parkingFee,
    required bool isActive,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      await _service.createParking(
        floor: floor,
        parkingNo: parkingNo,
        parkingFee: parkingFee,
        isActive: isActive,
      );
      await loadParking();
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadParking() async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();
      parkingList = await _service.getAllParking();
      parkingList.sort((a, b) {
        final aNum = int.tryParse(
          a.parkingNo.replaceAll(RegExp(r'[^0-9]'), ''),
        );
        final bNum = int.tryParse(
          b.parkingNo.replaceAll(RegExp(r'[^0-9]'), ''),
        );
        if (aNum != null && bNum != null) {
          return aNum.compareTo(bNum);
        }
        return a.parkingNo.compareTo(b.parkingNo);
      });
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateParking(ParkingModel model) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();
      await _service.updateParking(model.parkingId!, model);
      await loadParking();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteParking(int id) async {
    try {
      isLoading = true;
      notifyListeners();
      await _service.deleteParking(id);
      parkingList.removeWhere((item) => item.parkingId == id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}