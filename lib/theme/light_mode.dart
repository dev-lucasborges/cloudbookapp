import 'package:cloudbook/utils/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryColorLight,
    secondary: AppColors.secondaryColorLight,
    surface: AppColors.backgroundColorLight,
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: AppColors.textColorLight,
        displayColor: AppColors.textColorLight,
        fontFamily: 'Poppins',
      ),
);
