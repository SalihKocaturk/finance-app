import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';

class UserNotifier extends Notifier<User> {
  @override
  User build() => User(name: "", email: "", password: "");

  void setUser(WidgetRef ref) {
    final name = ref.read(nameProvider);
    final email = ref.read(emailProvider);
    final password = ref.read(passwordProvider);

    state = User(name: name, email: email, password: password);
  }
}
