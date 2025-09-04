import 'package:riverpod/riverpod.dart';

import '../../../core/domain/models/account.dart';
import '../notifiers/account_notifier.dart';

final accountProvider = AsyncNotifierProvider<AccountNotifier, Account?>(AccountNotifier.new);
