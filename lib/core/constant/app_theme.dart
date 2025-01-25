import 'package:flutter/material.dart';
import 'package:quiz_app/core/constant/app_color.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  colorScheme: const ColorScheme(
    primary: AppColors.primaryColor,
    secondary: AppColors.accentColor,
    surface: Colors.white,
    error: AppColors.errorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textColor,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textColor),
    bodyMedium: TextStyle(color: AppColors.textColor),
    titleLarge: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
  ),


    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Bo góc cho button
        ),
      ),
    ),


    //input theme
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondaryColor),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      fillColor: AppColors.backgroundColor,
      filled: true,
    ),


    appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: IconThemeData(
          color: AppColors.textColor,

        )
    )
);
