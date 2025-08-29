import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/models/user.dart';

class UserStorage {
  static const _key = 'current_user';

  Future<User?> get() async {
    final instance = await SharedPreferences.getInstance();
    final data = instance.getString(_key);
    if (data == null) return null;
    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return User.fromJson(map);
    } catch (_) {
      await instance.remove(_key);
      return null;
    }
  }

  Future<void> set(User user) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(_key, jsonEncode(user.toJson()));
  }

  Future<void> delete() async {
    final instance = await SharedPreferences.getInstance();
    await instance.remove(_key);
  }
}
