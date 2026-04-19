import 'package:shared_preferences/shared_preferences.dart';
import '../utils/pref_keys.dart';

class SharedPrefService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _isLoggedInKey = PrefKeys.isLoggedIn;
  static const String _tokenKey = PrefKeys.token;
  static const String _roleKey = PrefKeys.role;
  static const String _rememberEmailKey = PrefKeys.rememberEmail;
  static const String _rememberPasswordKey = PrefKeys.rememberPassword;

  static Future<void> saveLogin({
    required String token,
    required String role,
  }) async {
    await _prefs.setBool(_isLoggedInKey, true);
    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_roleKey, role);
  }

  static bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  static String? getRole() {
    return _prefs.getString(_roleKey);
  }

  static Future<void> saveRememberMe({
    required String email,
    required String password,
  }) async {
    await _prefs.setString(_rememberEmailKey, email);
    await _prefs.setString(_rememberPasswordKey, password);
  }

  static String? getRememberEmail() {
    return _prefs.getString(_rememberEmailKey);
  }

  static String? getRememberPassword() {
    return _prefs.getString(_rememberPasswordKey);
  }

  static Future<void> clearRememberMe() async {
    await _prefs.remove(_rememberEmailKey);
    await _prefs.remove(_rememberPasswordKey);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }

  static Future<void> logout() async {
    await _prefs.clear();
  }
}
