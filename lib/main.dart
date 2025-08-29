import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/localization/locales.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

import 'app.dart';
import 'core/domain/enums/transaction_currency.dart';
import 'core/providers/currency_provider.dart';
import 'core/services/currency_service.dart';
import 'core/storage/currency_storage.dart';
import 'core/storage/lang_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final savedLang = await LangStorage().readLocale();
  final storage = CurrencyStorage();
  final saved = await storage.readCurrency();

  double initRate = 1.0;
  if (saved == CurrencyType.usd) {
    try {
      initRate = await CurrencyService().getUsdRate();
    } catch (_) {
      initRate = 1.0;
    }
  } else if (saved == CurrencyType.eur) {
    try {
      initRate = await CurrencyService().getEurRate();
    } catch (_) {
      initRate = 1.0;
    }
  }

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: supportedLocales,
      fallbackLocale: const Locale('en'),
      startLocale: savedLang ?? const Locale('en'),
      child: OverlaySupport.global(
        child: ProviderScope(
          overrides: [
            currencyTypeProvider.overrideWith((ref) => saved ?? CurrencyType.tl),
            currencyRateProvider.overrideWith((ref) => initRate),
          ],
          child: const App(),
        ),
      ),
    ),
  );
}
