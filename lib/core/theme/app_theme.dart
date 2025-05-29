import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemeData {
  static final ThemeData lightMode = ThemeData(
    primaryColor: AppColors.primaryColor,
    // canvasColor: AppColors.primaryColor,
    appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true),
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.interTextTheme(
      // استخدام خط Inter لجميع النصوص
      TextTheme(
        bodyLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.secondaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.blackColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold, // إضافة سماكة للعناوين
          color: AppColors.blackColor,
        ),
        displayMedium: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500,
          color: AppColors.blackColor,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.blackColor,


        ),
      ),
    ),

    tabBarTheme: TabBarTheme(
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
