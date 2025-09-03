import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/models/user.dart';
import '../notifiers/user_notifier.dart';

final userProvider = AsyncNotifierProvider<UserNotifier, User?>(UserNotifier.new);
