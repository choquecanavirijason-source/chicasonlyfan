import 'package:flutter/material.dart';

/// Tokens del sistema visual de ChicasApp.
///
/// Los nombres son los mismos que en el manual de diseño, para que una
/// pantalla pueda leerse contra él sin traducir nada.
///
/// La decisión de fondo: la app deja de verse clara y plana para verse
/// nocturna. Negro cálido (#060606, no #000000), una sola línea de oro como
/// acento, y el rosa de la marca reservado para favoritas y EN VIVO.
class Tok {
  Tok._();

  // ---- Color (tema Noche, el principal) ----
  static const fondo = Color(0xFF060606);
  static const superficie = Color(0xFF121212);
  static const superficieAlta = Color(0xFF1C1A19);
  static const oro = Color(0xFFC9A227);
  static const champan = Color(0xFFE8D9A0);
  static const vino = Color(0xFF4A0E2A);
  static const rosa = Color(0xFFE24F9A);
  static const marfil = Color(0xFFF5F1E8);

  /// Texto sobre el oro. El único caso del sistema en que el texto no va
  /// en marfil: blanco sobre oro no llega al contraste mínimo.
  static const tinta = Color(0xFF140F02);
  static const oroHondo = Color(0xFF9D7C14);
  static const humo = Color(0xFFA9A29B);
  static const borde = Color(0xFF2A2724);
  static const exito = Color(0xFF4FBF8B);
  static const error = Color(0xFFF2607A);

  // ---- Espacio ----
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 24.0;
  static const s6 = 32.0;
  static const s7 = 48.0;

  // ---- Radio ----
  static const rS = 8.0;
  static const rM = 14.0;
  static const rL = 22.0;
  static const rPill = 999.0;

  // ---- Materiales ----

  /// El resplandor detrás de la acción principal. Uno por pantalla:
  /// si dos botones brillan, ninguno destaca.
  ///
  /// Intensidad media: se nota en una captura y no satura al usar la app
  /// todos los días. El resplandor fuerte gana en una imagen y cansa en uso.
  static const glowOro = BoxShadow(
    color: Color(0x6BC9A227),
    blurRadius: 28,
    spreadRadius: 0,
  );

  /// Versión más contenida, para la tarjeta del live. Va más tenue que el
  /// botón porque la tarjeta ya es grande: con la misma opacidad que el
  /// botón, el resplandor se comería la grilla entera.
  static const glowOroCarta = BoxShadow(
    color: Color(0x4DC9A227),
    blurRadius: 30,
  );

  /// Sólo para EN VIVO. Es lo único de la app que se mueve sin que
  /// nadie lo toque, y ese privilegio es lo que lo hace funcionar.
  static const glowRosa = BoxShadow(
    color: Color(0x4DE24F9A),
    blurRadius: 24,
  );

  /// El resplandor del estado EN VIVO. Va en rojo, que es la convención
  /// de "en directo", y es el único acento que compite con el oro.
  static const glowVivo = BoxShadow(
    color: Color(0x80E33D4E),
    blurRadius: 20,
    spreadRadius: 1,
  );

  /// Resplandor contenido, para destacar una caja sin que grite: tarjetas
  /// de una lista, avatares en línea, el paquete recomendado de una fila.
  static const glowSuave = BoxShadow(
    color: Color(0x33C9A227),
    blurRadius: 20,
  );

  static const sombraCarta = BoxShadow(
    color: Color(0x73000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  /// El hilo de oro: 1px, nunca más. Engordarlo lo convierte en un marco
  /// y se pierde el efecto.
  static Border get hiloOro => Border.all(color: oro, width: 1);
  static Border get hiloTenue => Border.all(color: borde, width: 1);
}
