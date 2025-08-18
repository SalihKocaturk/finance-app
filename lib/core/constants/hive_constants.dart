import 'package:expense_tracker/core/domain/models/transaction.dart';
import 'package:expense_tracker/features/auth/models/user.dart';
import 'package:hive/hive.dart';

abstract final class HiveConstants {
  static const String userBoxName = 'user_box';
  static const String transactionBoxName = 'transaction_box';
  static Box<User> get userBox => Hive.box<User>(userBoxName);
  static Box<Transaction> get transactionBox => Hive.box<Transaction>(transactionBoxName);
}
