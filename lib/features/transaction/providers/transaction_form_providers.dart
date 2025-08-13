import 'package:expense_tracker/core/domain/enums/transaction_category.dart';
import 'package:riverpod/riverpod.dart';

final amountProvider = StateProvider<double>(
  (ref) => 0.0,
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
