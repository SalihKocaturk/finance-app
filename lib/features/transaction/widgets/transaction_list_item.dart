import 'package:flutter/material.dart';

import '../../settings/widgets/custom_icon_circle.dart';

class TransactionListItem extends StatelessWidget {
  final String title;
  final String dateText;
  final String amountText;
  final bool isIncome;
  final IconData icon;
  final Color iconBg;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.title,
    required this.dateText,
    required this.amountText,
    required this.isIncome,
    required this.icon,
    required this.iconBg,
    this.onTap,
  });
  //TODO: dismissable kullanılacak
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomIconCircle(icon: icon, bgColor: iconBg),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(dateText),
      trailing: Text(
        amountText,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isIncome ? Colors.green : Colors.red,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
