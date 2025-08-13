import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredIconCircle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  const BlurredIconCircle({
    super.key,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ),
      ),
    );
  }
}
