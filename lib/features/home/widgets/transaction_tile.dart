import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final Color color;
  final IconData? icon;
  final String? imageUrl;

  const TransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
    this.icon,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: imageUrl != null
            ? CircleAvatar(backgroundImage: NetworkImage(imageUrl!))
            : CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(icon, color: Colors.white),
              ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        amount,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
