import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/account.dart';
import '../providers/currency_provider.dart';

extension AccountExtensions on Account {
  String uiIncome(WidgetRef ref) {
    final rate = ref.watch(currencyRateProvider);
    return (totalIncome * rate).toStringAsFixed(2);
  }

  String uiExpense(WidgetRef ref) {
    final rate = ref.watch(currencyRateProvider);
    return (totalExpense * rate).toStringAsFixed(2);
  }

  String uiBalance(WidgetRef ref) {
    final rate = ref.watch(currencyRateProvider);
    return (netBalance * rate).toStringAsFixed(2);
  }
}
