import 'package:expense_tracker/core/storage/user_storage.dart';
import 'package:riverpod/riverpod.dart';

import '../models/user.dart';

//bu da user olup olmadığını donen booleandır
final hasUserProvider = FutureProvider<bool>((ref) async {
  final user = await UserStorage().get();

  return user != null;
});
//bu elimizdeki useri döner
final userProvider = FutureProvider<User?>((ref) async {
  final user = await UserStorage().get();

  if (user != null) {
    print(user);
    return user;
  } else {
    print("usernull");
    return null;
  }
});
