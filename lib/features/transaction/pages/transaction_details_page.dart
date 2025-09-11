import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/extensions/user_account_permission.dart';
import 'package:expense_tracker/core/providers/currency_provider.dart';
import 'package:expense_tracker/core/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/toast.dart';
import '../../../core/domain/enums/alert_type.dart';
import '../../../core/domain/enums/transaction_currency.dart';
import '../../../core/domain/enums/transaction_type.dart';
import '../../../core/domain/enums/user_type.dart';
import '../../../core/domain/models/user_account.dart';
import '../../../core/localization/locale_keys.g.dart';
import '../../../core/widgets/custom_date_picker.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/pop_page_button.dart';
import '../../auth/providers/account_provider.dart';
import '../providers/transaction_category_provider.dart';
import '../providers/transaction_form_providers.dart';
import '../providers/transaction_list_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/category_dialog.dart' show CategoryDialog;
import '../widgets/category_dropdown_picker.dart';

class TransactionDetailsPage extends ConsumerWidget {
  final bool isEdit;
  const TransactionDetailsPage({
    super.key,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryProvider);
    final date = ref.watch(dateProvider);
    final amount = ref.watch(amountProvider);
    final transaction = ref.read(transactionProvider);
    final currencyType = ref.read(currencyTypeProvider);
    final description = ref.watch(descriptionProvider);
    final transactionListNotifier = ref.read(transactionListProvider.notifier);
    final transactionCategories = ref.read(transactionCategoriesProvider);
    final categoryName = ref.watch(categoryNameProvider);
    final transactionType = ref.watch(transactionTypeProvider);
    final canSave = category != null && date != null && description != null && amount != null && amount != 0.0;
    final account = ref.watch(accountProvider).valueOrNull;
    final currentUid = firebase.FirebaseAuth.instance.currentUser?.uid;
    final me = account?.accounts?.firstWhere(
      (u) => u.id == currentUid,
      orElse: () => const UserAccount(type: UserType.member),
    );
    final canManageTx = me?.canManageTransactions ?? false;
    final canAddOnly = me?.canAddOnly ?? false;
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
              final parsed = double.tryParse(value.replaceAll(',', '.'));
              if (parsed != null) {
                ref.read(amountProvider.notifier).state = parsed;
              } else {
                ref.read(amountProvider.notifier).state = null;
                showToast(
                  LocaleKeys.enter_valid_number.tr().capitalizeFirst(),
                  AlertType.fail,
                );
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
                  filterType: transactionType,
                  leadingIcon: Icons.category,
                  value: category,
                  transactionCategories: transactionCategories,
                  onChanged: (val) => ref.read(categoryProvider.notifier).state = val,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  ref.read(categoryNameProvider.notifier).state = "";

                  showDialog(
                    context: context,
                    builder: (_) {
                      return CategoryDialog(
                        title: LocaleKeys.new_category.tr().capitalizeFirst(),
                        name: categoryName,
                        type: transactionType ?? TransactionType.expense,
                        onNameChanged: (v) => ref.read(categoryNameProvider.notifier).state = v,
                        onCancel: () {
                          ref.invalidate(transactionTypeProvider);
                          Navigator.of(context).pop();
                        },
                        onSave: () {
                          if (categoryName == "") {
                            return;
                          } else {
                            final trimmed = ref.read(categoryNameProvider).trim();
                            final currentType = ref.read(transactionTypeProvider);
                            if (trimmed.isEmpty) return;

                            final newCategory = ref
                                .read(transactionCategoriesProvider.notifier)
                                .add(name: trimmed, type: currentType ?? TransactionType.expense);

                            ref.read(categoryProvider.notifier).state = newCategory;

                            Navigator.of(context).pop();
                          }
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
            hintText: LocaleKeys.date_hint.tr().capitalizeFirst(),
            initialValue: date,
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
            canSave: isEdit && !canManageTx ? false : canSave,
            onTap: () async {
              if (isEdit == true && canManageTx) {
                await transactionListNotifier.updatetx(transaction.id);
              }
              if (isEdit == false) {
                await transactionListNotifier.add();
              } else {}
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
