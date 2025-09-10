import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/constants/toast.dart';
import 'package:expense_tracker/core/domain/enums/alert_type.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/features/account_info/providers/user_provider.dart';
import 'package:expense_tracker/features/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../../../core/widgets/custom_button.dart';
import '../../transaction/providers/transaction_list_provider.dart';
import '../providers/account_provider.dart';
import '../widgets/share_id_card.dart';

class AccountSuccessPage extends ConsumerWidget {
  const AccountSuccessPage({super.key, this.onGoHome});
  final VoidCallback? onGoHome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acc = ref.watch(accountProvider).valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: acc == null
                  ? Text(LocaleKeys.account_info_not_found.tr().capitalizeFirst())
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        const Icon(Icons.verified_rounded, size: 72),
                        const SizedBox(height: 16),
                        Text(
                          LocaleKeys.account_success_title.tr().capitalizeFirst(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleKeys.account_success_subtitle.tr().capitalizeFirst(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 24),
                        ShareIdCard(
                          label: LocaleKeys.share_code_label.tr().capitalizeFirst(),
                          shareIdText: acc.shareId.toString().padLeft(6, '0'),
                          onCopy: () async {
                            await Clipboard.setData(
                              ClipboardData(text: acc.shareId.toString().padLeft(6, '0')),
                            );
                            if (context.mounted) {
                              showToast(
                                LocaleKeys.share_code_copied.tr().capitalizeFirst(),
                                AlertType.info,
                              );
                            }
                          },
                          onShare: () {},
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            color: Colors.blue,
                            icon: Icons.verified,
                            text: LocaleKeys.go_home.tr().capitalizeFirst(),
                            onTap: () async {
                              await ref.read(transactionListProvider.notifier).load();
                              ref.read(userProvider.notifier).fillEditors(ref);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const BasePage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
