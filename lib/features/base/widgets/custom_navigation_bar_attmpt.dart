import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bottom_nav_provider.dart';

class CustomNavigationBarAttempt extends ConsumerWidget {
  const CustomNavigationBarAttempt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavProvider);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          color: Color(0xFF7F00FF),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: 64,
            indicatorColor: Colors.black.withAlpha(20),
            backgroundColor: Colors.transparent,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final sel = states.contains(WidgetState.selected);
              return TextStyle(
                fontSize: 12,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
                color: sel ? Colors.black : Colors.white,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final sel = states.contains(WidgetState.selected);
              return IconThemeData(
                color: sel ? Colors.black : Colors.white,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: index,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            onDestinationSelected: (i) {
              ref.read(bottomNavProvider.notifier).state = i;
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.add_circle_outline),
                selectedIcon: Icon(Icons.add_circle),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
