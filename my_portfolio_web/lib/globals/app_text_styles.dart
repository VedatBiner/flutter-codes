import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle headerTextStyle() {
    return GoogleFonts.signikaNegative(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle montserratStyle({
    required Color color,
  }) {
    return GoogleFonts.montserrat(
      color: color,
      fontWeight: FontWeight.w800,
      fontSize: 24,
    );
  }

  static TextStyle headingStyles({
    double fontSize = 36,
    Color color = Colors.white,
  }) {
    return GoogleFonts.rubikMoonrocks(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      letterSpacing: 2,
    );
  }

  static TextStyle normalStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: Colors.white,
      letterSpacing: 1.7,
    );
  }

  static TextStyle comfortaaStyle() {
    return GoogleFonts.comfortaa(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: Colors.grey,
    );
  }
}
