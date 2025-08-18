import 'package:expense_tracker/features/transaction/providers/transaction_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/transaction.dart';
import '../notifiers/transaction_notifier.dart' show TransactionNotifier;

final transactionFromIdProvider = Provider.family<Transaction, String>((ref, id) {
  final list = ref.watch(transactionListProvider);

  return list.firstWhere(
    (t) => t.id == id,
  );
});
final transactionProvider = NotifierProvider<TransactionNotifier, Transaction>(
  () => TransactionNotifier(),
);
