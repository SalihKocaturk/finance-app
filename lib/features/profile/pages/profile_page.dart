import 'package:expense_tracker/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/option_tile.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authNotifier = ref.watch(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://media.licdn.com/dms/image/v2/D4D03AQGofiGE_BrpgA/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1718252507739?e=1757548800&v=beta&t=IxPzkLlNsqbpmeLCKCGEeem9eU7BiuErxZ9lfjx3ovE',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Salih Kocatürk',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 12),
                  child: Text(
                    'kocaturksalih8@gmail.com',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withAlpha(60),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const OptionTile(
            title: 'Account Info',
            icon: Icons.person_rounded,
            iconBgColor: Color(0xFF7E57C2),
          ),
          const OptionTile(
            title: 'Security Code',
            icon: Icons.lock_rounded,
            iconBgColor: Color(0xFF43A047),
          ),
          const OptionTile(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_rounded,
            iconBgColor: Color(0xFF3949AB),
          ),
          const OptionTile(
            title: 'Settings',
            icon: Icons.settings_rounded,
            iconBgColor: Color(0xFF26A69A),
          ),
          OptionTile(
            title: 'Logout',
            icon: Icons.logout_rounded,
            iconBgColor: const Color(0xFFE53935),
            onTap: () {
              authNotifier.logOut();
            },
          ),
        ],
      ),
    );
  }
}
