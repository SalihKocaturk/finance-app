import 'package:flutter/material.dart';

class CustomIconDesign extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final EdgeInsets? padding;

  const CustomIconDesign({
    super.key,
    required this.icon,
    required this.bgColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
