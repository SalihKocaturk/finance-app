import 'package:expense_tracker/features/auth/notifiers/auth_notifier.dart';
import 'package:expense_tracker/features/auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_form_providers.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = ref.watch(passwordProvider);

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasMinLength = password.length >= 8;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Kayıt Ol",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              hintText: "İsim",
              isPassword: true,
              onChanged: (val) => ref.read(nameProvider.notifier).state = val,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            CustomTextField(
              hintText: "Yeniden Şifre",
              isPassword: true,
              onChanged: (val) => ref.read(password2Provider.notifier).state = val,
            ),
            const SizedBox(height: 12),
            _buildPasswordRules(hasUppercase, hasLowercase, hasMinLength),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () {
                  AuthNotifier().register(ref);
                },
                title: "Devam Et",
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            GestureDetector(
              onTap: () {
                context.go("/login");
              },
              child: const Text(
                "Zaten hesabın var mı? Giriş yap",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRules(bool hasUpper, bool hasLower, bool hasLength) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "En az 1 büyük harf",
            style: TextStyle(color: hasUpper ? Colors.green : Colors.grey),
          ),
          Text(
            "En az 1 küçük harf",
            style: TextStyle(color: hasLower ? Colors.green : Colors.grey),
          ),
          Text(
            "En az 8 karakter",
            style: TextStyle(color: hasLength ? Colors.green : Colors.grey),
          ),
        ],
      ),
    );
  }
}
