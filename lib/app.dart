import 'package:expense_tracker/core/themes/dark_theme.dart';
import 'package:expense_tracker/core/themes/light_theme.dart';
import 'package:expense_tracker/features/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/pages/login_page.dart';
import 'features/auth/providers/user_provider.dart';
import 'features/settings/providers/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUser = ref.watch(hasUserProvider);
    final themeAsync = ref.watch(themeProvider);

    if (hasUser.isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    if (hasUser.hasError) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: Text('Hata oluştu'))),
      );
    }

    final isLoggedIn = hasUser.value ?? false;
    if (isLoggedIn) {}
    final isLight = themeAsync.value ?? true;

    return MaterialApp(
      title: 'Expense Tracker',
      theme: isLight ? LightTheme.theme : DarkTheme.theme,
      home: isLoggedIn ? const BasePage() : const LoginPage(),
    );
  }
}
