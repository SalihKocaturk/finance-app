import 'package:expense_tracker/features/auth/notifiers/password_visible_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordVisibleProvider = NotifierProvider<PasswordVisibleNotifier, bool>(
  () => PasswordVisibleNotifier(),
);
