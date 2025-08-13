import 'package:expense_tracker/features/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/pages/login_page.dart';
import 'features/auth/providers/user_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUser = ref.watch(hasUserProvider);

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

    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLoggedIn ? const BasePage() : const LoginPage(),
    );
  }
}
