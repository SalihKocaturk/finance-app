import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangStorage {
  static const _key = 'app_locale';

  Future<Locale?> readLocale() async {
    final sp = await SharedPreferences.getInstance();
    final code = sp.getString(_key);
    if (code == null || code.isEmpty) return null;

    return Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, locale.languageCode);
  }
}
