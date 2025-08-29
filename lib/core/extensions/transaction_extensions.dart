import 'package:expense_tracker/core/domain/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/currency_provider.dart';

extension TransactionExtensions on Transaction {
  String uiPrice(WidgetRef ref) {
    final rate = ref.watch(currencyRateProvider);
    return (amount * rate).toStringAsFixed(2);
  }
}
