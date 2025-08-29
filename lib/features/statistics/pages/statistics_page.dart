import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../../../core/widgets/action_card.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.statistics.tr().capitalizeFirst()),
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
                      title: LocaleKeys.income.tr().capitalizeFirst(),
                      bg: const Color(0xFF7E57C2),
                      count: 12,
                    ),
                    onTap: () {},
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 12)),
                Expanded(
                  child: GestureDetector(
                    child: ActionCard(
                      title: LocaleKeys.expenses.tr().capitalizeFirst(),
                      bg: const Color(0xFFF57C00),
                      count: 22,
                    ),

                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
