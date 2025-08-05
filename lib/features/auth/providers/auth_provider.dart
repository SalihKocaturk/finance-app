import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../notifiers/auth_notifier.dart';

final nameProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');
final password2Provider = StateProvider<String>((ref) => '');
final isLoginProvider = StateProvider<bool>((ref) => true);
final userProvider = NotifierProvider<UserNotifier, User>(
  () => UserNotifier(),
);
