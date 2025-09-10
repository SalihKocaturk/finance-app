import 'package:expense_tracker/core/domain/enums/transaction_currency.dart';
import 'package:expense_tracker/core/providers/currency_provider.dart';
import 'package:expense_tracker/core/services/currency_service.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_category_provider.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_form_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/transaction.dart';
import '../../../core/services/firebase_services.dart';
import '../../auth/providers/account_provider.dart';

final transactionListProvider = AsyncNotifierProvider<TransactionListNotifier, List<Transaction>>(
  TransactionListNotifier.new,
);

class TransactionListNotifier extends AsyncNotifier<List<Transaction>> {
  final _service = FirebaseService();

  @override
  Future<List<Transaction>> build() async {
    final list = await _service.getTransactions();
    return List.unmodifiable(list);
  }

  Future<void> load() async {
    state = const AsyncLoading();
    final list = await _service.getTransactions();
    state = AsyncData(List.unmodifiable(list));
  }

  Future<void> add() async {
    final amount = ref.read(amountProvider);
    final category = ref.read(categoryProvider);
    final date = ref.read(dateProvider);
    final description = ref.read(descriptionProvider);
    final currencyType = ref.read(currencyTypeProvider);
    final transactionCategories = ref.read(transactionCategoriesProvider);

    final usdRate = await CurrencyService().getUsdRate();
    final eurRate = await CurrencyService().getEurRate();

    double toTl(double value, CurrencyType c) {
      switch (c) {
        case CurrencyType.tl:
          return value;
        case CurrencyType.usd:
          return usdRate > 0 ? value / usdRate : value;
        case CurrencyType.eur:
          return eurRate > 0 ? value / eurRate : value;
      }
    }

    final newTx = Transaction(
      category: category ?? transactionCategories.first,
      amount: toTl(amount ?? 0, currencyType),
      date: date ?? DateTime.now(),
      details: description ?? "",
      transactionCurrency: CurrencyType.tl,
    );

    final ok = await _service.addTransaction(newTx);
    if (ok) {
      final fresh = await _service.getTransactions();
      await ref.read(accountProvider.notifier).getAccountSession();

      state = AsyncData(List.unmodifiable(fresh));
    }
  }

  Future<void> updatetx(String id) async {
    final amount = ref.read(amountProvider);
    final category = ref.read(categoryProvider);
    final date = ref.read(dateProvider);
    final description = ref.read(descriptionProvider);
    final currencyType = ref.read(currencyTypeProvider);

    final usdRate = await CurrencyService().getUsdRate();
    final eurRate = await CurrencyService().getEurRate();

    double toTl(double value, CurrencyType c) {
      switch (c) {
        case CurrencyType.tl:
          return value;
        case CurrencyType.usd:
          return usdRate > 0 ? value / usdRate : value;
        case CurrencyType.eur:
          return eurRate > 0 ? value / eurRate : value;
      }
    }

    final updated = Transaction(
      id: id,
      category: category!,
      amount: toTl(amount ?? 0, currencyType),
      date: date ?? DateTime.now(),
      details: description ?? "",
      transactionCurrency: CurrencyType.tl,
    );

    final ok = await _service.updateTransaction(updated);
    if (ok) {
      final fresh = await _service.getTransactions();
      await ref.read(accountProvider.notifier).getAccountSession();

      state = AsyncData(List.unmodifiable(fresh));
    }
  }

  Future<void> delete(String id) async {
    final ok = await _service.deleteTransaction(id);
    if (ok) {
      final fresh = await _service.getTransactions();
      await ref.read(accountProvider.notifier).getAccountSession();

      state = AsyncData(List.unmodifiable(fresh));
    }
  }
}
