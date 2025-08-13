import 'package:expense_tracker/features/transaction/notifiers/transaction_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/transaction.dart' as model;

final transactionProvider = NotifierProvider<TransactionNotifier, model.Transaction?>(
  () => TransactionNotifier(),
);
