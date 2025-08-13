import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final Color color;
  final IconData? icon;
  final String? imageUrl;
  final double avatarSize;

  const TransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
    this.icon,
    this.imageUrl,
    this.avatarSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = avatarSize * 0.5;

    return ListTile(
      leading: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(30),
          borderRadius: BorderRadius.circular(avatarSize / 3),
        ),
        padding: EdgeInsets.all(avatarSize * 0.1),
        child: imageUrl != null
            ? CircleAvatar(
                radius: avatarSize / 2,
                backgroundImage: NetworkImage(imageUrl!),
              )
            : CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: Colors.black,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: iconSize,
                ),
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
