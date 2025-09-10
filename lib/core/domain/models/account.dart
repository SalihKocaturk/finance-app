import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/domain/models/user_account.dart';

import '../enums/transaction_type.dart';
import 'transaction.dart';

class Account extends Equatable {
  final String? id;
  final List<UserAccount>? accounts;
  final List<Transaction>? transactions;
  final int shareId;

  Account({
    this.id,
    this.accounts,
    this.transactions,
    int? shareId,
  }) : shareId = shareId ?? Random().nextInt(1000000);

  double get totalIncome => (transactions ?? [])
      .where((t) => t.category.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => (transactions ?? [])
      .where((t) => t.category.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  int get countIncome => (transactions ?? []).where((t) => t.category.type == TransactionType.income).length;
  int get countExpense => (transactions ?? []).where((t) => t.category.type == TransactionType.expense).length;
  double get netBalance => totalIncome - totalExpense;

  @override
  List<Object?> get props => [
    id,
    accounts,
    transactions,
    shareId,
  ];
}
