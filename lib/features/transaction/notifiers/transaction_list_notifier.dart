import 'package:expense_tracker/core/domain/entities/transaction_categories.dart';
import 'package:expense_tracker/core/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_form_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/transaction.dart';

class TransactionListNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() {
    final initial = TransactionRepository().getTransactions();
    return initial ?? [];
  }

  Future<void> save(String? id) async {
    final amount = ref.read(amountProvider);
    final category = ref.read(categoryProvider);
    final date = ref.read(dateProvider);
    final description = ref.read(descriptionProvider);

    if (id == null) {
      //yeni ekleme
      final newTx = Transaction(
        category: category ?? transactionCategories.first,
        amount: amount ?? 0,
        date: date ?? DateTime.now(),
        details: description ?? "",
      );
      state = [...state, newTx];
      await TransactionRepository().setTransaction(newTx);
    } else {
      //güncelleme
      final idx = state.indexWhere((t) => t.id == id);
      if (idx != -1) {
        final old = state[idx];
        final updated = Transaction(
          id: old.id,
          category: category ?? old.category,
          amount: amount ?? 0,
          date: date ?? old.date,
          details: description ?? old.details,
        );
        final list = [...state];
        list[idx] = updated;
        state = list;
        await TransactionRepository().setTransaction(updated);
      }
    }

    // Form providerlarını temizle
    ref.invalidate(amountProvider);
    ref.invalidate(categoryProvider);
    ref.invalidate(dateProvider);
    ref.invalidate(descriptionProvider);

    debugPrint('Kayıt başarılı: $state');
  }

  Future<void> delete(String id) async {
    state = state.where((t) => t.id != id).toList(growable: false);
    await TransactionRepository().delete(id);
  }
}
