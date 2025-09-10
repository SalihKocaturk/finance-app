import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/widgets/sheets/model_bottom_sheet.dart';
import 'package:expense_tracker/features/auth/pages/account_succes_page.dart';
import 'package:expense_tracker/features/auth/providers/account_provider.dart';
import 'package:expense_tracker/features/auth/providers/auth_form_providers.dart';
import 'package:expense_tracker/features/auth/widgets/join_code_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/pop_page_button.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final code = ref.watch(codeValueProvider);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64,
        leading: const CustomAppbarButton(),
        title: Text(
          LocaleKeys.account.tr().capitalizeFirst(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              LocaleKeys.account_actions_title.tr().capitalizeFirst(),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const Gap(8),
            Text(
              LocaleKeys.account_actions_desc.tr().capitalizeFirst(),
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const Gap(28),
            CustomButton(
              color: Colors.green,
              icon: Icons.group_add_rounded,
              text: LocaleKeys.create_account.tr().capitalizeFirst(),
              onTap: () async {
                final isAccontCreated = await ref.read(accountProvider.notifier).createSessionWithCurrentUser();
                if (isAccontCreated) {
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const AccountSuccessPage(),
                      ),
                    );
                  }
                }
              },
            ),
            const Gap(12),
            CustomButton(
              color: Colors.blue,
              icon: Icons.login_rounded,
              text: LocaleKeys.join_account.tr().capitalizeFirst(),
              onTap: () async {
                final c = await showMyBottomSheet(
                  context,
                  MediaQuery.of(context).size.height / 3.3,
                  const JoinCodeSheet(),
                );

                final raw = (c ?? '').toString();

                final cleaned = raw.trim().replaceAll(RegExp(r'\D'), '');

                final shareId = int.tryParse(cleaned);
                if (shareId == null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          LocaleKeys.invalid_share_code.tr().capitalizeFirst(),
                        ),
                      ),
                    );
                  }

                  return;
                }

                final ok = await ref.read(accountProvider.notifier).loginToAccountSession(shareId);
                if (ok && context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AccountSuccessPage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
