import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/constants/terms_and_conditions.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/core/widgets/sheets/log_out_bottom_sheet.dart';
import 'package:expense_tracker/core/widgets/sheets/show_paragraph_bottom_sheet.dart';
import 'package:expense_tracker/features/account_info/pages/account_info.dart';
import 'package:expense_tracker/features/account_info/providers/user_provider.dart';
import 'package:expense_tracker/features/app_settings/pages/app_settings_page.dart';
import 'package:expense_tracker/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/privacy_policy.dart';
import '../../../core/localization/locale_keys.g.dart';
import '../../../core/services/image_picker_service.dart';
import '../../../core/themes/providers/theme_provider.dart';
import '../../account_info/providers/form_providers.dart';
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
                },
                () {
                  Navigator.pop(context);
                },
                height * 0.4,
              );
            },
          ),
        ],
      ),
    );
  }
}
