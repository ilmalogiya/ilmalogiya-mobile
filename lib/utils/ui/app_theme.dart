import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "app_colors.dart";

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: "Lato",
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: .dark,
        statusBarBrightness: .light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: .dark,
      ),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.primaryColor,
        fontSize: 20,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      primary: AppColors.primaryColor,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStateProperty.all(Colors.white)),
    ),
  );
}
