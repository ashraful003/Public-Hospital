import 'package:flutter/material.dart';
import 'package:public_hospital/data/shared_pref_service.dart';
import 'package:public_hospital/utils/pref_keys.dart';
import 'package:public_hospital/view/dashboard/bottom_nav_view.dart';
import 'package:public_hospital/view/login/LoginLanding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLogin() async {
    return await SharedPrefService.getBool(PrefKeys.isLoggedIn) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLogin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: snapshot.data! ? const BottomNavView() : const LandingScreen(),
        );
      },
    );
  }
}
