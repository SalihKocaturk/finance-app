import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/domain/enums/transaction_category.dart';
import 'package:expense_tracker/core/services/services.dart';

class Transaction extends Equatable {
  final String id;
  final TransactionCategory category;
  final double amount;
  final DateTime date;
  final String details;

  Transaction({
    String? id,
    required this.category,
    required this.amount,
    required this.date,
    required this.details,
  }) : id = id ?? uuid;

  @override
  List<Object?> get props => [id, category, amount, date, details];
}
