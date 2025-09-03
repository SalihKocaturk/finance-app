import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/storage/lang_storage.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class LanguageNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    getLocale();
    return const Locale('en');
  }

  Future<void> setLocale(BuildContext context, Locale locale) async {
    state = locale;
    await LangStorage().setLocale(locale);
    if (context.mounted) {
      await context.setLocale(locale);
    }
  }

  Future<void> getLocale() async {
    final saved = await LangStorage().readLocale();
    if (saved != null && saved != state) {
      state = saved;
    }
  }
}
