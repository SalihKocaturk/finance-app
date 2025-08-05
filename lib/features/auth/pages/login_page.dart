import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(isLoginProvider);
    final double itemWidth = MediaQuery.of(context).size.width > 520 ? 450 : 300;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                isLogin ? "Giriş Yap" : "Kayıt Ol",
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _buildLoginForm(context, ref, itemWidth + 50, isLogin),
              if (!isLogin) ...[
                _buildPasswordWarningText(ref),
                const SizedBox(height: 20),
              ],

              _buildContinueButton(() {
                ref.read(userProvider.notifier).setUser(ref);
              }, itemWidth),
              const SizedBox(height: 20),
              _buildSwitchButton(ref, itemWidth),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    WidgetRef ref,
    double itemWidth,
    bool isLogin,
  ) {
    return Container(
      width: itemWidth,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (!isLogin) ...[
            _buildTextField("İsminiz", ref, nameProvider),
            const SizedBox(height: 16),
          ],
          _buildTextField("E-Mail", ref, emailProvider),
          const SizedBox(height: 16),
          _buildTextField("Şifre", ref, passwordProvider, isPassword: true),
          if (!isLogin) ...[
            const SizedBox(height: 16),
            _buildTextField(
              "Şifre Tekrar",
              ref,
              password2Provider,
              isPassword: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    WidgetRef ref,
    StateProvider<String> provider, {
    bool isPassword = false,
  }) {
    return TextField(
      onChanged: (value) => ref.read(provider.notifier).state = value,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1D2671), width: 2),
        ),
      ),
    );
  }

  Widget _buildContinueButton(VoidCallback onPressed, double itemWidth) {
    return SizedBox(
      width: itemWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Devam Et",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordWarningText(WidgetRef ref) {
    final currentPassword = ref.watch(passwordProvider);

    final hasUppercase = currentPassword.contains(RegExp(r'[A-Z]'));
    final hasLowercase = currentPassword.contains(RegExp(r'[a-z]'));
    final hasMinLength = currentPassword.length >= 8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "En az 1 büyük harf",
          style: TextStyle(
            color: hasUppercase ? Colors.green : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "En az 1 küçük harf",
          style: TextStyle(
            color: hasLowercase ? Colors.green : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "En az 8 karakter",
          style: TextStyle(
            color: hasMinLength ? Colors.green : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchButton(WidgetRef ref, double itemWidth) {
    final isLogin = ref.watch(isLoginProvider);

    return Column(
      children: [
        SizedBox(
          width: itemWidth,
          child: const Divider(color: Colors.black, thickness: 1),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => ref.read(isLoginProvider.notifier).state = !isLogin,
          child: Text(
            isLogin ? "Kayıt Ol" : "Giriş Yap",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // const Text(
        //   "veya sosyal hesapla devam et",
        //   style: TextStyle(color: Colors.white70),
        // ),
        // const SizedBox(height: 16),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     _buildSquareTile('assets/images/google.png'),
        //     const SizedBox(width: 20),
        //     _buildSquareTile('assets/images/facebook.png'),
        //   ],
        // ),
      ],
    );
  }

  // Widget _buildSquareTile(String imagePath) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12),
  //       color: Colors.white,
  //       boxShadow: const [
  //         BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
  //       ],
  //     ),
  //     child: Image.asset(imagePath, height: 40, width: 40),
  //   );
  // }
}
