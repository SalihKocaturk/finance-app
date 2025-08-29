import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/domain/enums/transaction_currency.dart';
import 'package:expense_tracker/core/domain/models/transaction_category.dart';
import 'package:expense_tracker/core/services/services.dart';

class Transaction extends Equatable {
  final String id;

  final TransactionCategory category;

  final double amount;

  final DateTime date;

  final String details;

  final CurrencyType transactionCurrency;

  Transaction({
    String? id,
    required this.category,
    required this.amount,
    required this.date,
    required this.details,
    required this.transactionCurrency,
  }) : id = id ?? uuid;

  @override
  List<Object?> get props => [id, category, amount, date, details, transactionCurrency];

  Transaction copyWith({
    String? id,
    TransactionCategory? category,
    double? amount,
    DateTime? date,
    String? details,
    CurrencyType? transactionCurrency,
  }) {
    return Transaction(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      details: details ?? this.details,
      transactionCurrency: transactionCurrency ?? this.transactionCurrency,
    );
  }
}
