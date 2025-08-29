import 'package:expense_tracker/core/domain/entities/transaction_categories.dart';
import 'package:expense_tracker/core/domain/enums/transaction_currency.dart';
import 'package:expense_tracker/core/providers/currency_provider.dart';
import 'package:expense_tracker/core/services/currency_service.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_form_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/transaction.dart';

class TransactionListNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() {
    return [];
  }

  Future<void> save(String? id) async {
    final amount = ref.read(amountProvider);
    final category = ref.read(categoryProvider);
    final date = ref.read(dateProvider);
    final description = ref.read(descriptionProvider);
    final currencyType = ref.read(currencyTypeProvider);

    final usdRate = await CurrencyService().getUsdRate();
    final eurRate = await CurrencyService().getEurRate();

    double toTl(double amount, CurrencyType ct) {
      switch (ct) {
        case CurrencyType.tl:
          return amount;
        case CurrencyType.usd:
          return usdRate > 0 ? amount / usdRate : amount;
        case CurrencyType.eur:
          return eurRate > 0 ? amount / eurRate : amount;
      }
    }

    final amountTl = toTl(amount ?? 0, currencyType);
    if (id == null) {
      final newTx = Transaction(
        category: category ?? transactionCategories.first,
        amount: amountTl,
        date: date ?? DateTime.now(),
        details: description ?? "",
        transactionCurrency: CurrencyType.tl,
      );
      state = [...state, newTx];
    } else {
      final idx = state.indexWhere((t) => t.id == id);
      if (idx != -1) {
        final old = state[idx];
        final updated = Transaction(
          id: old.id,
          category: category ?? old.category,
          amount: amount ?? 0,
          date: date ?? old.date,
          details: description ?? old.details,
          transactionCurrency: old.transactionCurrency,
        );
        final list = [...state];
        list[idx] = updated;
        state = list;
      }
    }

    ref.invalidate(amountProvider);
    ref.invalidate(categoryProvider);
    ref.invalidate(dateProvider);
    ref.invalidate(descriptionProvider);

    debugPrint('Kayıt başarılı: $state');
  }

  Future<void> delete(String id) async {
    state = state.where((t) => t.id != id).toList(growable: false);
  }

  // Future<void> convertAllCurrencies({
  //   required TransactionCurrency currency,
  // }) async {
  //   final updated = <Transaction>[];
  //   final double usdTryRate = await CurrencyService().getRate();
  //   for (final transaction in state) {
  //     if (transaction.transactionCurrency == currency) {
  //       updated.add(transaction);
  //       continue;
  //     }

  //     // double newAmount;
  //     // if (currency == TransactionCurrency.usd && transaction.transactionCurrency == TransactionCurrency.tl) {
  //     //   newAmount = transaction.amount / usdTryRate;
  //     // } else if (currency == TransactionCurrency.tl && transaction.transactionCurrency == TransactionCurrency.usd) {
  //     //   newAmount = transaction.amount * usdTryRate;
  //     // } else {
  //     //   newAmount = transaction.amount;
  //     // }

  //     updated.add(
  //       transaction.copyWith(
  //         // amount: double.parse(newAmount.toStringAsFixed(2)),
  //         transactionCurrency: currency,
  //       ),
  //     );
  //   }

  //   state = updated;
  // }
}
