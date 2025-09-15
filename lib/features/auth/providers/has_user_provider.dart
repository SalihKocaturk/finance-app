import 'package:expense_tracker/core/storage/user_storage.dart';
import 'package:riverpod/riverpod.dart';

final hasUserProvider = FutureProvider<bool>((ref) async {
  final isLoggedIn = await UserStorage().isLoggedIn();
  return isLoggedIn;
});
