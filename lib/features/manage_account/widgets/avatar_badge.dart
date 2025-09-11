import 'package:flutter/material.dart';

class AvatarBadge extends StatelessWidget {
  final String text;
  const AvatarBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.blue.shade100,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.blue),
      ),
    );
  }
}
