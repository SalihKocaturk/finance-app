import 'dart:io';

import 'package:expense_tracker/core/services/firebase_services.dart';
import 'package:expense_tracker/core/storage/user_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/toast.dart';
import '../../../core/domain/enums/alert_type.dart';
import '../../account_info/providers/form_providers.dart';
import '../../auth/models/user.dart';

class UserNotifier extends AsyncNotifier<User?> {
  final userStorage = UserStorage();
  final authService = FirebaseService();
  final storage = FirebaseStorage.instance;
  @override
  @override
  Future<User?> build() async {
    final user = await FirebaseService().getUser();

    Future.microtask(() {
      ref.read(editNameProvider.notifier).state = user?.name ?? "";
      ref.read(editEmailProvider.notifier).state = user?.email ?? "";
      ref.read(editBirthDateProvider.notifier).state = user?.birthDate ?? DateTime.now();
      ref.read(imageUrlProvider.notifier).state = user?.imageUrl ?? "";
      ref.read(imageFileProvider.notifier).state = null;
    });

    return user;
  }

  void fillEditors(WidgetRef ref) {
    final user = state.value;
    if (user == null) return;
    ref.read(editNameProvider.notifier).state = user.name;
    ref.read(editEmailProvider.notifier).state = user.email;
    ref.read(editBirthDateProvider.notifier).state = user.birthDate ?? DateTime.now();
    ref.read(imageUrlProvider.notifier).state = user.imageUrl ?? "";

    ref.read(imageFileProvider.notifier).state = null;
  }

  Future<void> save(WidgetRef ref) async {
    final user = state.value;
    if (user == null || (user.id).isEmpty) {
      showToast(
        "Kullanıcı oturumu bulunamadı.",
        AlertType.fail,
      );
      return;
    }

    final newName = ref.read(editNameProvider).trim();
    final newEmail = ref.read(editEmailProvider).trim();
    final newBirthDate = ref.read(editBirthDateProvider);
    String? uploadedImageUrl;
    final XFile? avatarImgFile = ref.read(imageFileProvider);
    if (avatarImgFile != null && avatarImgFile.path.isNotEmpty) {
      final file = File(avatarImgFile.path);
      if (!file.existsSync()) {
        showToast(
          "Seçilen görsel bulunamadı: ${avatarImgFile.path}",
          AlertType.fail,
        );
      } else {
        try {
          final path = 'users/${user.id}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final refStorage = storage.ref().child(path);

          final task = await refStorage.putFile(
            file,
            SettableMetadata(contentType: 'image/jpeg'),
          );

          uploadedImageUrl = await task.ref.getDownloadURL();
        } on FirebaseException catch (e) {
          showToast(
            'Yükleme hatası: ${e.code}',
            AlertType.fail,
          );
        } catch (e) {
          showToast(
            'Beklenmeyen hata: $e',
            AlertType.fail,
          );
        }
      }
    }
    final controlledName = newName.isNotEmpty && newName != user.name ? newName : null;
    final controlledEmail = newEmail.isNotEmpty && newEmail != user.email ? newEmail : null;
    final controlledBirth = newBirthDate != user.birthDate ? newBirthDate : null;

    final isUpdated = await authService.updateUserProfile(
      uid: user.id,
      name: controlledName,
      email: controlledEmail,
      birthDate: controlledBirth,
      imageUrl: uploadedImageUrl,
    );
    if (!isUpdated) {
      showToast(
        "Profil güncellenemedi.",
        AlertType.fail,
      );
      return;
    }

    final updated = User(
      id: user.id,
      name: controlledName ?? user.name,
      email: controlledEmail ?? user.email,
      birthDate: controlledBirth ?? user.birthDate,
      imageUrl: uploadedImageUrl ?? user.imageUrl,
    );
    ref.read(imageUrlProvider.notifier).state = updated.imageUrl ?? "";
    ref.read(imageFileProvider.notifier).state = null;

    state = AsyncData(updated);

    await userStorage.setLoggedIn(true);
    showToast(
      "Profil güncellendi.",
      AlertType.success,
    );
  }

  Future<void> delete() async {
    await userStorage.setLoggedIn(false);
    state = const AsyncData(null);
  }
}
