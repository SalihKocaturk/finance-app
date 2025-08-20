import 'package:expense_tracker/core/extensions/extensions.dart';
import 'package:expense_tracker/core/widgets/sheets/no_data_widget.dart';
import 'package:expense_tracker/features/auth/providers/auth_provider.dart';
import 'package:expense_tracker/features/home/providers/balance_provider.dart';
import 'package:expense_tracker/features/home/widgets/total_balance_card.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_list_provider.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/enums/transaction_type.dart';
import '../../base/providers/bottom_nav_provider.dart';
import '../../transaction/pages/transaction_details_page.dart';
import '../../transaction/widgets/transaction_list_item.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);
    final balance = ref.watch(balanceProvider);
    final transactionList = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        leadingWidth: 120,
        // leading: Row(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.only(left: 12.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: Colors.black.withAlpha(20),
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //         child: IconButton(
        //           icon: const Icon(Icons.menu),
        //           color: Colors.black,
        //           onPressed: () {},
        //           padding: const EdgeInsets.all(4.0),
        //           iconSize: 23,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 12.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.black.withAlpha(20),
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: IconButton(
          //       onPressed: () async {
          //         await authNotifier.logOut();
          //       },
          //       icon: const Icon(Icons.notifications),
          //       color: Colors.black,
          //       padding: const EdgeInsets.all(4.0),
          //       iconSize: 23,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TotalBalanceCard(
              balance: balance.balance.toString(),
              income: balance.income.toString(),
              expenses: balance.expense.toString(),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (transactionList.isNotEmpty)
                    TextButton(
                      child: const Text(
                        "See All",
                        style: TextStyle(color: Colors.grey),
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
                    var transaction = transactionList[index];
                    return GestureDetector(
                      child: TransactionListItem(
                        title: transaction.category.label,
                        dateText: transaction.date.formatAsDMY(),
                        amountText: transaction.amount.toString(),
                        isIncome: transaction.category.type == TransactionType.income,
                        icon: transaction.category.icon,
                        iconBg: transaction.category.color,
                      ),
                      onTap: () {
                        ref.read(transactionProvider.notifier).setTransaction(transaction);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TransactionDetailsPage(modeIndex: 2),
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
