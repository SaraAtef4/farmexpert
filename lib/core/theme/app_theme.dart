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
      textTheme: TextTheme(
          bodyLarge: GoogleFonts.getFont('Inter',color: AppColors.secondaryColor,fontSize: 24,fontWeight: FontWeight.bold),

          bodyMedium: GoogleFonts.getFont('Inter',fontSize: 16,color:AppColors.blackColor,fontWeight: FontWeight.normal,),

          headlineMedium: TextStyle(fontSize: 30, color: AppColors.blackColor),

          displayMedium: TextStyle(fontSize: 25, color: AppColors.blackColor, fontWeight: FontWeight.w500),

          labelMedium: GoogleFonts.getFont('Inter',fontSize: 14,color:AppColors.blackColor,fontWeight: FontWeight.bold,),

      )
      ,

  );
}
