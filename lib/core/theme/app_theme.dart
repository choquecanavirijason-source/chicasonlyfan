import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'package:chicas_app/core/theme/chicas_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: Tok.fondo,

      // La tipografía del sistema, para toda la app de una vez.
      //
      // Jost es la base: todo texto que no diga lo contrario la usa, así
      // que las pantallas que nunca se tocaron dejan de salir con la
      // fuente por defecto de Android.
      //
      // Playfair Display queda para los tamaños de display y titular,
      // que es donde su alto contraste se aprecia; por debajo de 22px
      // pierde justamente eso y conviene la sans.
      textTheme:
          GoogleFonts.jostTextTheme(
                ThemeData(brightness: Brightness.dark).textTheme,
              )
              .copyWith(
                displayLarge: GoogleFonts.playfairDisplay(
                  fontSize: 40,
                  height: 1.05,
                  fontWeight: FontWeight.w600,
                  color: Tok.marfil,
                ),
                displayMedium: GoogleFonts.playfairDisplay(
                  fontSize: 34,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                  color: Tok.marfil,
                ),
                displaySmall: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  height: 1.13,
                  fontWeight: FontWeight.w600,
                  color: Tok.marfil,
                ),
                headlineLarge: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  height: 1.15,
                  fontWeight: FontWeight.w600,
                  color: Tok.marfil,
                ),
                headlineMedium: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  height: 1.27,
                  fontWeight: FontWeight.w500,
                  color: Tok.marfil,
                ),
              )
              .apply(bodyColor: Tok.marfil, displayColor: Tok.marfil),
      primaryTextTheme: GoogleFonts.jostTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ).apply(bodyColor: Tok.marfil, displayColor: Tok.marfil),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textWhite),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.textHint),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: GoogleFonts.jost(color: AppColors.textHint, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          // Sobre el oro el texto va en tinta: blanco sobre oro no llega
          // al contraste minimo.
          foregroundColor: Tok.tinta,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          textStyle: GoogleFonts.jost(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}
