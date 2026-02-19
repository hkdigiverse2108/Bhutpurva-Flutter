import 'package:flutter/material.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  scaffoldBackgroundColor: AppColors.dark,
  primaryColor: AppColors.primary,

  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.error,
    surface: AppColors.darkContainer,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.dark,
    foregroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
  ),

  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    bodyLarge: TextStyle(fontSize: 14, color: AppColors.white),
    bodyMedium: TextStyle(fontSize: 13, color: AppColors.grey),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.buttonDisabled,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkContainer,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.borderSecondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    hintStyle: const TextStyle(color: AppColors.grey),
  ),

  // cardTheme: CardTheme(
  //   color: AppColors.darkContainer,
  //   elevation: 0,
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(12),
  //   ),
  // ),
  dividerTheme: const DividerThemeData(color: AppColors.borderSecondary),
);
