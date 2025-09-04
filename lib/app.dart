import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/themes/dark_theme.dart';
import 'package:expense_tracker/core/themes/light_theme.dart';
import 'package:expense_tracker/features/account_info/providers/user_provider.dart';
import 'package:expense_tracker/features/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/themes/providers/theme_provider.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/providers/has_user_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUser = ref.watch(hasUserProvider);
    final themeMode = ref.watch(themeProvider);
    ref.read(userProvider.notifier).fillEditors(ref);
    Widget home;
    if (hasUser.isLoading) {
      home = const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (hasUser.hasError) {
      home = const Scaffold(body: Center(child: Text('Hata oluştu')));
    } else {
      final isLoggedIn = hasUser.value ?? false;
      home = isLoggedIn ? const BasePage() : const LoginPage();
    }

    return MaterialApp(
      title: 'Expense Tracker',
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: themeMode,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: home,
    );
  }
}
