import 'package:flutter/material.dart';

import '../../../core/domain/enums/user_type.dart';
import '../../../core/domain/models/user_account.dart';
import 'avatar_badge.dart';
import 'role_chip.dart';
import 'role_item.dart';

class UserRow extends StatelessWidget {
  final UserAccount user;
  final bool isMe;
  final ValueChanged<UserType> onChangeRole;
  final VoidCallback onRemove;

  const UserRow({
    super.key,
    required this.user,
    required this.isMe,
    required this.onChangeRole,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final roleColor = switch (user.type) {
      UserType.owner => Colors.indigo,
      UserType.mod => Colors.teal,
      UserType.member => Colors.grey,
    };

    final role = switch (user.type) {
      UserType.owner => 'Owner',
      UserType.mod => 'Mod',
      UserType.member => 'Member',
    };

    return Card(
      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C2741) : const Color(0xFFF4F6FB),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            AvatarBadge(text: (user.email ?? 'U')[0].toUpperCase()),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.email ?? '-', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RoleChip(color: roleColor, label: role, isMe: isMe),
                      if (isMe) ...[
                        const SizedBox(width: 6),
                        Text('(you)', style: theme.textTheme.labelMedium?.copyWith(color: Colors.black54)),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            PopupMenuButton<UserType>(
              tooltip: 'Rol değiştir',
              onSelected: onChangeRole,
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: UserType.owner,
                  child: RoleItem(icon: Icons.verified, text: 'Owner'),
                ),
                PopupMenuItem(
                  value: UserType.mod,
                  child: RoleItem(icon: Icons.shield, text: 'Mod'),
                ),
                PopupMenuItem(
                  value: UserType.member,
                  child: RoleItem(icon: Icons.person, text: 'Member'),
                ),
              ],
              child: Icon(Icons.edit_rounded, color: Colors.blue.shade600),
            ),
            const SizedBox(width: 8),

            IconButton(
              tooltip: 'Kaldır',
              onPressed: () {
                onRemove();
              },
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
