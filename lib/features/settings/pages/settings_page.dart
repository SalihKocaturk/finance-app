// settings_page.dart
import 'package:expense_tracker/features/settings/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final themeAsync = ref.watch(themeProvider);
    final isLight = themeAsync.value ?? true;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leadingWidth: 120,
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () => Navigator.of(context).pop(),
                  padding: const EdgeInsets.all(4.0),
                  iconSize: 23,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8, top: 4),
            child: Text('View', style: textTheme.titleMedium),
          ),
          Card(
            elevation: 0,
            color: const Color.fromARGB(105, 158, 158, 158),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark Theme'),
              subtitle: const Text('Set dark app theme'),
              trailing: Switch(
                focusColor: Colors.grey,
                value: !isLight,
                onChanged: (bool v) {
                  ref.read(themeProvider.notifier).setIsLight(!v);
                },
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
