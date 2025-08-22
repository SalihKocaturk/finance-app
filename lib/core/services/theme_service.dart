import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const key = 'isLightTheme';
  // bool true ise light false ise dark theme
  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }

  Future<void> saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
