// lib/core/domain/models/transaction_category.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../enums/transaction_type.dart';

part 'transaction_category.g.dart';

@HiveType(typeId: 4)
class TransactionCategory {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String label;

  @HiveField(2)
  final int iconCodePoint;

  @HiveField(3)
  final String? iconFontFamily;

  @HiveField(4)
  final Color color;

  @HiveField(5)
  final TransactionType type;

  const TransactionCategory({
    required this.id,
    required this.label,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.color,
    required this.type,
  });

  factory TransactionCategory.fromIcon({
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
