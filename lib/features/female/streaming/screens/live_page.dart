import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:chicas_app/features/female/streaming/screens/liveLinea_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 52, 10, 97),
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
                    color: const Color.fromARGB(255, 68, 17, 94),
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
                            "Ajustes finales",
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
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Título del Live*",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      _inputField(
                        placeholder: "Ej: Bailando mis canciones favoritas ✨",
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Descripción",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      _inputField(
                        placeholder:
                            "Cuéntale a tu audiencia de qué trata tu Live",
                        maxLines: 3,
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Privacidad",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => setState(() => isPublic = true),
                        child: _cardPrivacidad(
                          isSelected: isPublic,
                          titulo: "Público",
                          descripcion: "Todos pueden ver tu live",
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => setState(() => isPublic = false),
                        child: _cardPrivacidad(
                          isSelected: !isPublic,
                          titulo: "Privado",
                          descripcion: "Solo tus seguidores",
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isPublic
                                    ? "Live Público iniciado"
                                    : "Live Privado iniciado",
                              ),
                            ),
                          );
                        },

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LiveScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF28ED8),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Comenzar Live",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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

  Widget _cardPrivacidad({
    required bool isSelected,
    required String titulo,
    required String descripcion,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFF084D3).withOpacity(0.22)
            : Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFF084D3)
              : Colors.white.withOpacity(0.15),
          width: isSelected ? 2 : 1.2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  descripcion,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(Icons.check, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}
