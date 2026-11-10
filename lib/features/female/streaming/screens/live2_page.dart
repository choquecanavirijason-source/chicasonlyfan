import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const ConfiguracionLive2Page());
}

class ConfiguracionLive2Page extends StatelessWidget {
  const ConfiguracionLive2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(85, 69, 2, 62),
        body: SafeArea(child: Center(child: AjustesFinalesPanel())),
      ),
    );
  }
}

class AjustesFinalesPanel extends StatefulWidget {
  const AjustesFinalesPanel({super.key});

  @override
  State<AjustesFinalesPanel> createState() => _AjustesFinalesPanelState();
}

class _AjustesFinalesPanelState extends State<AjustesFinalesPanel> {
  bool isPublic = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      // Este Material asegura que los TextField funcionen
      color: Colors.transparent,
      child: SingleChildScrollView(
        // Evita overflow
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height *
                  4, // Ajusta la altura máxima del panel
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  width: 530,
                  height: 1000,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      66,
                      20,
                      90,
                    ).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.50),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Subir Contenido",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Cerrar panel")),
                              );
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white.withOpacity(0.75),
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),

                      const Text(
                        "Configura los detalles de tu demo",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Foto de portada",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 25),

                      //agregar foto de portada
                      Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color.fromARGB(255, 182, 45, 157),
                            width: 3,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: const Image(
                            image: AssetImage('assets/profile3.jpg'),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      const Text(
                        "Titulo DEMO *",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 25),
                      _inputField(
                        placeholder: "Ej: Charla con mis seguidores ",
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Descripción",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      _inputField(
                        placeholder: "Describe de qué trata tu video...",
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "# Hashtags",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _inputField(
                        placeholder: "Ej: #charla #seguidores #amigos",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({required String placeholder, int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
      ),
      child: TextField(
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 13.5,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
