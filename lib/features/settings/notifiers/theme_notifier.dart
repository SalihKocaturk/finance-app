import 'package:riverpod/riverpod.dart';

import '../../../core/services/theme_service.dart';

class ThemeNotifier extends AsyncNotifier<bool> {
  late final ThemeService service;

  @override
  Future<bool> build() async {
    service = ThemeService();
    return service.loadTheme();
  }

  Future<void> setIsLight(bool v) async {
    state = AsyncValue.data(v);
    await service.saveTheme(v);
  }

  Future<void> toggle() async {
    final current = state.value ?? true;
    await setIsLight(!current);
  }
}
