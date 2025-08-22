import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bottom_nav_provider.dart';

class CustomNavigationBar extends ConsumerWidget {
  final int index;
  const CustomNavigationBar({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (i) => ref.read(bottomNavProvider.notifier).state = i,

      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(Icons.home, color: Color(0xFF7F00FF)),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.add_circle_outline,
          ),
          selectedIcon: Icon(Icons.add_circle, color: Color(0xFF7F00FF)),
          label: 'Transaction',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.bar_chart,
          ),
          selectedIcon: Icon(Icons.person, color: Color(0xFF7F00FF)),
          label: 'Statistics',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.person_outline,
          ),
          selectedIcon: Icon(Icons.person, color: Color(0xFF7F00FF)),
          label: 'Profile',
        ),
      ],
    );
  }
}
