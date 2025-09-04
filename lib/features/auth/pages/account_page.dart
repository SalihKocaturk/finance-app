import 'package:expense_tracker/core/widgets/sheets/model_bottom_sheet.dart';
import 'package:expense_tracker/features/auth/providers/account_provider.dart';
import 'package:expense_tracker/features/auth/widgets/join_code_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/pop_page_button.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: const CustomAppbarButton(),
        title: const Text('Hesap', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Oturum İşlemleri',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const Gap(8),
            Text(
              'Bir hesap oturumu başlatabilir veya mevcut bir oturuma katılabilirsin.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const Gap(28),
            CustomButton(
              color: Colors.green,
              icon: Icons.group_add_rounded,
              text: 'Oturum Oluştur',
              onTap: () {
                ref.read(accountProvider.notifier).createSessionWithCurrentUser();
              },
            ),
            const Gap(12),
            CustomButton(
              color: Colors.blue,
              icon: Icons.login_rounded,
              text: 'Oturuma Gir',
              onTap: () async {
                final code = await showMyBottomSheet(
                  context,
                  MediaQuery.of(context).size.height / 3.3,
                  const JoinCodeSheet(),
                );

                if (code != null && code.length == 6) {}
              },
            ),
          ],
        ),
      ),
    );
  }
}
