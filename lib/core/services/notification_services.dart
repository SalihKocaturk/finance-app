import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService pushNotificationService = PushNotificationService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _fm = FirebaseMessaging.instance;
  final _fln = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _txChannel = AndroidNotificationChannel(
    'transactions',
    'Transactions',
    description: 'Transaction notifications',
    importance: Importance.high,
  );

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@drawable/ic_stat_notify');
    const darwinInit = DarwinInitializationSettings();
    await _fln.initialize(
      const InitializationSettings(android: androidInit, iOS: darwinInit),
    );
    if (Platform.isAndroid) {
      final android = _fln.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await android?.createNotificationChannel(_txChannel);
    } else if (Platform.isIOS) {
      await _fm.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    }
    if (Platform.isAndroid) {
      await Permission.notification.request();
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) async {
      final notif = msg.notification;
      final title = notif?.title ?? 'Bildirim';
      final body = notif?.body ?? '';
      await showLocal(title: title, body: body);
    });
  }

  Future<void> registerTokenIfSignedIn() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final token = await _fm.getToken();
    if (token != null) {
      await _saveToken(user.uid, token);
    }
    _fm.onTokenRefresh.listen((newToken) async {
      final u = _auth.currentUser;
      if (u != null) {
        await _saveToken(u.uid, newToken);
      }
    });
  }

  Future<void> unregisterToken() async {
    final u = _auth.currentUser;
    if (u == null) return;
    await _db.collection('users').doc(u.uid).set(
      {'token': FieldValue.delete()},
      SetOptions(merge: true),
    );
  }

  Future<void> _saveToken(String uid, String token) async {
    await _db.collection('users').doc(uid).set({
      'token': token,
      'platform': Platform.operatingSystem,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> showLocal({
    required String title,
    required String body,
    String? payload,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _txChannel.id,
        _txChannel.name,
        channelDescription: _txChannel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await _fln.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
