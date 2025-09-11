// core/extensions/user_account_permission.dart
import '../domain/enums/user_type.dart';
import '../domain/models/user_account.dart';

extension UserAccountPermission on UserAccount {
  bool get canManageAccount => type == UserType.owner;
  bool get canManageTransactions => type == UserType.owner || type == UserType.mod;
  bool get canAddOnly => type == UserType.member;
}
