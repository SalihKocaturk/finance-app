import 'package:expense_tracker/core/storage/user_storage.dart';
import 'package:expense_tracker/features/auth/firebase_auth/firebase_auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/toast.dart';
import '../../account_info/providers/form_providers.dart';
import '../../auth/models/user.dart';

class UserNotifier extends AsyncNotifier<User?> {
  final userStorage = UserStorage();
  final authService = FirebaseAuthService();

  @override
  Future<User?> build() async {
    final user = await userStorage.get();
    ref.read(editNameProvider.notifier).state = user?.name ?? "";
    ref.read(editEmailProvider.notifier).state = user?.email ?? "";
    ref.read(editBirthDateProvider.notifier).state = user?.birthDate ?? DateTime.now();
    ref.read(imageProvider.notifier).state = XFile(user?.imageUrl ?? "");

    return user;
  }

  void fillEditors(WidgetRef ref) {
    final user = state.value;
    if (user == null) return;
    ref.read(editNameProvider.notifier).state = user.name;
    ref.read(editEmailProvider.notifier).state = user.email;
    ref.read(editBirthDateProvider.notifier).state = user.birthDate ?? DateTime.now();
    ref.read(imageProvider.notifier).state = XFile(user.imageUrl ?? "");
  }

  Future<void> save(WidgetRef ref) async {
    final user = state.value;
    if (user == null || (user.id).isEmpty) {
      showToast("Kullanıcı oturumu bulunamadı.");
      return;
    }

    final newName = ref.read(editNameProvider).trim();
    final newEmail = ref.read(editEmailProvider).trim();
    final newBirthDate = ref.read(editBirthDateProvider);
    final XFile? avatarImgFile = ref.read(imageProvider);

    final controlledName = newName.isNotEmpty && newName != user.name ? newName : null;
    final controlledEmail = newEmail.isNotEmpty && newEmail != user.email ? newEmail : null;
    final controlledBirth = newBirthDate != user.birthDate ? newBirthDate : null;
    final controlledImagePath = avatarImgFile != null && avatarImgFile.path != user.imageUrl
        ? avatarImgFile.path
        : null;

    final isUpdated = await authService.updateUserProfile(
      uid: user.id,
      name: controlledName,
      email: controlledEmail,
      birthDate: controlledBirth,
      imageUrl: controlledImagePath,
    );
    if (!isUpdated) {
      showToast("Profil güncellenemedi.");
      return;
    }

    final updated = User(
      id: user.id,
      name: controlledName ?? user.name,
      email: controlledEmail ?? user.email,
      birthDate: controlledBirth ?? user.birthDate,
      imageUrl: controlledImagePath ?? user.imageUrl,
    );

    state = AsyncData(updated);
    await userStorage.set(updated);
    showToast("Profil güncellendi.");
  }

  Future<void> delete() async {
    await userStorage.delete();
    state = const AsyncData(null);
  }
}
