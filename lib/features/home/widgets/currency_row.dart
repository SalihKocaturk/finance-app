import 'package:flutter/material.dart';

import 'currency_avatar.dart';

class CurrencyRow extends StatelessWidget {
  const CurrencyRow({super.key, required this.symbol, required this.label});

  final String symbol;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CurrencyAvatar(symbol: symbol),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
