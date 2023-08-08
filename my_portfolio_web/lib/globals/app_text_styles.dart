import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle headerTextStyle({Color color = Colors.white}) {
    return GoogleFonts.signikaNegative(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle montserratStyle({
    required Color color,
    double fontSize = 24,
  }) {
    return GoogleFonts.montserrat(
      color: color,
      fontWeight: FontWeight.w800,
      fontSize: fontSize,
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

  static TextStyle normalStyle({Color color = Colors.white}) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 17,
      color: color,
      letterSpacing: 1.7,
      height: 1.5,
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
