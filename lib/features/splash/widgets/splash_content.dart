import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashContent extends StatelessWidget {
  final String imagePath;
  final String text;

  const SplashContent({
    Key? key,
    required this.imagePath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخلفية صورة ملء الشاشة
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        // النص فوق الصورة
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Text(
            text,
            style: GoogleFonts.inter(color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0),
                ),
              ],),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
