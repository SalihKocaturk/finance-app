import 'package:expense_tracker/features/transaction/notifiers/transaction_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/enums/user_type.dart';
import '../../../core/domain/models/account.dart';
import '../../../core/domain/models/user_account.dart';
import '../../../core/services/firebase_services.dart';

class AccountNotifier extends AsyncNotifier<Account?> {
  final _service = FirebaseService();

  @override
  Future<Account?> build() async {
    return await _service.getAccountSession();
  }

  Future<bool> createSessionWithCurrentUser() async {
    state = const AsyncLoading();

    final created = await _service.createAccountSession();

    if (created == null) {
      state = AsyncValue.error('Oturum oluşturulamadı', StackTrace.current);
      return false;
    }

    state = AsyncData(created);
    return true;
  }

  Future<bool> removeUser(String userId) async {
    final ok = await _service.removeUserFromAccount(userId);
    if (!ok) return false;

    final cur = state.value;
    if (cur != null) {
      final updatedUsers = (cur.userAccounts ?? const <UserAccount>[]).where((u) => u.id != userId).toList();

      final updated = Account(
        id: cur.id,
        userAccounts: updatedUsers,
        transactions: cur.transactions,
        shareId: cur.shareId,
      );

      state = AsyncData(updated);
    } else {
      await getAccountSession();
    }
    return true;
  }

  Future<Account?> getAccountSession() async {
    state = const AsyncLoading();

    final acc = await _service.getAccountSession();
    ref.read(transactionListProvider.notifier).load();
    if (acc == null) {
      state = AsyncValue.error('Oturum bulunamadı', StackTrace.current);
      return null;
    }
    state = AsyncData(acc);
    return acc;
  }

  Future<bool> loginToAccountSession(int shareId) async {
    state = const AsyncLoading();

    final isLogged = await _service.loginToAccount(shareId: shareId);
    if (isLogged) {
      await getAccountSession();
    }
    return isLogged;
  }

  Future<void> exitAccount() async {
    state = const AsyncLoading();

    final isLoggedOut = await _service.exitAccount();
    if (!isLoggedOut) {
      state = AsyncValue.error('Hesaptan çıkış başarısız', StackTrace.current);
      return;
    }

    state = const AsyncData(null);
  }

  Future<bool> deleteAccount() async {
    state = const AsyncLoading();
    final ok = await _service.deleteAccount();
    state = ok ? const AsyncData(null) : AsyncValue.error('Hesabı kapatma başarısız', StackTrace.current);
    return ok;
  }

  Future<bool> changeUserRole(String userId, UserType newType) async {
    final current = state.value;
    if (current == null) return false;

    final updatedAccounts = (current.userAccounts ?? [])
        .map((u) => u.id == userId ? UserAccount(id: u.id, email: u.email, type: newType) : u)
        .toList();

    final optimistic = Account(
      id: current.id,
      userAccounts: updatedAccounts,
      transactions: current.transactions,
      shareId: current.shareId,
    );

    state = AsyncData(optimistic);

    final ok = await _service.setUserRole(userId: userId, newType: newType);
    if (!ok) {
      state = AsyncData(current);
    }
    return ok;
  }
}
