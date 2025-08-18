import 'package:expense_tracker/features/base/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/pages/home_page.dart';
import '../profile/pages/profile_page.dart';
import '../transaction/pages/transaction_page.dart';
import 'providers/bottom_nav_provider.dart';

class BasePage extends ConsumerWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    final pages = const [
      HomePage(),
      TransactionPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomNavigationBar(
        index: currentIndex,
      ),
    );
  }
}
