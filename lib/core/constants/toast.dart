import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

void showToast({required String message}) {
  showSimpleNotification(
    Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    background: Colors.red,
    duration: const Duration(seconds: 2),
    elevation: 2,
    slideDismissDirection: DismissDirection.down,
    position: NotificationPosition.bottom,
  );
}
