import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredIconCircle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  const BlurredIconCircle({super.key, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      //clipoval duzeltilecek
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
