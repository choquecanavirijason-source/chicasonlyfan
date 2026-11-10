import 'package:flutter/material.dart';
import 'package:chicas_app/features/female/streaming/screens/sala_Screen.dart';
import 'package:chicas_app/features/female/streaming/screens/live2_page.dart';
import 'package:chicas_app/features/female/streaming/screens/camera_page.dart';

class CrearContenidoPage extends StatelessWidget {
  const CrearContenidoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Crear Contenido",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff4c3a57),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "¿Qué deseas crear?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xff4c3a57),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Elige una opción para comenzar",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // FILA SUPERIOR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _opcionCard(
                  colores: [Colors.redAccent, Colors.pinkAccent],
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
                  colores: [Color(0xff3d0647), Color(0xffb56bd8)],
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
                colores: [Color(0xffe774ff), Color(0xffff8ab9)],
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
    );
  }

  // ---------------- TARJETA DE OPCIÓN --------------------
  Widget _opcionCard({
    required List<Color> colores,
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: colores,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(3, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 38),
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
