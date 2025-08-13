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
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      elevation: 8,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0x207F00FF),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: Colors.black),
          selectedIcon: Icon(Icons.home, color: Color(0xFF7F00FF)),
          label: 'Ev',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline, color: Colors.black),
          selectedIcon: Icon(Icons.add_circle, color: Color(0xFF7F00FF)),
          label: 'İşlem Ekle',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: Colors.black),
          selectedIcon: Icon(Icons.person, color: Color(0xFF7F00FF)),
          label: 'Profil',
        ),
      ],
    );
  }
}
