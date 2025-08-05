import 'package:expense_tracker/features/auth/models/user.dart';
import 'package:hive/hive.dart';

abstract final class HiveConstants {
  static const String userBoxName = 'user_box';
  static Box<User> get userBox => Hive.box<User>(userBoxName);
}
