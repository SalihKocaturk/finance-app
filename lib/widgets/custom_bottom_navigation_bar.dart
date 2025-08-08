import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/base/providers/bottom_nav_provider.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  final int index;
  const CustomBottomNavigationBar({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int newIndex) {
        ref.read(bottomNavProvider.notifier).state = newIndex;
      },
      items: const [
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.home, color: Color(0xFF7F00FF)),
          icon: Icon(Icons.home, color: Colors.black),
          label: 'Ev',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.add, color: Color(0xFF7F00FF)),
          icon: Icon(Icons.add, color: Colors.black),
          label: 'İşlem Ekle',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.person, color: Color(0xFF7F00FF)),
          icon: Icon(Icons.person, color: Colors.black),
          label: 'Profil',
        ),
      ],
    );
  }
}
