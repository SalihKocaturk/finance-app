import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String valueText;
  const LegendRow({super.key, required this.color, required this.label, required this.valueText});
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const Gap(8),
        Flexible(
          child: Text(label, style: style, overflow: TextOverflow.ellipsis),
        ),
        const Gap(6),
        Text(valueText, style: style?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
