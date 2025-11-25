import 'package:flutter/material.dart';
import 'package:rider_pay_user/res/app_color.dart';

class AppTheme {
  /// Light Theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.white,
    primaryColor: AppColor.primary,
    colorScheme: ColorScheme.light(
      primary: AppColor.primary,
      secondary: AppColor.primary,
      surface: AppColor.white,
      onPrimary: AppColor.black,
      onSecondary: AppColor.white,
      onSurface: AppColor.textPrimary,
    ),
    iconTheme: const IconThemeData(color: AppColor.greyDark),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColor.textPrimary),
      bodyMedium: TextStyle(color: AppColor.textSecondary),
      labelSmall: TextStyle(color: AppColor.textSecondary),
    ),
  );

  /// Dark Theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF121212),
    primaryColor: AppColor.primary,
    colorScheme: ColorScheme.dark(
      primary: AppColor.primary,
      secondary: AppColor.primary,
      surface: AppColor.greyDark,
      onPrimary: AppColor.white,
      onSecondary: AppColor.white,
      onSurface: AppColor.white,
    ),
    iconTheme: const IconThemeData(color: AppColor.white),
    textTheme:  TextTheme(
      bodyLarge: TextStyle(color: AppColor.white),
      bodyMedium: TextStyle(color: Colors.white70),
      labelSmall: TextStyle(color: AppColor.white),
    ),
  );
}
