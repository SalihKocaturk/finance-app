import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/localization/locale_keys.g.dart';
import 'package:expense_tracker/core/themes/providers/theme_provider.dart';
import 'package:expense_tracker/core/widgets/pop_page_button.dart';
import 'package:expense_tracker/features/app_settings/widgets/langauge_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/localization/providers/langauge_provider.dart';

class AppSettingsPage extends ConsumerWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final themeMode = ref.watch(themeProvider);
    final currentLocale = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings.tr().capitalizeFirst()),
        leadingWidth: 120,
        leading: const Row(children: [CustomAppbarButton()]),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8, top: 4),
            child: Text(LocaleKeys.view.tr().capitalizeFirst(), style: textTheme.titleMedium),
          ),
          Card(
            elevation: 0,
            color: const Color.fromARGB(105, 158, 158, 158),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: Text(LocaleKeys.dark_theme.tr().capitalizeFirst()),
              subtitle: Text(LocaleKeys.dark_theme_subtitle.tr().capitalizeFirst()),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
              ),
            ),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8, top: 4),
            child: Text(LocaleKeys.language.tr().capitalizeFirst(), style: textTheme.titleMedium),
          ),
          Card(
            elevation: 0,
            color: const Color.fromARGB(105, 158, 158, 158),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.language_outlined),
              title: Text(LocaleKeys.language.tr().capitalizeFirst()),
              subtitle: Text(LocaleKeys.choose_language.tr().capitalizeFirst()),
              trailing: LanguageDropdown(
                value: currentLocale.languageCode,
                onChanged: (val) async {
                  if (val == null) return;
                  await ref
                      .read(languageProvider.notifier)
                      .setLocale(
                        context,
                        Locale(val),
                      );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
