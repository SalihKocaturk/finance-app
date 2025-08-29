import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../notifiers/langauge_notifier.dart';

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(() => LanguageNotifier());
