import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/enums/transaction_type.dart';
import '../../../core/domain/models/transaction_category.dart';

class CategoryDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final TransactionType? filterType;
  final IconData? leadingIcon;
  final TransactionCategory? value;
  final List<TransactionCategory> transactionCategories;
  final ValueChanged<TransactionCategory?>? onChanged;

  const CategoryDropdownField({
    super.key,
    required this.label,
    required this.hint,
    this.filterType,
    this.leadingIcon,
    this.value,
    required this.transactionCategories,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = filterType == null
        ? transactionCategories
        : transactionCategories.where((transaction) => transaction.type == filterType).toList();

    final safeValue = (value != null && filtered.contains(value)) ? value : null;

    final items = filtered.map((transaction) {
      return DropdownMenuItem<TransactionCategory>(
        value: transaction,
        child: Row(
          children: [
            Icon(transaction.icon, color: transaction.color, size: 18),
            const Gap(8),
            Text(transaction.label),
          ],
        ),
      );
    }).toList();

    return DropdownButtonFormField<TransactionCategory>(
      value: safeValue,
      items: items,
      isExpanded: true,
      onChanged: onChanged,
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.withAlpha(180)),
      hint: Text(
        hint,
        style: const TextStyle(color: Color(0xFF999999), fontSize: 15),
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(label),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
