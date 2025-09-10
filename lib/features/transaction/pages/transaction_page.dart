import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/constants/toast.dart';
import 'package:expense_tracker/core/domain/enums/transaction_type.dart';
import 'package:expense_tracker/core/extensions/date_extensions.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/extensions/transaction_extensions.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_category_provider.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_provider.dart';
import 'package:expense_tracker/features/transaction/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/domain/enums/alert_type.dart';
import '../../../core/localization/locale_keys.g.dart';
import '../../../core/widgets/action_card.dart';
import '../../../core/widgets/sheets/no_data_widget.dart';
import '../providers/transaction_list_provider.dart';
import 'transaction_details_page.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionListAsync = ref.watch(transactionListProvider);
    final transactionList = transactionListAsync.value ?? [];
    final transactionListNotifier = ref.read(transactionListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.transactions.tr().capitalizeFirst()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: ActionCard(
                      title: LocaleKeys.add_income.tr().capitalizeFirst(),
                      icon: Icons.savings_rounded,
                      bg: const Color(0xFF7E57C2),
                    ),
                    onTap: () {
                      ref.read(transactionTypeProvider.notifier).state = TransactionType.income;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TransactionDetailsPage(isEdit: 0),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 12)),
                Expanded(
                  child: GestureDetector(
                    child: ActionCard(
                      title: LocaleKeys.add_expense.tr().capitalizeFirst(),
                      icon: Icons.shopping_bag_rounded,
                      bg: const Color(0xFFF57C00),
                    ),
                    onTap: () {
                      ref.read(transactionTypeProvider.notifier).state = TransactionType.expense;

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TransactionDetailsPage(isEdit: 1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 8),
              child: Text(
                LocaleKeys.recent_added.tr().capitalizeFirst(),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (transactionList.isEmpty) const NoDataWidget(),
            Expanded(
              child: ListView.builder(
                itemCount: transactionList.length,
                itemBuilder: (context, index) {
                  var transaction = transactionList[index];

                  return Slidable(
                    key: ValueKey(transaction.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.20,
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            transactionListNotifier.delete(transaction.id);
                            showToast(
                              '${transaction.category.label} ${LocaleKeys.deleted.tr().capitalizeFirst()}',
                              AlertType.success,
                            );
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,

                          icon: Icons.delete,
                          label: LocaleKeys.delete.tr().capitalizeFirst(),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      child: TransactionListItem(
                        title: transaction.category.label,
                        dateText: transaction.date.formatAsDMY(),
                        amountText: transaction.uiPrice(ref),
                        isIncome: transaction.category.type == TransactionType.income,
                        icon: transaction.category.icon,
                        iconBg: transaction.category.color,
                      ),
                      onTap: () {
                        ref.read(transactionProvider.notifier).setTransaction(transaction);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TransactionDetailsPage(
                              isEdit: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
