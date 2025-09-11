import 'package:expense_tracker/core/services/firebase_services.dart';
import 'package:expense_tracker/core/storage/user_storage.dart';
import 'package:expense_tracker/features/account_info/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/toast.dart';
import '../../../core/domain/enums/alert_type.dart';
import '../../account_info/providers/form_providers.dart';
import '../models/user.dart';
import '../providers/account_provider.dart';
import '../providers/auth_form_providers.dart';
import '../providers/has_account_provider.dart';
import '../providers/has_user_provider.dart';

class AuthNotifier extends Notifier<User> {
  final userStorage = UserStorage();
  final authService = FirebaseService();
  @override
  User build() => User(
    name: "",
    email: "",
  );
  Future<bool> logIn(WidgetRef ref) async {
    final email = ref.read(loginEmailProvider);
    final password = ref.read(loginPasswordProvider);
    final user = await authService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      showToast(
        "Giriş başarılı.",
        AlertType.success,
      );
      state = user;
      await userStorage.setLoggedIn(true);
      ref.invalidate(hasUserProvider);
      ref.invalidate(hasAccountProvider);

      try {
        await ref.read(accountProvider.notifier).getAccountSession();
        return true;
      } catch (_) {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<void> register(WidgetRef ref) async {
    final name = ref.watch(registernameProvider);
    final email = ref.watch(registerEmailProvider);
    final password = ref.watch(registerPasswordProvider);

    final user = await authService.signUpWithEmailAndPassword(email: email, password: password, name: name);
    if (user != null) {
      state = user;
      await userStorage.setLoggedIn(true);
      ref.invalidate(hasUserProvider);
    } else {
      showToast(
        "Kayıt başarısız.",
        AlertType.fail,
      );
    }
  }

  Future<void> logOut() async {
    await userStorage.setLoggedIn(false);

    ref.invalidate(hasUserProvider);
    ref.invalidate(userProvider);
    ref.invalidate(editNameProvider);
    ref.invalidate(editEmailProvider);
    ref.invalidate(editBirthDateProvider);
    ref.invalidate(imageUrlProvider);

    // ref.invalidate(userProvider);
  }
}
