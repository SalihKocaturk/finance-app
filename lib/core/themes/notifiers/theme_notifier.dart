import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/theme_storage.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  final ThemeStorage storage = ThemeStorage();

  @override
  ThemeMode build() {
    loadTheme();
    return ThemeMode.light;
  }

  Future<void> toggle() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await storage.save(state);
  }

  Future<void> loadTheme() async {
    final savedTheme = await storage.get();
    state = savedTheme;
  }

  Future<void> clear() async {
    await storage.delete();
    state = ThemeMode.light;
  }
}
