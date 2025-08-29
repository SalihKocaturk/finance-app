import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/enums/transaction_type.dart';
import '../../../core/domain/models/transaction_category.dart';
import '../notifiers/transaction_category_notifier.dart';

final transactionCategoriesProvider = NotifierProvider<TransactionCategoriesNotifier, List<TransactionCategory>>(
  () => TransactionCategoriesNotifier(),
);
final categoryNameProvider = StateProvider.autoDispose<String>((ref) => "");

final categoryTypeProvider = StateProvider.autoDispose<TransactionType>((ref) => TransactionType.expense);
