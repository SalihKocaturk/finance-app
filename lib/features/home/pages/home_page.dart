import 'package:expense_tracker/features/auth/providers/auth_provider.dart';
import 'package:expense_tracker/features/home/widgets/total_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../widgets/transaction_tile.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ev"),
        leadingWidth: 120,
        leading: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.black,
                  onPressed: () {},
                  padding: const EdgeInsets.all(4.0),
                  iconSize: 23,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () async {
                  await authNotifier.logOut();
                },
                icon: const Icon(Icons.notifications),
                color: Colors.black,
                padding: const EdgeInsets.all(4.0),
                iconSize: 23,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const TotalBalanceCard(
              balance: "3,257.00",
              income: "2,350.00",
              expenses: "950.00",
            ),
            const Gap(10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "İşlemler",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Hepsine göz at",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Gap(10),
            Expanded(
              child: ListView(
                children: const [
                  TransactionTile(
                    title: "Bereket Döner",
                    subtitle: "14:20",
                    amount: "-₺400",
                    color: Colors.green,
                    icon: Icons.payment,
                  ),
                  TransactionTile(
                    title: "Martı",
                    subtitle: "22:40",
                    amount: "-₺350",
                    color: Colors.red,
                    icon: Icons.directions_car,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
