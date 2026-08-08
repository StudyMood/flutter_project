import 'package:flutter/material.dart';

enum AppAccentColor {
  cyan(Color(0xFF00F2FE), "Cyan"),
  emerald(Color(0xFF10B981), "Emerald"),
  pink(Color(0xFFEC4899), "Pink"),
  amber(Color(0xFFF59E0B), "Amber"),
  purple(Color(0xFFA855F7), "Purple");

  final Color color;
  final String label;
  const AppAccentColor(this.color, this.label);
}

class AppTheme {
  static ThemeData buildTheme({
    required bool isDark,
    required AppAccentColor accent,
  }) {
    final primaryColor = accent.color;
    final baseBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final cardBg = isDark
        ? const Color(0x1F1E293B) // 12% opacity glass
        : const Color(0xB3FFFFFF); // 70% opacity glass

    final borderColor = isDark
        ? const Color(0x33FFFFFF)
        : const Color(0x1A000000);

    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? const Color(0x99FFFFFF) : const Color(0x990F172A);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: baseBg,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        surface: cardBg,
        onSurface: textColor,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
        titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 18),
        bodyLarge: TextStyle(color: textColor, fontSize: 16),
        bodyMedium: TextStyle(color: subtextColor, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
      ),
    );
  }

  static BoxDecoration glassBoxDecoration({
    required bool isDark,
    required Color accentColor,
    double borderRadius = 24,
    bool isSelected = false,
  }) {
    return BoxDecoration(
      color: isDark
          ? (isSelected ? accentColor.withValues(alpha: 0.15) : const Color(0x1F1E293B))
          : (isSelected ? accentColor.withValues(alpha: 0.12) : const Color(0xCCFFFFFF)),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isSelected
            ? accentColor.withValues(alpha: 0.6)
            : (isDark ? const Color(0x2BFFFFFF) : const Color(0x1F000000)),
        width: isSelected ? 2.0 : 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: isSelected
              ? accentColor.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
