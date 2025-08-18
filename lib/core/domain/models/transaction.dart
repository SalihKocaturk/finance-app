import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/domain/models/transaction_category.dart';
import 'package:expense_tracker/core/services/services.dart';
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 3)
class Transaction extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final TransactionCategory category;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
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
