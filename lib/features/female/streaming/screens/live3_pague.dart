import 'package:flutter/material.dart';
import 'package:chicas_app/features/female/streaming/screens/liveLinea_page.dart';

class ConfiguracionSalaPanel extends StatefulWidget {
  const ConfiguracionSalaPanel({super.key});

  @override
  State<ConfiguracionSalaPanel> createState() => _ConfiguracionSalaPanelState();
}

class _ConfiguracionSalaPanelState extends State<ConfiguracionSalaPanel> {
  // CONTROLADORES
  final TextEditingController tituloCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  // VALORES SELECCIONADOS
  int limiteParticipantes = 10;
  String privacidad = "publica"; // "publica", "privada", "aprobacion"
  bool isSwitched = false; // Para el switch de aprobación
  // Para el switch de aprobación

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0623),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 330,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF2A0C39),
              borderRadius: BorderRadius.circular(28),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HEADER
                  Row(
                    children: const [
                      Icon(Icons.person, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Configuración de Sala",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Configura los detalles de tu sala de voz",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Título
                  const Text(
                    "Título de la Sala *",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  _inputField(
                    "Ej: Charla con mis seguidores",
                    controller: tituloCtrl,
                  ),
                  const SizedBox(height: 20),

                  // Descripción
                  const Text(
                    "Descripción",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  _inputField(
                    "Describe de qué tratará la conversación...",
                    controller: descCtrl,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 25),

                  // Límite de participantes
                  const Text(
                    "Límite de participantes",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => limiteParticipantes = 4),
                          child: _optionBox(
                            isSelected: limiteParticipantes == 4,
                            number: "4",
                            label: "personas",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => limiteParticipantes = 6),
                          child: _optionBox(
                            isSelected: limiteParticipantes == 6,
                            number: "6",
                            label: "personas",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Pública
                  GestureDetector(
                    onTap: () => setState(() {
                      privacidad = "publica";
                      isSwitched = false; // desactiva switch al elegir pública
                    }),
                    child: _cardPriva(
                      icon: Icons.public,
                      titulo: "Pública",
                      descripcion: "Cualquiera puede unirse",
                      isSelected: privacidad == "publica",
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Privada
                  GestureDetector(
                    onTap: () => setState(() {
                      privacidad = "privada";
                      isSwitched =
                          false; // desactiva switch al elegir privada simple
                    }),
                    child: _cardPriva(
                      icon: Icons.lock,
                      titulo: "Privada",
                      descripcion: "Solo usuarios invitados",
                      isSelected: privacidad == "privada" && !isSwitched,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Requiere aprobación
                  GestureDetector(
                    onTap: () => setState(() {
                      privacidad = "aprobacion";
                      isSwitched = true;
                    }),
                    child: _cardPriva(
                      icon: Icons.person_add_alt_1,
                      titulo: "Requiere aprobación",
                      descripcion: "Aprueba quién va a entrar",
                      isSelected: privacidad == "aprobacion",
                      barra: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            privacidad = value ? "aprobacion" : "aprovacion";
                          });
                        },
                        activeTrackColor: const Color.fromARGB(
                          255,
                          242,
                          185,
                          236,
                        ),

                        activeColor: const Color.fromARGB(255, 245, 82, 223),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BOTÓN GUARDAR
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF084D3),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 42,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          //lamado a sala_Screen
                          side: BorderSide(
                            color: const Color.fromARGB(
                              255,
                              179,
                              15,
                              15,
                            ).withOpacity(0.15),
                            width: 1.2,
                          ),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      icon: const Icon(Icons.people, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LiveScreen(),
                          ),
                        );
                      },
                      label: const Text(
                        "Iniciar sala",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
    );
  }

  // ----------- Widgets reutilizables -----------

  Widget _inputField(
    String placeholder, {
    int maxLines = 1,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.38),
            fontSize: 13.5,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _optionBox({
    required bool isSelected,
    required String number,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardPriva({
    required IconData icon,
    required String titulo,
    required String descripcion,
    required bool isSelected,
    Widget? barra,
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
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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
          if (barra != null) barra, // Aquí se muestra el switch si existe
          if (isSelected && barra == null)
            const Icon(Icons.check, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  // ---------------- GUARDAR ----------------

  void _guardar() {
    debugPrint("------ CONFIGURACIÓN ------");
    debugPrint("Título: ${tituloCtrl.text}");
    debugPrint("Descripción: ${descCtrl.text}");
    debugPrint("Límite: $limiteParticipantes");
    debugPrint("Privacidad: $privacidad");
    debugPrint("Aprobación activada: $isSwitched");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Configuración guardada"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
