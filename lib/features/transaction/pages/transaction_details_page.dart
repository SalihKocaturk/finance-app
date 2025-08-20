import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/toast.dart';
import '../../../core/widgets/custom_date_picker.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/pop_page_button.dart';
import '../providers/transaction_form_providers.dart';
import '../providers/transaction_list_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/category_dropdown_picker.dart';

class TransactionDetailsPage extends ConsumerWidget {
  final int modeIndex;
  const TransactionDetailsPage({
    super.key,
    required this.modeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryProvider);
    final date = ref.watch(dateProvider);
    final transactionListNotifier = ref.read(transactionListProvider.notifier);
    final amount = ref.watch(amountProvider);
    final transaction = ref.read(transactionProvider);

    final description = ref.watch(descriptionProvider);
    final canSave = category != null && date != null && description != null && amount != 0.00 && amount != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            PopPageButton(
              onTap: () {
                ref.read(transactionProvider.notifier).cleanProviders();

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const Gap(3),
            CustomTextField(
              label: "amount",
              hintText: '₺0.00',
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
            CategoryDropdownField(
              label: 'Category',
              hint: 'Choose Category',
              modeIndex: modeIndex,
              leadingIcon: Icons.category,
              value: category,
              onChanged: (val) => ref.read(categoryProvider.notifier).state = val,
            ),

            const Gap(17),
            CustomDateField(
              label: 'Date',
              hint: 'DD.MM.YYYY',
              value: date,
              onChanged: (val) => ref.read(dateProvider.notifier).state = val,
            ),
            const Gap(17),
            CustomTextField(
              label: "Description",
              initialValue: description,
              hintText: 'optional description',
              isPassword: false,
              maxLine: 3,
              onChanged: (val) => ref.read(descriptionProvider.notifier).state = val,
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: canSave
                    ? () {
                        transactionListNotifier.save(modeIndex == 2 ? transaction.id : null);
                        Navigator.of(context).pop();
                      }
                    : null,
                icon: const Icon(Icons.check),
                label: const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
