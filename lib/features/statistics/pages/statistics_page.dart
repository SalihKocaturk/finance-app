// ... sizin mevcut StatisticsPage dosyanız
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../../../core/widgets/action_card.dart';
import '../../auth/providers/account_provider.dart';
import '../../transaction/notifiers/transaction_list_notifier.dart';
import '../widgets/category_donut_chart.dart';
import '../widgets/weekly_statistic_widget.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionList = ref.watch(transactionListProvider).value ?? [];
    final account = ref.watch(accountProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.statistics.tr().capitalizeFirst())),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // üst sayaç kartları (sizdeki gibi)
              Row(
                children: [
                  Expanded(
                    child: ActionCard(
                      title: LocaleKeys.income.tr().capitalizeFirst(),
                      bg: const Color(0xFF7E57C2),
                      count: account?.countIncome,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ActionCard(
                      title: LocaleKeys.expenses.tr().capitalizeFirst(),
                      bg: const Color(0xFFF57C00),
                      count: account?.countExpense,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              WeeklyTransactionsChart(
                transactions: transactionList,
                ref: ref,
              ),
              const SizedBox(height: 16),

              CategoryDonutChart(
                transactions: transactionList,
                ref: ref,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
