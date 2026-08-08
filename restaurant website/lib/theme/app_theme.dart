import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color cardDark = Color(0xFF1A1A1A);
  static const Color cardDarkElevated = Color(0xFF242424);
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color brightGold = Color(0xFFF3C945);
  static const Color goldHover = Color(0xFFB8942F);
  static const Color textWhite = Color(0xFFF5F5F5);
  static const Color textMuted = Color(0xFFA0A0A0);
  static const Color whatsappGreen = Color(0xFF25D366);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryGold,
      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        secondary: brightGold,
        surface: cardDark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 52,
          fontWeight: FontWeight.bold,
          color: primaryGold,
          letterSpacing: 1.2,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: textWhite,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primaryGold,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: textWhite,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: textMuted,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
