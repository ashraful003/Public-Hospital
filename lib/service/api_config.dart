import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:9090/api/auth";
    }
    try {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:9090/api/auth";
      }
      if (Platform.isIOS || Platform.isMacOS) {
        return "http://localhost:9090/api/auth";
      }
      if (Platform.isWindows || Platform.isLinux) {
        return "http://localhost:9090/api/auth";
      }
    } catch (e) {
      print("$e");
    }
    return "http://192.168.1.5:9090/api/auth";
  }
}
