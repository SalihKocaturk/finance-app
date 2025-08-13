import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/entities/transaction_categories.dart';
import '../../../core/domain/enums/transaction_category.dart';
import '../../../core/domain/enums/transaction_type.dart'; // TransactionType enum dosyan

class CategoryDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final int modeIndex; // 0: gelir, 1: gider, 2: tümü
  final IconData? leadingIcon;
  final TransactionCategory? value;
  final ValueChanged<TransactionCategory?>? onChanged;

  const CategoryDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.modeIndex,
    this.leadingIcon,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = transactionCategories.where((transaction) {
      if (modeIndex == 0) return transaction.type == TransactionType.income;
      if (modeIndex == 1) return transaction.type == TransactionType.expense;
      return true;
    }).toList();
    //önceden riverpodda kalan değer listede bulunmöadıgından dolayı hata alınıyor bundan dolayı safevalueeya çekiyoruz
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: Colors.grey.withAlpha(60)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              if (leadingIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(leadingIcon, size: 22, color: Colors.grey.withAlpha(180)),
                ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TransactionCategory>(
                    value: safeValue,
                    isExpanded: true,
                    items: items,
                    hint: Text(hint, style: const TextStyle(color: Color(0xFF999999), fontSize: 15)),
                    onChanged: onChanged,
                    dropdownColor: Colors.white,
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.withAlpha(180)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
