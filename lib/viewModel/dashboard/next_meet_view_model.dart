import 'package:flutter/material.dart';
import '../../model/next_meet_model.dart';
import '../../model/user_model.dart';
import '../../service/next_meet_service.dart';
import '../../service/profile_service.dart';

class NextMeetViewModel extends ChangeNotifier {
  final NextMeetService _nextMeetService = NextMeetService();
  final String nationalId;

  NextMeetViewModel(this.nationalId);

  final TextEditingController durationController = TextEditingController();
  List<NextMeetModel> meetList = [];
  List<NextMeetModel> filteredMeetList = [];
  UserModel? currentUser;
  bool isLoading = false;

  Future<void> loadCurrentUserAndMeetTime() async {
    try {
      isLoading = true;
      notifyListeners();
      meetList = await _nextMeetService.getMeetTime(nationalId);
      filteredMeetList = meetList.reversed.toList();
    } catch (e) {
      meetList = [];
      filteredMeetList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchMeet(String query) {
    if (query.isEmpty) {
      filteredMeetList = meetList;
    } else {
      filteredMeetList = meetList
          .where((e) => e.duration.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<bool> createMeet() async {
    try {
      isLoading = true;
      notifyListeners();
      final success = await _nextMeetService.createMeetTime(
        nationalId,
        durationController.text,
      );
      return success;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateMeetTime(int id) async {
    try {
      isLoading = true;
      notifyListeners();
      final success = await _nextMeetService.updateMeetTime(
        id,
        nationalId,
        durationController.text,
      );
      return success;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMeet(int id) async {
    try {
      isLoading = true;
      notifyListeners();
      await _nextMeetService.deleteMeetTime(id);
      meetList.removeWhere((e) => e.id == id);
      filteredMeetList.removeWhere((e) => e.id == id);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setEditData(String duration) {
    durationController.text = duration;
  }
}
