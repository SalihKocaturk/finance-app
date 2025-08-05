import 'package:expense_tracker/features/auth/firebase_auth/firebase_auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/toast.dart';
import '../../../core/repositories/user_repository.dart';
import '../models/user.dart';
import '../providers/auth_form_providers.dart';

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
    final email = ref.read(emailProvider);
    final password = ref.read(passwordProvider);
    final user = await authService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      state = user;
      await userRepository.setUser(state);
    } else {
      showToast(message: "Kayıt başarısız.");
    }
  }

  Future<void> register(WidgetRef ref) async {
    final name = ref.read(nameProvider);
    final email = ref.read(emailProvider);
    final password = ref.read(passwordProvider);
    final user = await authService.signUpWithEmailAndPassword(email: email, password: password, name: name);
    if (user != null) {
      state = user;
      await userRepository.setUser(state);
    } else {
      showToast(message: "Kayıt başarısız.");
    }
  }

  void logOut() {
    userRepository.removeUser();
  }
}
