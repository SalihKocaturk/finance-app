import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  static const _key = 'theme_mode'; // 0 system, 1 light, 2 dark

  Future<ThemeMode> get() async {
    final instance = await SharedPreferences.getInstance();
    final mode = instance.getInt(_key);
    if (mode == null) return ThemeMode.system;
    return ThemeMode.values[mode.clamp(0, ThemeMode.values.length - 1)];
  }

  Future<void> save(ThemeMode mode) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setInt(_key, mode.index);
  }

  Future<void> delete() async {
    final instance = await SharedPreferences.getInstance();
    await instance.remove(_key);
  }
}
