import 'package:flutter/material.dart';

class AppColors {
  // App theme colors
  static const Color primary = Color(0xFFF57C00); // Saffron
  static const Color secondary = Color(0xFFFF9800); // Light Saffron
  static const Color accent = Color(0xFFFFE0B2); // Soft saffron tint

  // Icon colors
  static const Color iconPrimary = Color(0xFF757575);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color light = Color(0xFFFAFAFA);
  static const Color dark = Color(0xFF1F1F1F);
  static const Color primaryBackground = Color(0xFFF7F7F7);

  // Background container colors
  static const Color lightContainer = Color(0xFFFFFFFF);
  static Color darkContainer = AppColors.white.withValues(alpha: 0.08);

  // Button colors
  static const Color buttonPrimary = Color(0xFFF57C00);
  static const Color buttonSecondary = Color(0xFFBDBDBD);
  static const Color buttonDisabled = Color(0xFFE0E0E0);

  // Border colors
  static const Color borderPrimary = Color(0xFFE0E0E0);
  static const Color borderSecondary = Color(0xFF2C2C2C);

  // Error and validation colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral shades
  static const Color black = Color(0xFF212121);
  static const Color darkerGrey = Color(0xFF424242);
  static const Color darkGrey = Color(0xFF757575);
  static const Color grey = Color(0xFFBDBDBD);
  static const Color softGrey = Color(0xFFF5F5F5);
  static const Color lightGrey = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
}
