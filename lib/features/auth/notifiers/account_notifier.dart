import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/account.dart';
import '../../../core/services/firebase_services.dart';

final accountProvider = AsyncNotifierProvider<AccountNotifier, Account?>(AccountNotifier.new);

class AccountNotifier extends AsyncNotifier<Account?> {
  final _service = FirebaseService();

  @override
  Future<Account?> build() async {
    return null; //firebaseden gelen account olacak burada
  }

  Future<void> createSessionWithCurrentUser() async {
    state = const AsyncLoading();

    final created = await _service.createAccountSessionForCurrentUser();

    if (created == null) {
      state = AsyncValue.error('Oturum oluşturulamadı', StackTrace.current);
      return;
    }

    state = AsyncData(created);
  }
}
