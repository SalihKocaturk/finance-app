import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../providers/bottom_nav_provider.dart';

class CustomNavigationBar extends ConsumerWidget {
  final int index;
  const CustomNavigationBar({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (i) => ref.read(bottomNavProvider.notifier).state = i,

      destinations: [
        NavigationDestination(
          icon: const Icon(
            Icons.home_outlined,
          ),
          selectedIcon: const Icon(Icons.home, color: Color(0xFF7F00FF)),
          label: LocaleKeys.home.tr().capitalizeFirst(),
        ),
        NavigationDestination(
          icon: const Icon(
            Icons.add_circle_outline,
          ),
          selectedIcon: const Icon(Icons.add_circle, color: Color(0xFF7F00FF)),
          label: LocaleKeys.transactions.tr().capitalizeFirst(),
        ),
        NavigationDestination(
          icon: const Icon(
            Icons.bar_chart,
          ),
          selectedIcon: const Icon(Icons.bar_chart, color: Color(0xFF7F00FF)),
          label: LocaleKeys.statistics.tr().capitalizeFirst(),
        ),
        NavigationDestination(
          icon: const Icon(
            Icons.settings,
          ),
          selectedIcon: const Icon(Icons.settings, color: Color(0xFF7F00FF)),
          label: LocaleKeys.settings.tr().capitalizeFirst(),
        ),
      ],
    );
  }
}
