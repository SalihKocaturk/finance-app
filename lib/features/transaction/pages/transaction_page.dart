import 'package:expense_tracker/core/constants/toast.dart';
import 'package:expense_tracker/core/domain/enums/transaction_type.dart';
import 'package:expense_tracker/core/extensions/extensions.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_provider.dart';
import 'package:expense_tracker/features/transaction/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../providers/transaction_list_provider.dart';
import '../widgets/transaction_card.dart';
import 'transaction_details_page.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionList = ref.watch(transactionListProvider);
    final transactionListNotifier = ref.read(transactionListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("İşlemler"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: const TransactionActionCard(
                      title: 'Gelir Ekle',
                      icon: Icons.savings_rounded,
                      bg: Color(0xFF7E57C2),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TransactionDetailsPage(modeIndex: 0),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 12)),
                Expanded(
                  child: GestureDetector(
                    child: const TransactionActionCard(
                      title: 'Gider Ekle',
                      icon: Icons.shopping_bag_rounded,
                      bg: Color(0xFFF57C00),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TransactionDetailsPage(modeIndex: 1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 8),
              child: Text(
                'Son Eklenenler',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
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
                            showToast('${transaction.category.label} silindi');
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,

                          icon: Icons.delete,
                          label: 'Sil',
                        ),
                      ],
                    ),
                    child: GestureDetector(
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
                            builder: (_) => const TransactionDetailsPage(
                              modeIndex: 2,
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
