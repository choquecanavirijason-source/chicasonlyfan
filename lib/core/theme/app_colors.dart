import 'package:flutter/material.dart';

class AppColors {
  // El acento de la marca.
  //
  // Era un morado saturado (#3D1A4D) elegido cuando la app era clara. Sobre
  // el fondo negro del sistema competía con el oro en vez de acompañarlo:
  // tonos casi opuestos y saturaciones muy distintas. Ahora apunta al oro
  // del sistema, así que todo lo que lo usaba quedó alineado de una vez.
  //
  // Los tres valores viven en chicas_tokens.dart; acá se repiten para que
  // este archivo siga sin dependencias.
  static const Color primary = Color(0xFFC9A227); // oro
  static const Color primaryLight = Color(0xFFE8D9A0); // champan
  static const Color primaryDark = Color(0xFF9D7C14); // oro-hondo

  // Fondos. "white" conserva el nombre viejo porque lo usan decenas de
  // pantallas, pero ya no es blanco: es la superficie oscura del sistema.
  static const Color background = Color(0xFF060606); // fondo
  static const Color white = Color(0xFF121212); // superficie

  // Texto
  static const Color textPrimary = Color(0xFFF5F1E8); // marfil
  static const Color textSecondary = Color(0xFFA9A29B); // humo
  static const Color textHint = Color(0xFFA9A29B); // humo
  static const Color textWhite = Color(0xFFF5F1E8); // marfil

  // Estados
  static const Color error = Color(0xFFF2607A);
  static const Color success = Color(0xFF4FBF8B);

  // Colores de botones sociales
  static const Color google = Color(0xFFFFFFFF);
  static const Color apple = Color(0xFF000000);
  static const Color bottom = Color(0xFFC9A227); // oro
}
