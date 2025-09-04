import 'package:expense_tracker/core/storage/user_storage.dart';
import 'package:riverpod/riverpod.dart';

//bu da user olup olmadığını donen booleandır
final hasUserProvider = FutureProvider<bool>((ref) async {
  final isLoggedIn = await UserStorage().isLoggedIn();
  return isLoggedIn;
});
//bu elimizdeki useri döner
// final userProvider = FutureProvider<User?>((ref) async {
//   final user = await UserStorage().get();

//   if (user != null) {
//     return user;
//   } else {
//     return null;
//   }
// });
