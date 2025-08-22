import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/theme_notifier.dart';

final themeProvider = AsyncNotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);
