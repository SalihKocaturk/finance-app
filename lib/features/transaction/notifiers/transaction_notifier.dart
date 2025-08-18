import 'package:expense_tracker/core/domain/entities/transaction_categories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/transaction.dart';
import '../providers/transaction_form_providers.dart';

class TransactionNotifier extends Notifier<Transaction> {
  @override
  Transaction build() {
    return Transaction(
      category: transactionCategories.first,
      amount: 0,
      date: DateTime.now(),
      details: '',
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
