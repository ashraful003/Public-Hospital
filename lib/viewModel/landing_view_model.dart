// viewmodel/landing_viewmodel.dart
import 'package:flutter/material.dart';

class LandingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final List<String> images = [
    'assets/images/doctor.png',
    'assets/images/ambulance.png',
    'assets/images/blood.png',
  ];

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}