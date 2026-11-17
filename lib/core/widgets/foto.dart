import 'package:flutter/material.dart';

/// Las fotos de la app vienen de dos lados: archivos dentro del APK
/// ("assets/...") y, en algunos casos viejos, URLs remotas.
///
/// Mezclarlos era la causa de que medio contenido se viera en blanco: se
/// usaba `Image.network` sobre rutas locales, que siempre falla, y las URLs
/// remotas dejaban la pantalla vacía cuando no había internet.
///
/// Estos helpers eligen solos el cargador correcto según la ruta.

bool _esRemota(String ruta) =>
    ruta.startsWith('http://') || ruta.startsWith('https://');

/// Para `backgroundImage`, `DecorationImage`, etc.
ImageProvider fotoProvider(String ruta) =>
    _esRemota(ruta) ? NetworkImage(ruta) : AssetImage(ruta) as ImageProvider;

/// Para usar como widget. Si la foto no carga, muestra un marcador gris
/// en vez de romper la pantalla.
Widget foto(
  String ruta, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  Widget alFallar(BuildContext _, Object __, StackTrace? ___) => Container(
    width: width,
    height: height,
    color: Colors.grey[300],
    child: const Icon(Icons.image, size: 50, color: Colors.grey),
  );

  return _esRemota(ruta)
      ? Image.network(
          ruta,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: alFallar,
        )
      : Image.asset(
          ruta,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: alFallar,
        );
}
