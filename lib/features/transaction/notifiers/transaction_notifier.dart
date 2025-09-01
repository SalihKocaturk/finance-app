import 'package:expense_tracker/core/domain/enums/transaction_currency.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/transaction.dart';
import '../providers/transaction_form_providers.dart';

class TransactionNotifier extends Notifier<Transaction> {
  @override
  Transaction build() {
    final transactionCategories = ref.read(transactionCategoriesProvider);
    return Transaction(
      category: transactionCategories.first,
      amount: 0,
      date: DateTime.now(),
      details: '',
      transactionCurrency: CurrencyType.tl,
    );
  }

  Future<void> setTransaction(Transaction t) async {
    state = t;
    ref.read(descriptionProvider.notifier).state = state.details;
    ref.read(categoryProvider.notifier).state = state.category;
    ref.read(amountProvider.notifier).state = state.amount;
    ref.read(dateProvider.notifier).state = state.date;
  }

  Future<void> cleanProviders() async {
    ref.invalidate(amountProvider);
    ref.invalidate(categoryProvider);
    ref.invalidate(dateProvider);
    ref.invalidate(descriptionProvider);
  }

  Future<void> edit() async {}
}
