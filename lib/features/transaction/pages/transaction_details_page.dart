import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/providers/currency_provider.dart';
import 'package:expense_tracker/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/toast.dart';
import '../../../core/domain/enums/transaction_currency.dart';
import '../../../core/domain/enums/transaction_type.dart';
import '../../../core/localization/locale_keys.g.dart';
import '../../../core/widgets/custom_date_picker.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/pop_page_button.dart';
import '../providers/transaction_category_provider.dart';
import '../providers/transaction_form_providers.dart';
import '../providers/transaction_list_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/category_dialog.dart' show CategoryDialog;
import '../widgets/category_dropdown_picker.dart';

class TransactionDetailsPage extends ConsumerWidget {
  final int isEdit;
  const TransactionDetailsPage({
    super.key,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryProvider);
    final date = ref.watch(dateProvider);
    final transactionListNotifier = ref.read(transactionListProvider.notifier);
    final amount = ref.watch(amountProvider);
    final transaction = ref.read(transactionProvider);
    final currencyType = ref.read(currencyTypeProvider);
    final description = ref.watch(descriptionProvider);
    final canSave = category != null && date != null && description != null && amount != 0.00 && amount != null;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        leading: Row(
          children: [
            CustomAppbarButton(
              onTap: () {
                Navigator.of(context).pop();
                ref.read(transactionProvider.notifier).cleanProviders();
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Gap(3),
          CustomTextField(
            label: LocaleKeys.amount.tr().capitalizeFirst(),
            hintText: '${currencyType == CurrencyType.tl ? "₺" : (currencyType == CurrencyType.eur ? "€" : "\$")}0.00',
            inputType: TextInputType.number,
            onChanged: (value) {
              final parsedValue = double.tryParse(value);
              if (parsedValue != null) {
                ref.read(amountProvider.notifier).state = parsedValue;
              } else {
                ref.read(amountProvider.notifier).state = parsedValue;
                showToast('Lütfen geçerli bir sayı giriniz');
              }
            },
          ),

          const Gap(17),
          Row(
            children: [
              Expanded(
                child: CategoryDropdownField(
                  label: LocaleKeys.category.tr().capitalizeFirst(),
                  hint: LocaleKeys.choose_category.tr().capitalizeFirst(),
                  modeIndex: isEdit,
                  leadingIcon: Icons.category,
                  value: category,
                  onChanged: (val) => ref.read(categoryProvider.notifier).state = val,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // dialog açılmadan önce reset (opsiyonel)
                  ref.read(categoryNameProvider.notifier).state = "";
                  ref.read(categoryTypeProvider.notifier).state = TransactionType.expense;
                  final name = ref.watch(categoryNameProvider);
                  final type = ref.watch(categoryTypeProvider);
                  showDialog(
                    context: context,
                    builder: (_) {
                      return CategoryDialog(
                        title: 'Yeni Kategori',
                        name: name,
                        type: type,
                        onNameChanged: (v) => ref.read(categoryNameProvider.notifier).state = v,
                        onTypeChanged: (t) => ref.read(categoryTypeProvider.notifier).state = t,
                        onCancel: () {
                          ref.invalidate(categoryNameProvider);
                          ref.invalidate(categoryTypeProvider);
                          Navigator.of(context).pop();
                        },
                        onSave: () {
                          final trimmed = name.trim();
                          if (trimmed.isEmpty) return;

                          final newCategory = ref
                              .read(transactionCategoriesProvider.notifier)
                              .add(name: trimmed, type: type);

                          ref.read(categoryProvider.notifier).state = newCategory;

                          ref.invalidate(categoryNameProvider);
                          ref.invalidate(categoryTypeProvider);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),

          const Gap(17),
          CustomDateField(
            label: LocaleKeys.date.tr().capitalizeFirst(),
            hint: LocaleKeys.date_hint.tr().capitalizeFirst(),
            value: date,
            onChanged: (val) => ref.read(dateProvider.notifier).state = val,
          ),
          const Gap(17),
          CustomTextField(
            label: LocaleKeys.description.tr().capitalizeFirst(),
            initialValue: description,
            hintText: LocaleKeys.optional_description.tr().capitalizeFirst(),
            isPassword: false,
            maxLine: 3,
            onChanged: (val) => ref.read(descriptionProvider.notifier).state = val,
          ),

          const SizedBox(height: 24),
          CustomButton(
            color: Colors.blue,
            icon: Icons.check,
            text: LocaleKeys.save.tr().capitalizeFirst(),
            canSave: canSave,
            onTap: () {
              transactionListNotifier.save(isEdit == 2 ? transaction.id : null);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
