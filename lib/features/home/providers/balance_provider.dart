import 'package:riverpod/riverpod.dart';

import '../../../core/domain/models/balance.dart';
import '../notifiers/balance_notifier.dart';

final balanceProvider = NotifierProvider<BalanceNotifier, Balance>(BalanceNotifier.new);
