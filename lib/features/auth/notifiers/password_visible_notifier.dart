import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordVisibleNotifier extends Notifier<bool> {
  @override
  build() {
    return true;
  }

  void toggle() => state = !state;
}
