import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette from PRD
  static const Color primaryDeepBlue = Color(0xFF1A237E);
  static const Color secondaryCyan = Color(0xFF00E5FF);
  static const Color accentOrange = Color(0xFFFF6D00);
  static const Color surfaceTranslucentLight = Color(0x1AFFFFFF);
  static const Color surfaceTranslucentDark = Color(0x1A000000);

  // Gradient colors for flight paths
  static const List<Color> pathGradientColors = [
    secondaryCyan,
    Color(0xFF00B8D4),
    primaryDeepBlue,
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDeepBlue,
        brightness: Brightness.light,
        primary: primaryDeepBlue,
        secondary: secondaryCyan,
        tertiary: accentOrange,
      ),
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Roboto',
      textTheme: _textTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      bottomSheetTheme: _bottomSheetTheme,
      cardTheme: _cardTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDeepBlue,
        brightness: Brightness.dark,
        primary: primaryDeepBlue,
        secondary: secondaryCyan,
        tertiary: accentOrange,
      ),
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Roboto',
      textTheme: _textTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      bottomSheetTheme: _bottomSheetTheme,
      cardTheme: _cardTheme,
    );
  }

  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.25,
      color: Colors.white,
      shadows: [
        Shadow(
          offset: Offset(0, 2),
          blurRadius: 4,
          color: Colors.black54,
        ),
      ],
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: [
        Shadow(
          offset: Offset(0, 2),
          blurRadius: 4,
          color: Colors.black54,
        ),
      ],
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: [
        Shadow(
          offset: Offset(0, 2),
          blurRadius: 4,
          color: Colors.black54,
        ),
      ],
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: Colors.white70,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentOrange,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  );

  static const BottomSheetThemeData _bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: Colors.transparent,
    modalBackgroundColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  );

  static final CardThemeData _cardTheme = CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    color: surfaceTranslucentDark,
  );
}
