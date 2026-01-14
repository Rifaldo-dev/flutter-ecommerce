import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  // Fallback font family
  static const String _fallbackFont = 'system-ui';

  // Helper method to create text style with fallback
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
      // Fallback to system font if Google Fonts fails
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

  // Helper functions for color variations
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
}
