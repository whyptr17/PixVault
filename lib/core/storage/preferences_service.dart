import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isOnboarded => _prefs.getBool('is_onboarded') ?? false;
  static Future<void> setOnboarded(bool value) async {
    await _prefs.setBool('is_onboarded', value);
  }

  static String? get userData => _prefs.getString('user_data');
  static Future<void> setUserData(String value) async {
    await _prefs.setString('user_data', value);
  }
  static Future<void> clearUserData() async {
    await _prefs.remove('user_data');
  }

  static String get themeMode => _prefs.getString('theme_mode') ?? 'dark';
  static Future<void> setThemeMode(String value) async {
    await _prefs.setString('theme_mode', value);
  }
}
