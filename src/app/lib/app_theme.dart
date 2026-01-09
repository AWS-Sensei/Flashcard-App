import 'package:flutter/material.dart';

const _loveItBlue = Color(0xFF2D96BD);
const _loveItPink = Color(0xFFEF3982);

const _loveItDarkBlue = Color(0xFF55BDE2);
const _loveItDarkAccent = Color(0xFFBDEBFC);

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _loveItBlue,
    brightness: Brightness.light,
    background: const Color(0xFFFFFFFF),
    surface: const Color(0xFFFFFFFF),
    error: const Color(0xFFE74C3C),
  ).copyWith(
    primary: _loveItBlue,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFE1F3FA),
    onPrimaryContainer: const Color(0xFF0E2A36),
    secondary: _loveItPink,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFD9EEF4),
    onSecondaryContainer: const Color(0xFF1B3A46),
    background: const Color(0xFFFFFFFF),
    onBackground: const Color(0xFF161209),
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF161209),
    surfaceVariant: const Color(0xFFF8F8F8),
    onSurfaceVariant: const Color(0xFF161209),
    outline: const Color(0xFFF0F0F0),
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: colorScheme.onBackground,
      displayColor: colorScheme.onBackground,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surfaceVariant,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    dividerColor: colorScheme.outline,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFE9E9E9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _loveItBlue, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
      ),
    ),
  );
}

ThemeData buildDarkAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _loveItDarkBlue,
    brightness: Brightness.dark,
    background: const Color(0xFF292A2D),
    surface: const Color(0xFF252627),
    error: const Color(0xFFE74C3C),
  ).copyWith(
    primary: _loveItDarkBlue,
    onPrimary: const Color(0xFF0F1B21),
    primaryContainer: const Color(0xFF1E3E4A),
    onPrimaryContainer: const Color(0xFFBDEBFC),
    secondary: _loveItDarkAccent,
    onSecondary: const Color(0xFF0F1B21),
    secondaryContainer: const Color(0xFF3A3A42),
    onSecondaryContainer: const Color(0xFFA9A9B3),
    background: const Color(0xFF292A2D),
    onBackground: const Color(0xFFA9A9B3),
    surface: const Color(0xFF252627),
    onSurface: const Color(0xFFA9A9B3),
    surfaceVariant: const Color(0xFF363636),
    onSurfaceVariant: const Color(0xFFA9A9B3),
    outline: const Color(0xFF363636),
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: colorScheme.onBackground,
      displayColor: colorScheme.onBackground,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    dividerColor: colorScheme.outline,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _loveItDarkBlue, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
      ),
    ),
  );
}
