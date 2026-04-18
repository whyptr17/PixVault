import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_radius.dart';

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.bgPrimary,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.accentPrimary,
    surface: AppColors.bgSecondary,
    error: AppColors.danger,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.bgPrimary,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: AppTextStyles.headline,
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.bgTertiary,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: AppRadius.md, borderSide: const BorderSide(color: AppColors.divider, width: 1)),
    enabledBorder: OutlineInputBorder(borderRadius: AppRadius.md, borderSide: const BorderSide(color: AppColors.divider, width: 1)),
    focusedBorder: OutlineInputBorder(borderRadius: AppRadius.md, borderSide: const BorderSide(color: AppColors.accentPrimary, width: 1.5)),
    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
  ),
);
