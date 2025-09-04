import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const _loginKey = 'is_logged_in';

  Future<void> setLoggedIn(bool value) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setBool(_loginKey, value);
  }

  Future<bool> isLoggedIn() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getBool(_loginKey) ?? false;
  }
}
