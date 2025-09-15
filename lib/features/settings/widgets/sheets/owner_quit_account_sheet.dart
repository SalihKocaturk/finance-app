import 'package:expense_tracker/core/domain/enums/user_type.dart';
import 'package:expense_tracker/core/widgets/custom_button.dart';
import 'package:expense_tracker/features/settings/providers/selected_user_id_provider.dart';
import 'package:expense_tracker/features/settings/widgets/select_user_before_quit_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../auth/pages/account_page.dart';
import '../../../auth/providers/account_provider.dart';
import '../../../home/providers/balance_provider.dart';
import '../../../transaction/providers/transaction_list_provider.dart';

class OwnerQuitAccountSheet extends StatelessWidget {
  final WidgetRef ref;
  const OwnerQuitAccountSheet({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    final accAsync = ref.watch(accountProvider);
    final selectedUid = ref.watch(selectedUserIdProvider);
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: accAsync.isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Çıkmadan önce bir yetkiyi aktaracağınız kişiyi seçiniz...",
                      textAlign: TextAlign.center,
                    ),
                    const Gap(10),

                    const Expanded(child: SelectUserBeforeQuitList()),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(60),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Eğer yetkiyi aktaracağınız üyeyi seçmezseniz hesap tamamen silinecek. Bu işlem geri alınamaz.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),

                    CustomButton(
                      color: Colors.red,
                      icon: Icons.logout,
                      text: "Seç Ve Çık",
                      onTap: () {
                        if (selectedUid != null) {
                          ref.read(accountProvider.notifier).changeUserRole(selectedUid, UserType.owner);
                          ref.read(accountProvider.notifier).exitAccount();
                        } else {
                          ref.read(accountProvider.notifier).deleteAccount();
                        }
                        ref.invalidate(transactionListProvider);
                        ref.invalidate(balanceProvider);

                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const AccountPage(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
