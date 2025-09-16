import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/localization/locales.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

import 'app.dart';
import 'core/domain/enums/transaction_currency.dart';
import 'core/providers/currency_provider.dart';
import 'core/services/currency_service.dart';
import 'core/services/notification_services.dart';
import 'core/storage/currency_storage.dart';
import 'core/storage/lang_storage.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final n = message.notification;
  if (n != null && (Platform.isAndroid || Platform.isIOS)) {
    await PushNotificationService.pushNotificationService.showLocal(
      title: n.title ?? 'Bildirim',
      body: n.body ?? '',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final savedLang = await LangStorage().readLocale();
  final storage = CurrencyStorage();
  final saved = await storage.readCurrency();
  await PushNotificationService.pushNotificationService.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final n = message.notification;
    if (n != null) {
      await PushNotificationService.pushNotificationService.showLocal(
        title: n.title ?? 'Yeni bildirim',
        body: n.body ?? '',
      );
    }
  });
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
