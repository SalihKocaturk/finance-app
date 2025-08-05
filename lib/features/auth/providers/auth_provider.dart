import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../notifiers/auth_notifier.dart';

final authProvider = NotifierProvider<AuthNotifier, User>(
  () => AuthNotifier(),
);
