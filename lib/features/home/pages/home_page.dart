// i18n
import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/balance_extensions.dart';
import 'package:expense_tracker/core/extensions/date_extensions.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/extensions/transaction_extensions.dart';
import 'package:expense_tracker/core/localization/locale_keys.g.dart';
import 'package:expense_tracker/core/providers/currency_provider.dart';
import 'package:expense_tracker/core/widgets/sheets/no_data_widget.dart';
import 'package:expense_tracker/features/home/providers/balance_provider.dart';
import 'package:expense_tracker/features/home/widgets/total_balance_card.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_list_provider.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/enums/transaction_currency.dart';
import '../../../core/domain/enums/transaction_type.dart';
import '../../../core/services/currency_service.dart';
import '../../../core/storage/currency_storage.dart';
import '../../../core/widgets/upper_pop_up.dart';
import '../../base/providers/bottom_nav_provider.dart';
import '../../transaction/pages/transaction_details_page.dart';
import '../../transaction/widgets/transaction_list_item.dart';
import '../widgets/currency_row.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final transactionList = ref.watch(transactionListProvider);
    final t = ref.watch(currencyTypeProvider);
    final currencyType = ref.watch(currencyTypeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.home.tr().capitalizeFirst()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: UpperPopup<CurrencyType>(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CurrencyRow(
                      symbol: t == CurrencyType.tl ? '₺' : (t == CurrencyType.usd ? '\$' : '€'),
                      label: t == CurrencyType.tl ? 'TRY' : (t == CurrencyType.usd ? 'USD' : 'EUR'),
                    ),
                    const Gap(4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                    ),
                  ],
                ),
              ),
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: CurrencyType.tl,
                  child: CurrencyRow(symbol: '₺', label: 'TRY (₺)'),
                ),
                PopupMenuItem(
                  value: CurrencyType.usd,
                  child: CurrencyRow(symbol: '\$', label: 'USD (\$)'),
                ),
                PopupMenuItem(
                  value: CurrencyType.eur,
                  child: CurrencyRow(symbol: '€', label: 'EUR (€)'),
                ),
              ],
              onSelected: (selected) async {
                ref.read(currencyTypeProvider.notifier).state = selected;

                if (selected == CurrencyType.tl) {
                  ref.read(currencyRateProvider.notifier).state = 1.0;
                  CurrencyStorage().setCurrency(CurrencyType.tl);
                  return;
                }
                if (selected == CurrencyType.usd) {
                  final rate = await CurrencyService().getUsdRate();
                  ref.read(currencyRateProvider.notifier).state = rate;
                  CurrencyStorage().setCurrency(CurrencyType.usd);
                  return;
                }
                if (selected == CurrencyType.eur) {
                  final rate = await CurrencyService().getEurRate();
                  ref.read(currencyRateProvider.notifier).state = rate;
                  CurrencyStorage().setCurrency(CurrencyType.eur);
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TotalBalanceCard(
              balance:
                  "${(balance.uiBalance(ref))} ${currencyType == CurrencyType.tl ? "₺" : (currencyType == CurrencyType.eur ? "€" : "\$")}",
              income:
                  "${(balance.uiIncome(ref))} ${currencyType == CurrencyType.tl ? "₺" : (currencyType == CurrencyType.eur ? "€" : "\$")}",
              expenses:
                  "${(balance.uiExpense(ref))} ${currencyType == CurrencyType.tl ? "₺" : (currencyType == CurrencyType.eur ? "€" : "\$")}",
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.transactions.tr().capitalizeFirst(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (transactionList.isNotEmpty)
                    TextButton(
                      child: Text(
                        LocaleKeys.see_all.tr().capitalizeFirst(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        ref.read(bottomNavProvider.notifier).state = 1;
                      },
                    ),
                ],
              ),
            ),
            if (transactionList.isNotEmpty) ...[
              const Gap(10),
              Expanded(
                child: ListView.builder(
                  itemCount: transactionList.length < 10 ? transactionList.length : 10,
                  itemBuilder: (context, index) {
                    final transaction = transactionList[index];
                    return GestureDetector(
                      child: TransactionListItem(
                        title: transaction.category.label.capitalizeFirst(),
                        dateText: transaction.date.formatAsDMY(),
                        amountText: (transaction.uiPrice(ref)),
                        isIncome: transaction.category.type == TransactionType.income,
                        icon: transaction.category.icon,
                        iconBg: transaction.category.color,
                      ),
                      onTap: () {
                        ref.read(transactionProvider.notifier).setTransaction(transaction);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TransactionDetailsPage(isEdit: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ] else ...[
              const NoDataWidget(),
            ],
          ],
        ),
      ),
    );
  }
}
