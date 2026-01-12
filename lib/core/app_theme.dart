import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFF8FA3); // Pastel Pink
  static const Color accentColor = Color(0xFF8CD4FF); // Pastel Blue
  static const Color purpleColor = Color(0xFFD4B3FF); // Pastel Purple
  static const Color yellowColor = Color(0xFFFFF59D); // Pastel Yellow for icons
  static const Color backgroundColor = Color(
    0xFFE3F2FD,
  ); // Light Blue Background
  static const Color errorColor = Color(0xFFFF5252); // Red for errors

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFFE3F2FD),
      Color(0xFFF3E5F5),
    ], // Light Blue to Light Purple
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: GoogleFonts.nunito().fontFamily,
      textTheme: GoogleFonts.nunitoTextTheme(),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          color: Colors.black87,
          fontSize: 28,
          fontWeight: FontWeight.w900,
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
    );
  }
}
