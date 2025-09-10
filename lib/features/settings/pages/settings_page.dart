import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/constants/terms_and_conditions.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/widgets/sheets/log_out_bottom_sheet.dart';
import 'package:expense_tracker/core/widgets/sheets/show_paragraph_bottom_sheet.dart';
import 'package:expense_tracker/features/account_info/pages/account_info.dart';
import 'package:expense_tracker/features/account_info/providers/user_provider.dart';
import 'package:expense_tracker/features/app_settings/pages/app_settings_page.dart';
import 'package:expense_tracker/features/auth/pages/account_page.dart';
import 'package:expense_tracker/features/auth/pages/login_page.dart';
import 'package:expense_tracker/features/auth/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/privacy_policy.dart';
import '../../../core/domain/enums/user_type.dart';
import '../../../core/domain/models/user_account.dart';
import '../../../core/localization/locale_keys.g.dart';
import '../../../core/services/image_picker_service.dart';
import '../../../core/themes/providers/theme_provider.dart';
import '../../account_info/providers/form_providers.dart';
import '../../auth/providers/account_provider.dart';
import '../../home/providers/balance_provider.dart';
import '../../transaction/providers/transaction_list_provider.dart';
import '../widgets/option_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authNotifier = ref.watch(authProvider.notifier);
    final height = MediaQuery.of(context).size.height;
    final XFile? imageData = ref.watch(imageFileProvider);
    final name = ref.watch(editNameProvider);
    final email = ref.watch(editEmailProvider);
    final account = ref.watch(accountProvider).value;

    if (account == null) {
      return const CircularProgressIndicator();
    }

    final currentUser = firebase.FirebaseAuth.instance.currentUser;

    final myUser = account.accounts?.firstWhere(
      (u) => u.id == currentUser?.uid,
      orElse: () => const UserAccount(id: null, email: null, type: UserType.member),
    );

    const String fallbackUrl =
        'https://media.licdn.com/dms/image/v2/D4D03AQGofiGE_BrpgA/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1718252507739?e=1757548800&v=beta&t=IxPzkLlNsqbpmeLCKCGEeem9eU7BiuErxZ9lfjx3ovE';
    final XFile? pickedFile = ref.watch(imageFileProvider);
    final String? networkUrl = ref.watch(imageUrlProvider);
    final avatarImage = ImageService().getImage(
      file: pickedFile,
      photoUrl: (pickedFile == null ? networkUrl : null) ?? fallbackUrl,
    );
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
                CircleAvatar(
                  radius: 50,
                  backgroundImage: avatarImage,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 12),
                  child: Text(
                    email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withAlpha(60),
                    ),
                  ),
                ),
                // IconButton(
                //   onPressed: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (_) => const EditProfilePage(),
                //       ),
                //     );
                //   },
                //   icon: const Icon(Icons.edit),
                // ),
              ],
            ),
          ),

          OptionTile(
            title: LocaleKeys.account_info.tr().capitalizeFirst(),
            icon: Icons.person_rounded,
            iconBgColor: const Color(0xFF7E57C2),
            onTap: () {
              ref.read(userProvider.notifier).fillEditors(ref);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AccountInfo(),
                ),
              );
            },
          ),

          OptionTile(
            title: LocaleKeys.privacy_policy.tr().capitalizeFirst(),
            icon: Icons.privacy_tip_rounded,
            iconBgColor: const Color(0xFF3949AB),
            onTap: () => showParagraphBottomSheet(
              context,
              title: LocaleKeys.privacy_policy.tr().capitalizeFirst(),
              content: privacyPolicyText,
            ),
          ),
          OptionTile(
            title: LocaleKeys.terms_conditions.tr().capitalizeFirst(),
            icon: Icons.rule_rounded,
            iconBgColor: const Color(0xFFF57C00),
            onTap: () => showParagraphBottomSheet(
              context,
              title: LocaleKeys.terms_conditions.tr().capitalizeFirst(),
              content: termsAndConditionsText,
            ),
          ),
          OptionTile(
            title: LocaleKeys.settings.tr().capitalizeFirst(),
            icon: Icons.settings_rounded,
            iconBgColor: const Color(0xFF26A69A),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AppSettingsPage(),
                ),
              );
            },
          ),
          OptionTile(
            title: LocaleKeys.logout.tr().capitalizeFirst(),
            icon: Icons.logout_rounded,
            iconBgColor: const Color(0xFFE53935),
            onTap: () {
              showLogoutBottomSheet(
                context,
                () {
                  ref.read(themeProvider.notifier).clear();
                  authNotifier.logOut();
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
                },
                () {
                  Navigator.pop(context);
                },
                height * 0.4,
              );
            },
          ),

          OptionTile(
            title: 'Hesaptan çık',
            icon: Icons.exit_to_app_rounded,
            iconBgColor: const Color(0xFFFB8C00),
            onTap: () {
              showLogoutBottomSheet(
                context,
                () async {
                  await ref.read(accountProvider.notifier).exitAccount();

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
                () {
                  Navigator.pop(context);
                },
                height * 0.4,
              );
            },
          ),
          if (myUser?.type == UserType.owner)
            OptionTile(
              title: 'Hesabı kapat',
              icon: Icons.delete_forever_rounded,
              iconBgColor: const Color(0xFFE53935),
              onTap: () {
                showLogoutBottomSheet(
                  context,
                  () async {
                    final ok = await ref.read(accountProvider.notifier).deleteAccount();
                    if (ok && context.mounted) {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const AccountPage()),
                      );
                    }
                  },
                  () => Navigator.pop(context),
                  height * 0.4,
                );
              },
            ),
        ],
      ),
    );
  }
}
