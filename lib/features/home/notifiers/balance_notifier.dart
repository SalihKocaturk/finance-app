import 'package:expense_tracker/core/domain/enums/transaction_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/balance.dart';
import '../../../core/domain/models/transaction.dart';
import '../../transaction/providers/transaction_list_provider.dart';

class BalanceNotifier extends Notifier<Balance> {
  @override
  Balance build() {
    final transactions = ref.watch(transactionListProvider);
    return _calcBalance(transactions.value ?? []);
  }

  Balance _calcBalance(List<Transaction> transactions) {
    double income = 0, expense = 0;
    for (final t in transactions) {
      final isIncome = (t.category.type == TransactionType.income);
      if (isIncome) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    return Balance(income: income, expense: expense);
  }
}
