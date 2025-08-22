import 'package:expense_tracker/features/auth/providers/auth_provider.dart';
import 'package:expense_tracker/features/auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            const Text(
              "Giriş Yap",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              label: "Email",
              hintText: "Email",
              onChanged: (val) => email = val,
              initialValue: email,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: "Password",
              hintText: "Password",
              isPassword: true,

              onChanged: (val) => password = val,
              initialValue: password,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                title: "Devam Et",
                onPressed: () async {
                  await authNotifier.logIn(ref);
                },
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(child: Divider()),
            GestureDetector(
              child: const Text(
                " Kayıt ol",
                style: TextStyle(fontWeight: FontWeight.bold),
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
