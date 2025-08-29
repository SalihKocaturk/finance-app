import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/balance.dart';
import '../providers/currency_provider.dart';

extension BalanceExtensions on Balance {
  String uiBalance(WidgetRef ref) {
    final rate = ref.watch(currencyRateProvider);
    return (balance * rate).toStringAsFixed(2);
  }

  String uiIncome(WidgetRef ref) {
    final rate = ref.watch(currencyRateProvider);
    return (income * rate).toStringAsFixed(2);
  }

  String uiExpense(WidgetRef ref) {
    final rate = ref.watch(currencyRateProvider);
    return (expense * rate).toStringAsFixed(2);
  }
}
