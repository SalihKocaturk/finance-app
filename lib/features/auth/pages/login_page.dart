import 'package:expense_tracker/features/auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_form_providers.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              "Giriş Yap",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              hintText: "Email",
              onChanged: (val) => ref.read(emailProvider.notifier).state = val,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: "Şifre",
              isPassword: true,
              onChanged: (val) => ref.read(passwordProvider.notifier).state = val,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(onPressed: () {}, title: "Devam Et"),
            ),
            const SizedBox(height: 20),
            const SizedBox(child: Divider()),
            GestureDetector(
              onTap: () {
                context.go("/register");
              },
              child: const Text(
                " Kayıt ol",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
