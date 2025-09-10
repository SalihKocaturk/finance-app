import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/app.dart';
import 'package:expense_tracker/core/extensions/string_extensions.dart';
import 'package:expense_tracker/features/auth/providers/auth_provider.dart';
import 'package:expense_tracker/features/auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../providers/auth_form_providers.dart';
import 'register_page.dart';
//! bu sayfanın yapısında hata yapmışız, lokal değişkenlere yazılıyor providera yazılmıyor!!
//! bu sayfanın yapısında hata yapmışız, lokal değişkenlere yazılıyor providera yazılmıyor!!

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authNotifier = ref.read(authProvider.notifier);
    var email = ref.read(loginEmailProvider.notifier).state;
    var password = ref.read(loginPasswordProvider.notifier).state;
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.log_in.tr().capitalizeFirst(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              label: LocaleKeys.email.tr().capitalizeFirst(),
              hintText: LocaleKeys.email.tr().capitalizeFirst(),
              onChanged: (val) => ref.read(loginEmailProvider.notifier).state = val,
              initialValue: email,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: LocaleKeys.password.tr().capitalizeFirst(),
              hintText: LocaleKeys.password.tr().capitalizeFirst(),
              isPassword: true,

              onChanged: (val) => ref.read(loginPasswordProvider.notifier).state = val,
              initialValue: password,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                title: LocaleKeys.continueb.tr().capitalizeFirst(),
                onPressed: () async {
                  await authNotifier.logIn(ref);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const App(),
                      ),
                    );
                  }
                  //   Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(
                  //       builder: (_) => const AccountPage(),
                  //     ),
                  //   );

                  // final isLoggedIn = await UserStorage().isLoggedIn();
                  // if (isLoggedIn) {
                  //   if (context.mounted) {

                  //   }
                  // }
                },
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(child: Divider()),
            GestureDetector(
              child: Text(
                LocaleKeys.sign_up.tr().capitalizeFirst(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const RegisterPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
