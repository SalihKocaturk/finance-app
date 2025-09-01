import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/widgets/custom_button.dart';
import 'package:expense_tracker/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/enums/transaction_type.dart';
import '../../../core/localization/locale_keys.g.dart';

class CategoryDialog extends StatelessWidget {
  final String title;
  final String name;
  final TransactionType type;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const CategoryDialog({
    super.key,
    required this.title,
    required this.name,
    required this.type,
    required this.onNameChanged,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                type == TransactionType.expense ? "Gider Ekle" : "Gelir Ekle",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Gap(16),
              CustomTextField(
                label: "Kategori Adı",
                hintText: "Örn: Market",
                onChanged: onNameChanged,
              ),

              const Gap(16),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      color: Colors.red,
                      icon: Icons.cancel,
                      text: LocaleKeys.cancel.tr().capitalizeFirst(),
                      onTap: onCancel,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      color: Colors.blue,
                      icon: Icons.check,
                      text: LocaleKeys.add.tr().capitalizeFirst(),
                      onTap: onSave,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
