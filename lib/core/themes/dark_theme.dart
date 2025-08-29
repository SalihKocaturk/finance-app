// core/themes/dark_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class DarkTheme {
  static ThemeData get theme {
    const enabledBorderColor = Color(0xFF8AB4F8);
    const navItemColor = Colors.white;
    OutlineInputBorder outline() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
    );
    OutlineInputBorder enabledOutline() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: enabledBorderColor, width: 1),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7F00FF),
        brightness: Brightness.dark,
      ),

      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: const TextStyle(color: enabledBorderColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: outline(),
        enabledBorder: outline(),
        focusedBorder: enabledOutline(),
        disabledBorder: outline(),
        errorBorder: outline(),
        focusedErrorBorder: outline(),
      ),
      navigationBarTheme: NavigationBarThemeData(
        iconTheme: WidgetStateProperty.all(
          const IconThemeData(color: navItemColor),
        ),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color: navItemColor, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        indicatorColor: const Color(0x207F00FF),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
