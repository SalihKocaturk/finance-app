import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/features/auth/pages/account_page.dart';
import 'package:expense_tracker/features/auth/pages/login_page.dart';
import 'package:expense_tracker/features/auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../providers/auth_form_providers.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = ref.watch(registerPasswordProvider);
    final password2 = ref.watch(registerPassword2Provider); // 👈 confirm password
    var authNotifier = ref.read(authProvider.notifier);

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasMinLength = password.length >= 8;
    final passwordsMatch = password2.isNotEmpty && password2 == password;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.sign_up.tr().capitalizeFirst(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            CustomTextField(
              label: LocaleKeys.name.tr().capitalizeFirst(),
              hintText: LocaleKeys.name.tr().capitalizeFirst(),
              onChanged: (val) => ref.read(registernameProvider.notifier).state = val,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: LocaleKeys.email.tr().capitalizeFirst(),
              hintText: LocaleKeys.email.tr().capitalizeFirst(),
              onChanged: (val) => ref.read(registerEmailProvider.notifier).state = val,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: LocaleKeys.password.tr().capitalizeFirst(),
              hintText: LocaleKeys.password.tr().capitalizeFirst(),
              isPassword: true,
              onChanged: (val) => ref.read(registerPasswordProvider.notifier).state = val,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: LocaleKeys.confirm_password.tr().capitalizeFirst(),
              hintText: LocaleKeys.confirm_password.tr().capitalizeFirst(),
              isPassword: true,
              onChanged: (val) => ref.read(registerPassword2Provider.notifier).state = val,
            ),

            const SizedBox(height: 12),
            _buildPasswordRules(hasUppercase, hasLowercase, hasMinLength, passwordsMatch),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () async {
                  await authNotifier.register(ref);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AccountPage()),
                    );
                  }
                },
                title: LocaleKeys.continueb.tr().capitalizeFirst(),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: Text(
                LocaleKeys.already_have_account.tr().capitalizeFirst(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRules(bool hasUpper, bool hasLower, bool hasLength, bool passwordsMatch) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.rule_min_one_upper.tr(),
            style: TextStyle(color: hasUpper ? Colors.green : Colors.grey),
          ),
          Text(
            LocaleKeys.rule_min_one_lower.tr(),
            style: TextStyle(color: hasLower ? Colors.green : Colors.grey),
          ),
          Text(
            LocaleKeys.rule_min_length.tr(),
            style: TextStyle(color: hasLength ? Colors.green : Colors.grey),
          ),
          Text(
            'Şifreler aynı olmalı',
            style: TextStyle(color: passwordsMatch ? Colors.green : Colors.grey),
          ),
        ],
      ),
    );
  }
}
