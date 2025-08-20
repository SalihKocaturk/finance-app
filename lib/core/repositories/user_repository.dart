import '../../features/auth/models/user.dart';
import '../constants/hive_constants.dart';

class UserRepository {
  final _userBox = HiveConstants.userBox;
  Future<void> setUser(User user) async {
    await _userBox.put("current_user", user);
  }

  Future<User?> getUser() async {
    final userdata = _userBox.get("current_user");
    print(userdata);
    if (userdata != null) {
      return userdata;
    } else {
      return null;
    }
  }

  Future<void> removeUser() async {
    await _userBox.clear();
  }
}
