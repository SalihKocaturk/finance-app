import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final hasUser = ref.watch(hasUserProvider);
    // if (hasUser.isLoading) {
    //   return const MaterialApp(
    //     home: Scaffold(
    //       body: Center(child: CircularProgressIndicator()),
    //     ),
    //   );
    // }
    // if (hasUser.hasError) {
    //   return MaterialApp(
    //     home: Scaffold(
    //       body: Center(child: Text('Hata: ${hasUser.error}')),
    //     ),
    //   );
    // }
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
