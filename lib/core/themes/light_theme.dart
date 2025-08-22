import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class LightTheme {
  static ThemeData get theme {
    const borderColor = Color(0xFFDBDFE9);
    const fillColor = Color(0xFFFCFCFC);
    const enabledBorderColor = Color(0xFFDBDFE9);
    const navItemColor = Colors.black;
    OutlineInputBorder outline() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: borderColor, width: 1),
    );
    OutlineInputBorder enabledOutline() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: enabledBorderColor, width: 1),
    );
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        color: Colors.white,
      ),
      elevatedButtonTheme: const ElevatedButtonThemeData(style: ButtonStyle()),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: const TextStyle(color: Color.fromARGB(255, 58, 109, 239)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: fillColor,
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        indicatorColor: const Color(0x207F00FF),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
