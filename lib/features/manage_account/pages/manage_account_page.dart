import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/widgets/sheets/remove_member_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/toast.dart';
import '../../../core/domain/enums/alert_type.dart';
import '../../../core/domain/enums/user_type.dart';
import '../../../core/domain/models/user_account.dart';
import '../../../core/localization/locale_keys.g.dart';
import '../../../core/widgets/action_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/pop_page_button.dart';
import '../../../core/widgets/sheets/model_bottom_sheet.dart';
import '../../auth/pages/account_page.dart';
import '../../auth/providers/account_provider.dart';
import '../widgets/user_row.dart';

class ManageAccountPage extends ConsumerWidget {
  const ManageAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accAsync = ref.watch(accountProvider);
    final account = accAsync.valueOrNull;
    final currentUid = firebase.FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.manage_account.tr().capitalizeFirst()),
        centerTitle: true,

        leadingWidth: 60,
        leading: Row(
          children: [
            CustomAppbarButton(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: accAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : account == null
          ? Center(
              child: Text(
                LocaleKeys.account_not_found.tr().capitalizeFirst(),
                style: theme.textTheme.bodyMedium,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ActionCard(
                        title: LocaleKeys.member.tr().capitalizeFirst(),
                        bg: const Color(0xFF7E57C2),
                        count: account.accounts?.length ?? 0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionCard(
                        title: LocaleKeys.transactions.tr().capitalizeFirst(),
                        bg: const Color(0xFFF57C00),
                        count: account.transactions?.length ?? 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 4),
                  child: Text(
                    LocaleKeys.share_invite_code.tr().capitalizeFirst(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Card(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1C2741)
                      : const Color(0xFFF4F6FB),

                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(LocaleKeys.share_code.tr().capitalizeFirst(), style: theme.textTheme.labelMedium),
                              const SizedBox(height: 6),
                              Text(
                                (account.shareId).toString().padLeft(6, '0'),
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          color: Colors.blue,
                          icon: Icons.copy,
                          text: LocaleKeys.copy.tr().capitalizeFirst(),
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: account.shareId.toString().padLeft(6, '0')),
                            );
                            if (context.mounted) {
                              showToast(
                                LocaleKeys.share_code_copied.tr().capitalizeFirst(),
                                AlertType.info,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 4),
                  child: Text(
                    LocaleKeys.users.tr().capitalizeFirst(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 8),
                ...List<Widget>.from(
                  (account.accounts ?? <UserAccount>[]).map((user) {
                    final isMe = user.id == currentUid;
                    return UserRow(
                      user: user,
                      isMe: isMe,
                      onChangeRole: (role) async {
                        if (user.id == null) return;
                        final ok = await ref.read(accountProvider.notifier).changeUserRole(user.id!, role);
                        if (context.mounted && ok) {
                          showToast(LocaleKeys.role_updated.tr().capitalizeFirst(), AlertType.info);
                        }
                      },
                      onRemove: () async {
                        showMyBottomSheet(
                          context,
                          230,
                          RemoveMemberSheet(
                            user: user,
                            onCancelTap: () => Navigator.pop(context),
                            onConfirmTap: () async {
                              Navigator.pop(context);
                              final ok = await ref.read(accountProvider.notifier).removeUser(user.id!);
                              if (context.mounted) {
                                showToast(
                                  ok
                                      ? LocaleKeys.member_removed.tr().capitalizeFirst()
                                      : LocaleKeys.member_cannot_removed.tr().capitalizeFirst(),
                                  ok ? AlertType.success : AlertType.fail,
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),

                const SizedBox(height: 24),

                if ((account.accounts ?? []).any((x) => x.id == currentUid && x.type == UserType.owner))
                  CustomButton(
                    color: const Color(0xFFE53935),
                    icon: Icons.delete_forever_rounded,
                    text: LocaleKeys.close_account.tr().capitalizeFirst(),
                    onTap: () async {
                      final ok = await ref.read(accountProvider.notifier).deleteAccount();
                      if (ok && context.mounted) {
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const AccountPage()),
                        );
                      }
                    },
                  ),
              ],
            ),
    );
  }
}
