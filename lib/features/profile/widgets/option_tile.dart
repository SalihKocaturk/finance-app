import 'package:flutter/material.dart';

import 'custom_icon_circle.dart';

class OptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBgColor;
  final VoidCallback? onTap;
  final String? subtitle;

  const OptionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.iconBgColor,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomIconCircle(icon: icon, bgColor: iconBgColor),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
