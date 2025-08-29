import 'package:riverpod/riverpod.dart';

import '../domain/enums/transaction_currency.dart';

final currencyTypeProvider = StateProvider<CurrencyType>((ref) => CurrencyType.tl);
final currencyRateProvider = StateProvider<double>((ref) => 0.0);
