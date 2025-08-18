import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/entities/transaction_categories.dart';
import '../../../core/domain/enums/transaction_type.dart'; // TransactionType enum dosyan
import '../../../core/domain/models/transaction_category.dart';

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

    return DropdownButtonFormField<TransactionCategory>(
      value: safeValue,
      items: items,
      isExpanded: true,
      onChanged: onChanged,
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.withAlpha(180)),
      hint: Text(hint, style: const TextStyle(color: Color(0xFF999999), fontSize: 15)),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always, // label hep yukarıda
        label: Text(label),
        filled: true,
        fillColor: const Color(0xFFFCFCFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: leadingIcon != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
                child: Icon(leadingIcon, size: 22, color: Colors.black),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDBDFE9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDBDFE9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDBDFE9)),
        ),
      ),
    );
  }
}
