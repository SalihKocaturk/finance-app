import 'package:flutter/material.dart';

class CurrencyAvatar extends StatelessWidget {
  const CurrencyAvatar({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: Colors.black87,
      child: Text(
        symbol,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
