import 'package:flutter/material.dart';

import '../widgets/transaction_card.dart';
import '../widgets/transaction_list_item.dart';
import 'transaction_details_page.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: ListView(
                children: [
                  TransactionListItem(
                    title: 'Maaş',
                    dateText: '30 Nis 2022',
                    amountText: '+₺1500',
                    isIncome: true,
                    icon: Icons.wallet_rounded,
                    iconBg: const Color(0xFF7E57C2),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TransactionDetailsPage(
                            modeIndex: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  const TransactionListItem(
                    title: 'Paypal',
                    dateText: '28 Nis 2022',
                    amountText: '+₺3500',
                    isIncome: true,
                    icon: Icons.account_balance_wallet_rounded,
                    iconBg: Color(0xFF2E7D32),
                  ),
                  const TransactionListItem(
                    title: 'Yemek',
                    dateText: '26 Nis 2022',
                    amountText: '-₺300',
                    isIncome: false,
                    icon: Icons.fastfood_rounded,
                    iconBg: Color(0xFFF57C00),
                  ),
                  const TransactionListItem(
                    title: 'İşCep',
                    dateText: '27 Nis 2022',
                    amountText: '+₺800',
                    isIncome: true,
                    icon: Icons.work_history_rounded,
                    iconBg: Color(0xFF26A69A),
                  ),
                  const TransactionListItem(
                    title: 'Fatura',
                    dateText: '27 Nis 2022',
                    amountText: '-₺600',
                    isIncome: false,
                    icon: Icons.receipt_long_rounded,
                    iconBg: Color(0xFF546E7A),
                  ),
                  const TransactionListItem(
                    title: 'İndirim',
                    dateText: '20 Nis 2022',
                    amountText: '+₺200',
                    isIncome: true,
                    icon: Icons.local_offer_rounded,
                    iconBg: Color(0xFF7B1FA2),
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
