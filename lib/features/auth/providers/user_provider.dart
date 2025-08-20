import 'package:expense_tracker/core/repositories/user_repository.dart';
import 'package:riverpod/riverpod.dart';

import '../models/user.dart';

//bu da user olup olmadığını donen booleandır
final hasUserProvider = FutureProvider<bool>((ref) async {
  final user = await UserRepository().getUser();

  return user != null;
});
//bu elimizdeki useri döner
final userProvider = FutureProvider<User?>((ref) async {
  final user = await UserRepository().getUser();

  if (user != null) {
    print(user);
    return user;
  } else {
    print("usernull");
    return null;
  }
});
