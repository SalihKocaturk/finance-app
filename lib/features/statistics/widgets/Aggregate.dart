import '../../../core/domain/models/transaction_category.dart';

class Aggregate {
  final double sum;
  final TransactionCategory category;
  Aggregate(this.sum, this.category);
  Aggregate copyWith({double? sum, TransactionCategory? category}) =>
      Aggregate(sum ?? this.sum, category ?? this.category);
}
