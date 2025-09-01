import 'package:flutter/material.dart';

import '../enums/transaction_type.dart';

class TransactionCategory {
  final int id;

  final String label;

  final int iconCodePoint;

  final String? iconFontFamily;

  final Color color;

  final TransactionType type;

  const TransactionCategory({
    required this.id,
    required this.label,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.color,
    required this.type,
  });

  factory TransactionCategory.rename({
    required int id,
    required String label,
    required IconData icon,
    required Color color,
    required TransactionType type,
  }) {
    return TransactionCategory(
      id: id,
      label: label,
      iconCodePoint: icon.codePoint,
      iconFontFamily: icon.fontFamily,
      color: color,
      type: type,
    );
  }

  IconData get icon => IconData(iconCodePoint, fontFamily: iconFontFamily);
}
