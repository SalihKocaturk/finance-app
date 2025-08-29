import 'package:flutter/material.dart';

class LangTile extends StatelessWidget {
  const LangTile({super.key, required this.flag, required this.label});
  final String flag;
  final String label;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(flag, style: style),
        const SizedBox(width: 8),
        Text(label, style: style),
      ],
    );
  }
}
