import 'package:flutter/material.dart';
import 'package:chicas_app/features/female/streaming/screens/sala_Screen.dart';
import 'package:chicas_app/features/female/streaming/screens/live2_page.dart';
import 'package:chicas_app/features/female/streaming/screens/camera_page.dart';
import 'package:chicas_app/core/theme/chicas_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class CrearContenidoPage extends StatelessWidget {
  const CrearContenidoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Tok.fondo,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "CREAR CONTENIDO",
                style: GoogleFonts.jost(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  color: Tok.oro,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "¿Qué deseas crear?",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  height: 1.13,
                  fontWeight: FontWeight.w600,
                  color: Tok.marfil,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Elige una opción para comenzar",
                style: GoogleFonts.jost(fontSize: 14, color: Tok.humo),
              ),

              const SizedBox(height: 40),

              // FILA SUPERIOR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _opcionCard(
                    destacada: true,
                    icon: Icons.wifi_tethering,
                    titulo: "Iniciar\nLive",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CameraPage()),
                      );
                    },
                  ),

                  // OPCIÓN 3
                  _opcionCard(
                    icon: Icons.groups_2_outlined,
                    titulo: "Crear\nSala 7-9",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SalaScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // OPCIÓN INFERIOR
              Align(
                alignment: Alignment.centerLeft,
                child: _opcionCard(
                  icon: Icons.upload_rounded,
                  titulo: "Subir\ncontenido",
                  width: 150,
                  onTap: () {
                    // Acción al subir contenido
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConfiguracionLive2Page(),
                      ),
                    );
                  },
                ),
              ),
              //2
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- TARJETA DE OPCIÓN --------------------
  Widget _opcionCard({
    bool destacada = false,
    required IconData icon,
    required String titulo,
    double width = 150,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 150,
        padding: const EdgeInsets.all(18),
        // Las tres eran degradados de color distintos, sin jerarquía.
        // Ahora comparten superficie y sólo "Iniciar Live", que es la
        // acción principal de la creadora, lleva el hilo de oro.
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Tok.rL),
          color: Tok.superficie,
          border: destacada ? Tok.hiloOro : Tok.hiloTenue,
          boxShadow: destacada
              ? const [Tok.glowOroCarta, Tok.sombraCarta]
              : const [Tok.sombraCarta],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: destacada ? Tok.oro : Tok.humo, size: 34),
            const SizedBox(height: 15),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
