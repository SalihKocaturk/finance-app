import 'package:expense_tracker/core/domain/models/transaction_category.dart';
import 'package:riverpod/riverpod.dart';

final amountProvider = StateProvider<double?>(
  (ref) => null,
);
final categoryProvider = StateProvider<TransactionCategory?>(
  (ref) => null,
);
final dateProvider = StateProvider<DateTime?>(
  (ref) => null,
);
final descriptionProvider = StateProvider<String?>(
  (ref) => "",
);
