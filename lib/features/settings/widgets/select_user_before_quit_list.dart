import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/user_account.dart';
import '../../auth/providers/account_provider.dart';
import '../providers/selected_user_id_provider.dart';

class SelectUserBeforeQuitList extends ConsumerWidget {
  const SelectUserBeforeQuitList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final account = ref.watch(accountProvider).valueOrNull;
    final allUsers = account?.userAccounts ?? <UserAccount>[];
    final currentUid = firebase.FirebaseAuth.instance.currentUser?.uid;

    final selectedUserId = ref.watch(selectedUserIdProvider);
    final users = allUsers.where((u) => u.id != currentUid).toList();

    if (users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text('Seçilebilecek başka kullanıcı yok', style: theme.textTheme.bodyMedium),
        ),
      );
    }

    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final user = users[i];
        final isSelected = user.id == selectedUserId;

        final backgroundColor = isSelected
            ? Colors.blue.withAlpha(10)
            : (theme.brightness == Brightness.dark ? const Color(0xFF1E2A44) : const Color(0xFFF4F6FB));
        final borderColor = isSelected ? Colors.blue : Colors.transparent;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            isSelected
                ? ref.read(selectedUserIdProvider.notifier).state = null
                : ref.read(selectedUserIdProvider.notifier).state = user.id;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: isSelected
                  ? [BoxShadow(color: Colors.blue.withAlpha(12), blurRadius: 10, offset: const Offset(0, 4))]
                  : null,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: isSelected ? Colors.blue : Colors.blue.withAlpha(20),
                  child: Text(
                    _getFirstWord(users[i].email ?? users[i].id ?? '?'),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    users[i].email ?? 'Bilinmeyen kullanıcı',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.blue, key: ValueKey('on'))
                      : Icon(Icons.radio_button_unchecked, color: theme.disabledColor, key: const ValueKey('off')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getFirstWord(String text) => text.isEmpty ? '?' : text.characters.first.toUpperCase();
}
