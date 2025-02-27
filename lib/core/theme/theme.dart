import 'package:belog/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // --- Shared Border Styling ---
  static _border(
          {Color color = AppPallete.greyColorLight,
          double width = 1.5,
          double radius = 8.0}) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: width),
        borderRadius: BorderRadius.circular(radius),
      );

  // --- Dark Theme ---
  static final darkThemeMode = ThemeData.dark().copyWith(
    brightness: Brightness.dark, // Explicitly set brightness to dark
    scaffoldBackgroundColor: AppPallete.blackColor, // Main dark background
    colorScheme: const ColorScheme.dark(
      // Define color scheme for dark mode
      primary: AppPallete.greenColor,
      secondary: AppPallete.greenColor,
      surface: AppPallete.blackColorLight, // For cards and surfaces
      onPrimary: AppPallete.whiteColor,
      onSecondary: AppPallete.whiteColor,
      onSurface: AppPallete.whiteColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.blackColor, // Dark AppBar background
      elevation: 0, // No shadow for AppBar
      titleTextStyle: TextStyle(
        // Style AppBar title text
        color: AppPallete.whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme:
          IconThemeData(color: AppPallete.whiteColor), // White icons in AppBar
    ),
    textTheme: const TextTheme(
      // Define text theme for dark mode
      bodyMedium: TextStyle(color: AppPallete.whiteColor), // Default body text
      bodyLarge: TextStyle(color: AppPallete.whiteColor),
      bodySmall: TextStyle(color: AppPallete.greyColor), // Less prominent text
      titleLarge: TextStyle(
          color: AppPallete.whiteColor, fontWeight: FontWeight.bold), // Titles
      titleMedium:
          TextStyle(color: AppPallete.whiteColor, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(
          color: AppPallete.greyColorLight), // Subtitles or smaller titles
      labelLarge: TextStyle(color: AppPallete.whiteColor), // Button text
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppPallete.blackColorLight, // Dark chip background
      labelStyle: TextStyle(color: AppPallete.whiteColor), // White chip label
      secondaryLabelStyle: TextStyle(color: AppPallete.whiteColor),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPallete.greyColorDark, // Dark input field background
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      border: _border(color: AppPallete.greyColorLight), // Grey border
      enabledBorder: _border(color: AppPallete.greyColorLight),
      focusedBorder: _border(
          color: AppPallete.greenColor, width: 2.0), // Green focused border
      errorBorder: _border(color: AppPallete.errorColor),
      hintStyle:
          const TextStyle(color: AppPallete.greyColorLight), // Grey hint text
      labelStyle:
          const TextStyle(color: AppPallete.whiteColor), // White label text
      errorStyle: const TextStyle(color: AppPallete.errorColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      // Style for ElevatedButton - adjust as needed
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.greenColor, // Green button background
        foregroundColor: AppPallete.blackColor, // Dark text on button
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      // Style for TextButton - adjust as needed
      style: TextButton.styleFrom(
        foregroundColor: AppPallete.greenColor, // Green text for text buttons
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    iconTheme: const IconThemeData(
        color: AppPallete.whiteColor), // Default icon color - white
    primaryIconTheme: const IconThemeData(
        color: AppPallete.whiteColor), // Primary icon color - white
  );

  // --- Light Theme ---
  static final lightThemeMode = ThemeData.light().copyWith(
    brightness: Brightness.light, // Explicitly set brightness to light
    scaffoldBackgroundColor: AppPallete.lightBackground, // Light background
    colorScheme: const ColorScheme.light(
      // Define color scheme for light mode
      primary:
          AppPallete.gradient1, // Use gradient 1 as primary, adjust as needed
      secondary: AppPallete.gradient1,
      surface: AppPallete.lightGrey, // Light grey for surfaces
      onPrimary: AppPallete.whiteColor, // White text on primary (gradient)
      onSecondary: AppPallete.whiteColor, // Dark text on light background
      onSurface: AppPallete.lightBlack,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.lightBackground, // Light AppBar background
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppPallete.lightBlack,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme:
          IconThemeData(color: AppPallete.lightBlack), // Dark icons in AppBar
    ),
    textTheme: const TextTheme(
      // Define text theme for light mode
      bodyMedium:
          TextStyle(color: AppPallete.lightBlack), // Default body text - dark
      bodyLarge: TextStyle(color: AppPallete.lightBlack),
      bodySmall: TextStyle(
          color: AppPallete.lightGreyText), // Less prominent text - grey
      titleLarge: TextStyle(
          color: AppPallete.lightBlack,
          fontWeight: FontWeight.bold), // Titles - dark
      titleMedium:
          TextStyle(color: AppPallete.lightBlack, fontWeight: FontWeight.w500),
      titleSmall:
          TextStyle(color: AppPallete.lightGreyText), // Subtitles - grey
      labelLarge: TextStyle(color: AppPallete.lightBlack), // Button text - dark
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppPallete.lightGrey, // Light grey chip background
      labelStyle: TextStyle(color: AppPallete.lightBlack), // Dark chip label
      secondaryLabelStyle: TextStyle(color: AppPallete.lightBlack),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPallete.lightBackground, // Light input field background
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      border: _border(color: AppPallete.lightBorder), // Light grey border
      enabledBorder: _border(color: AppPallete.lightBorder),
      focusedBorder: _border(
          color: AppPallete.gradient1, width: 2.0), // Gradient focused border
      errorBorder: _border(color: AppPallete.errorColor),
      hintStyle: const TextStyle(
          color: AppPallete.lightGreyText), // Light grey hint text
      labelStyle:
          const TextStyle(color: AppPallete.lightBlack), // Dark label text
      errorStyle: const TextStyle(color: AppPallete.errorColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.gradient1, // Gradient button background
        foregroundColor: AppPallete.whiteColor, // White text on button
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppPallete.gradient1, // Gradient text for text buttons
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    iconTheme: const IconThemeData(
        color: AppPallete.lightBlack), // Default icon color - dark
    primaryIconTheme: const IconThemeData(
        color: AppPallete.lightBlack), // Primary icon color - dark
  );
}
