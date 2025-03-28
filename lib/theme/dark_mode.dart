import 'package:cloudbook/utils/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryColorDark,
    secondary: AppColors.secondaryColorDark,
    onSecondary: AppColors.tertiaryColorDark,
    surface: AppColors.backgroundColorDark,
  ),
  textTheme: ThemeData.dark()
      .textTheme
      .apply(
        bodyColor: AppColors.textColorDark,
        displayColor: AppColors.textColorDark,
        fontFamily: 'CeraPro',
      )
      .copyWith(
        displayLarge: TextStyle(
          color: Colors.white.withOpacity(0.8), // slightly darker than white
        ),
      ),
);
