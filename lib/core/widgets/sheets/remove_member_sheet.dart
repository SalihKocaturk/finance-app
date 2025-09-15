import 'package:flutter/material.dart';

import '../../../core/domain/enums/user_type.dart';
import '../../../core/domain/models/user_account.dart';
import '../../../core/widgets/custom_button.dart';

class RemoveMemberSheet extends StatelessWidget {
  final UserAccount user;
  final VoidCallback onConfirmTap;
  final VoidCallback onCancelTap;

  const RemoveMemberSheet({
    super.key,
    required this.user,
    required this.onConfirmTap,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final roleColor = switch (user.type) {
      UserType.owner => Colors.indigo,
      UserType.mod => Colors.teal,
      UserType.member => Colors.grey,
    };

    final roleLabel = switch (user.type) {
      UserType.owner => 'Owner',
      UserType.mod => 'Mod',
      UserType.member => 'Member',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  (user.email ?? 'U').isNotEmpty ? (user.email ?? 'U')[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.email ?? '-',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: roleColor.withAlpha(24),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: roleColor),
                          const SizedBox(width: 6),
                          Text(
                            roleLabel,
                            style: TextStyle(color: roleColor, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bu üyeyi hesaptan kaldırmak üzeresiniz. Bu işlem geri alınamaz.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: CustomButton(
                  color: Colors.grey.shade600,
                  icon: Icons.close,
                  text: "Vazgeç",
                  onTap: onCancelTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  color: Colors.red,
                  icon: Icons.delete_forever_rounded,
                  text: "Kaldır",
                  onTap: onConfirmTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
