import 'package:expense_tracker/core/domain/enums/transaction_type.dart';
import 'package:flutter/material.dart';

class TransactionCategory {
  final int id;
  final String label;
  final IconData icon;
  final Color color;
  final TransactionType type;

  const TransactionCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.type,
  });
}
