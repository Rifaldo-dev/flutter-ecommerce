import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static const String _fallbackFont = 'system-ui';

  static TextStyle _createTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
  }) {
    try {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
      );
    } catch (e) {
      return TextStyle(
        fontFamily: _fallbackFont,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
      );
    }
  }

  // Headings
  static TextStyle h1 = _createTextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle h2 = _createTextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  static TextStyle h3 = _createTextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle h4 = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Body text
  static TextStyle bodyLarge = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodyMedium = _createTextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );

  static TextStyle bodySmall = _createTextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Button text
  static TextStyle buttonLarge = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle buttonMedium = _createTextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  // Label text
  static TextStyle labelMedium = _createTextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelSmall = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle caption = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // Helper functions
  static TextStyle withColor(TextStyle style, Color color) =>
      style.copyWith(color: color);

  static TextStyle withWeight(TextStyle style, FontWeight weight) =>
      style.copyWith(fontWeight: weight);

  static TextStyle withSize(TextStyle style, double size) =>
      style.copyWith(fontSize: size);
}
