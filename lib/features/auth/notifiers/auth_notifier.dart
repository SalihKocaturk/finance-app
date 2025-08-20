import 'package:expense_tracker/features/auth/firebase_auth/firebase_auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/toast.dart';
import '../../../core/repositories/user_repository.dart';
import '../models/user.dart';
import '../providers/auth_form_providers.dart';
import '../providers/user_provider.dart';

class AuthNotifier extends Notifier<User> {
  final userRepository = UserRepository();
  final authService = FirebaseAuthService();
  @override
  User build() => User(
    name: "",
    email: "",
  );
  //firebase islemleri
  Future<void> logIn(WidgetRef ref) async {
    final email = ref.read(loginEmailProvider);
    final password = ref.read(loginPasswordProvider);
    final user = await authService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      showToast("Kayıt başarılı.");

      state = user;
      await userRepository.setUser(state);
      ref.invalidate(hasUserProvider);
    } else {}
  }

  Future<void> register(WidgetRef ref) async {
    final name = ref.read(registernameProvider);
    final email = ref.read(registerEmailProvider);
    final password = ref.read(registerPasswordProvider);
    final password2 = ref.read(registerPassword2Provider);
    if (password2 != password) {
      showToast("Sifreler uyusmuyor.");
    } else {
      final user = await authService.signUpWithEmailAndPassword(email: email, password: password, name: name);
      if (user != null) {
        state = user;
        await userRepository.setUser(state);
        ref.invalidate(hasUserProvider);
      } else {
        showToast("Kayıt başarısız.");
      }
    }
  }

  Future<void> logOut() async {
    await userRepository.removeUser();
    ref.invalidate(hasUserProvider);
    ref.invalidate(userProvider);
  }
}
