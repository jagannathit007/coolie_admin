import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_constants.dart';

ThemeData defaultTheme = ThemeData(
  // Color Scheme
  primaryColor: Constants.instance.lightPrimary,
  // primarySwatch: Colors.blue,
  colorScheme: ColorScheme.light(
    primary: Constants.instance.lightPrimary,
    secondary: Constants.instance.lightSecondary,
    surface: Constants.instance.lightSurface,
    background: Constants.instance.scaffoldBackgroundColor,
    error: Constants.instance.lightError,
    onPrimary: Constants.instance.lightOnPrimary,
    onSecondary: Constants.instance.lightOnSecondary,
    onSurface: Constants.instance.lightOnSurface,
    onError: Constants.instance.lightOnError,
  ),
  scaffoldBackgroundColor: Constants.instance.scaffoldBackgroundColor,

  // Typography
  fontFamily: GoogleFonts.poppins().fontFamily,
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    displayLarge: GoogleFonts.poppins(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.poppins(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.poppins(color: Colors.grey[800], fontSize: 16),
    bodyMedium: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 14),
    labelLarge: GoogleFonts.poppins(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
  ),

  // App Bar
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Constants.instance.lightPrimary,
    titleTextStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
    iconTheme: const IconThemeData(color: Colors.black),
    actionsIconTheme: const IconThemeData(color: Colors.black),
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Constants.instance.lightPrimary,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Constants.instance.lightPrimary,
      textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Constants.instance.lightPrimary,
      side: BorderSide(color: Constants.instance.lightPrimary),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),

  // Input Fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Constants.instance.lightSurface,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Constants.instance.lightPrimary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD32F2F)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
    ),
    labelStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
    hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
  ),

  // Dividers
  dividerTheme: DividerThemeData(color: Colors.grey[200], thickness: 1, space: 1),

  // Other Components
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey[100],
    selectedColor: Constants.instance.lightPrimary,
    labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
    secondaryLabelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),

  // General
  visualDensity: VisualDensity.adaptivePlatformDensity,
  useMaterial3: true,
);
