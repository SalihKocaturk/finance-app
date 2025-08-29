import 'package:flutter/material.dart';

import 'langauge_tile.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(90),
        borderRadius: radius,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          value: value,
          borderRadius: radius,
          isDense: true,
          items: const [
            DropdownMenuItem(
              value: 'en',
              child: LangTile(flag: '🇺🇸', label: 'English'),
            ),
            DropdownMenuItem(
              value: 'tr',
              child: LangTile(flag: '🇹🇷', label: 'Türkçe'),
            ),
          ],
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ),
    );
  }
}
