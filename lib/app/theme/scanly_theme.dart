import 'package:flutter/material.dart';

class ScanlyTheme {
  const ScanlyTheme._();

  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: Color(0xFF0F766E),
      secondary: Color(0xFF06B6D4),
      surface: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFBFCFE),
      surfaceContainer: Color(0xFFF1F5F7),
      surfaceContainerHighest: Color(0xFFE6EEF2),
      onSurface: Color(0xFF111827),
      onSurfaceVariant: Color(0xFF64748B),
      outline: Color(0xFFB7C3CC),
      outlineVariant: Color(0xFFDDE5EC),
      error: Color(0xFFDC2626),
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: const Color(0xFFF7FAFC),
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF2DD4BF),
      secondary: Color(0xFF22D3EE),
      surface: Color(0xFF1A2023),
      surfaceContainerLow: Color(0xFF151A1D),
      surfaceContainer: Color(0xFF20272A),
      surfaceContainerHighest: Color(0xFF2A3337),
      onSurface: Color(0xFFF3F6F7),
      onSurfaceVariant: Color(0xFFB8C2C7),
      outline: Color(0xFF5C686D),
      outlineVariant: Color(0xFF364247),
      error: Color(0xFFFF6B6B),
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: const Color(0xFF101416),
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
  }) {
    final primary = colorScheme.primary;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(44)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
