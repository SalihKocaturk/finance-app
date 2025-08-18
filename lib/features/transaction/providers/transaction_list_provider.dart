import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/transaction.dart';
import '../notifiers/transaction_list_notifier.dart';

final transactionListProvider = NotifierProvider<TransactionListNotifier, List<Transaction>>(
  () => TransactionListNotifier(),
);
