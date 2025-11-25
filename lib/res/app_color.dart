
import 'package:flutter/material.dart';

class AppColor {
  // Core Brand Colors
  // static const Color primary = Color(0xFFFFC107);         // Rapido Yellow
  static const Color primary = Color(0xFFFFC107);  // Rapido Yellow
  static const Color primaryDark = Color(0xFFFFA000); // Rapido Dark Yellow
   // Darker yellow

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);           // Pure White
  static const Color black = Color(0xFF000000);           // Pure Black

  // UI Backgrounds & Surfaces
  // static const Color background = Color(0xFFF9F9F9);       // Light gray background
  static const Color lightSkyBack = Color(0xFFf6f9fe);       // Light gray background
  static const Color border = Color(0xFFE0E0E0);// Light border

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF1E1E1E);

  // 🟦 Grays (useful for hints, borders, backgrounds)
  static const Color greyLight1 = Color(0xFFF2F2F2);     // Lightest gray
  static const Color greyLight = Color(0xFFf6f7f9);     // Lightest gray
  static const Color grey = Color(0xFFBDBDBD);          // Default gray
  static const Color greyDark = Color(0xFF757575);      // Darker gray


  // Text Colors
  static const Color textPrimary = Color(0xFF000000);     // Black text
  static const Color textSecondary = Color(0xFF4F4F4F);   // Muted text

  // States
  static const Color error = Color(0xFFD32F2F);           // Error red
  static const Color success = Color(0xFF388E3C);         // Success green
  static const Color warning = Color(0xFFF57C00);         // Warning orange
  static const Color disabled = Color(0xFFBDBDBD);        // Disabled gray


}


extension AppColorsExt on BuildContext {
  // Primary
  Color get primary => Theme.of(this).colorScheme.primary;

  // Background
  Color get background => Theme.of(this).scaffoldBackgroundColor;

  // Text
  Color get textPrimary => Theme.of(this).textTheme.bodyLarge!.color!;
  Color get textSecondary => Theme.of(this).textTheme.bodyMedium!.color!;

  // Grey shades (light/dark auto detect)
  Color get greyLight {
    return Theme.of(this).brightness != Brightness.dark
        ? Color(0xFFf3f3f3)
        : Colors.grey.shade900;
  }

  Color get greyMedium {
    return Theme.of(this).brightness == Brightness.dark
        ? Colors.grey.shade500
        : Colors.grey.shade400;
  }

  Color get greyDark {
    return Theme.of(this).brightness == Brightness.dark
        ? Colors.grey.shade300
        : Colors.black;
  }
  Color get lightSkyBack {
    return Theme.of(this).brightness == Brightness.dark
        ? const Color(0xFF171722)
        : const Color(0xFFf6f9fe);
  }
  Color get hintTextColor {
    return Theme.of(this).brightness == Brightness.dark
        ? Colors.grey.shade600
        : Colors.grey.shade500;
  }
  Color get black =>
      Theme.of(this).brightness == Brightness.dark ? Colors.white : Colors.black;

  Color get white =>
      Theme.of(this).brightness == Brightness.dark ? Colors.black : Colors.white;

  Color get popupBackground =>
      Theme.of(this).brightness == Brightness.dark ? Color(0xFF121212) : Colors.white;

  // Color get popupBackground =>
  //     Theme.of(this).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.white;
  // States
  Color get error => Colors.red;
  Color get success => Colors.green;
  Color get warning => Colors.orange;
  Color get disabled => Colors.grey;
}

