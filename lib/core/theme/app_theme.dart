// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors matching the HTML design
  static const Color primaryGreen = Color(0xFF2D5A4F);
  static const Color darkGreen = Color(0xFF1A3D35);
  static const Color accentYellow = Color(0xFFFFD700);
  static const Color brightYellow = Color(0xFFFFED4A);
  static const Color redAccent = Color(0xFFDC3545);
  
  // Neutral colors
  static const Color lightBackground = Color(0xFFF5F1E8);
  static const Color creamBackground = Color(0xFFE8DDD4);
  static const Color cardBackground = Color(0xFFF8F8F8);
  static const Color borderColor = Color(0xFFEEEEEE);
  
  // Text colors
  static const Color primaryText = Color(0xFF333333);
  static const Color secondaryText = Color(0xFF555555);
  static const Color mutedText = Color(0xFF666666);
  static const Color lightText = Color(0xFFA0B4A8);
  
  // System colors
  static const Color errorColor = Color(0xFFE17055);
  static const Color successColor = Color(0xFF00B894);
  static const Color warningColor = Color(0xFFF39C12);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryGreen,
    
    // Background colors
    scaffoldBackgroundColor: lightBackground,
    canvasColor: Colors.white,
    
    // Color scheme
    colorScheme: ColorScheme.light(
      primary: primaryGreen,
      primaryContainer: darkGreen,
      secondary: accentYellow,
      secondaryContainer: brightYellow,
      surface: Colors.white,
      surfaceVariant: cardBackground,
      background: lightBackground,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: darkGreen,
      onSurface: primaryText,
      onBackground: primaryText,
      onError: Colors.white,
      outline: borderColor,
    ),
    
    // AppBar theme matching the HTML status bars
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: primaryText,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: primaryGreen,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: primaryGreen,
      ),
      titleTextStyle: TextStyle(
        color: primaryText,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: _systemFontFamily,
      ),
    ),
    
    // Button themes matching the HTML buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentYellow,
        foregroundColor: darkGreen,
        disabledBackgroundColor: accentYellow.withOpacity(0.5),
        disabledForegroundColor: darkGreen.withOpacity(0.5),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27), // Matching the rounded buttons
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        minimumSize: const Size(double.infinity, 55), // Full width, 55px height
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: _systemFontFamily,
        ),
      ),
    ),
    
    // Secondary button style for pay buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        side: BorderSide.none,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: _systemFontFamily,
        ),
      ),
    ),
    
    // Text button for links
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentYellow,
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.underline,
          fontFamily: _systemFontFamily,
        ),
      ),
    ),
    
    // Input field themes matching the HTML forms
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentYellow, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      hintStyle: TextStyle(
        color: lightText,
        fontSize: 16,
        fontFamily: _systemFontFamily,
      ),
      labelStyle: TextStyle(
        color: lightText,
        fontSize: 16,
        fontFamily: _systemFontFamily,
      ),
      floatingLabelStyle: TextStyle(
        color: accentYellow,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: _systemFontFamily,
      ),
    ),
    
    // Card theme for job offers and categories
    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderColor, width: 1),
      ),
    ),
    
    // Text themes matching the HTML typography
    textTheme: TextTheme(
      // Equivalent to .page-title
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryText,
        fontFamily: _systemFontFamily,
      ),
      
      // Equivalent to .app-title
      headlineMedium: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: redAccent,
        fontFamily: _systemFontFamily,
      ),
      
      // Equivalent to .job-title
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primaryGreen,
        fontFamily: _systemFontFamily,
      ),
      
      // Equivalent to .job-price
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: primaryText,
        fontFamily: _systemFontFamily,
      ),
      
      // Regular body text
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: primaryText,
        fontFamily: _systemFontFamily,
      ),
      
      // Secondary text
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: secondaryText,
        fontFamily: _systemFontFamily,
      ),
      
      // Small text like helper text
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: lightText,
        fontFamily: _systemFontFamily,
      ),
      
      // Category names and small labels
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryGreen,
        fontFamily: _systemFontFamily,
      ),
    ),
    
    // Icon theme
    iconTheme: IconThemeData(
      color: primaryGreen,
      size: 24,
    ),
    
    // Chip theme for categories
    chipTheme: ChipThemeData(
      backgroundColor: cardBackground,
      selectedColor: primaryGreen,
      disabledColor: cardBackground.withOpacity(0.5),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryGreen,
        fontFamily: _systemFontFamily,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: borderColor),
      ),
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryGreen,
    
    scaffoldBackgroundColor: darkGreen,
    canvasColor: const Color(0xFF1A1A1A),
    
    colorScheme: ColorScheme.dark(
      primary: primaryGreen,
      primaryContainer: accentYellow,
      secondary: accentYellow,
      secondaryContainer: brightYellow,
      surface: const Color(0xFF1A1A1A),
      surfaceVariant: primaryGreen.withOpacity(0.1),
      background: darkGreen,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: darkGreen,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      outline: Colors.white.withOpacity(0.2),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: darkGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: accentYellow,
        size: 24,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: _systemFontFamily,
      ),
    ),
    
    // Override other theme components for dark mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentYellow,
        foregroundColor: darkGreen,
        disabledBackgroundColor: accentYellow.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(27),
        ),
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: _systemFontFamily,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentYellow, width: 2),
      ),
      hintStyle: TextStyle(
        color: lightText,
        fontFamily: _systemFontFamily,
      ),
      labelStyle: TextStyle(
        color: lightText,
        fontFamily: _systemFontFamily,
      ),
    ),
  );
  
  // System font family matching HTML
  static const String _systemFontFamily = 'System';
}

// Extension to add custom gradient backgrounds like in HTML
extension AppThemeExtensions on ThemeData {
  static BoxDecoration get phoneContainerGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppTheme.lightBackground,
        AppTheme.creamBackground,
      ],
    ),
  );
  
  static BoxDecoration get screenGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppTheme.primaryGreen,
        AppTheme.darkGreen,
      ],
    ),
    borderRadius: BorderRadius.circular(32),
  );
}