import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../domain/enums/alert_type.dart';

void showToast(String message, AlertType type) {
  Color bgColor;

  switch (type) {
    case AlertType.success:
      bgColor = Colors.green;
      break;
    case AlertType.fail:
      bgColor = Colors.red;
      break;
    case AlertType.info:
      bgColor = Colors.blue;
  }

  showOverlayNotification(
    (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 15,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
    position: NotificationPosition.top,
    duration: const Duration(seconds: 2),
  );
}
