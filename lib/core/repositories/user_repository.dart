import '../../features/auth/models/user.dart';
import '../constants/hive_constants.dart';

class UserRepository {
  final _userBox = HiveConstants.userBox;
  Future<void> addUser(User user) async {
    await _userBox.put(user.id, user);
  }
}
