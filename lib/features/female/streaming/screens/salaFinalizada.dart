import 'package:flutter/material.dart';

class LiveFinalizada extends StatelessWidget {
  const LiveFinalizada({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFE6B6FF),
                size: 70,
              ),

              const SizedBox(height: 10),

              const Text(
                "¡Sala Finalizada!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Aquí está el resumen de tu transmisión",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),

              const SizedBox(height: 30),

              // CARD PRINCIPAL
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // FOTO + NOMBRE
                    Row(
                      children: [
                        // AVATAR
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            "https://i.postimg.cc/XYNTR7zK/avatar.jpg", // Cambia esto
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "María Gonzales",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "@maria_streams",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // MÉTRICAS 1
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _smallMetric(
                          icon: Icons.visibility,
                          value: "6",
                          label: "Vistas totales",
                        ),
                        _smallMetric(
                          icon: Icons.favorite,
                          value: "87",
                          label: "Donativos",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // SECCIÓN: Métricas del Live
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "📈 Métricas del Live",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _metricTile(
                title: "Duración",
                value: "1:23:45",
                icon: Icons.timer,
              ),
              _metricTile(
                title: "Pico de espectadores",
                value: "6",
                icon: Icons.people,
              ),
              _metricTile(
                title: "Regalos recibidos",
                value: "87",
                icon: Icons.card_giftcard,
              ),
              _metricTile(
                title: "Minutos comprados",
                value: "145 min",
                icon: Icons.lock_clock,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget de tarjetas grandes
Widget _metricTile({
  required String title,
  required String value,
  required IconData icon,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFF151515),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFF2B2B2B), width: 1.2),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFFE6B6FF)),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

// Widget métrico pequeño
Widget _smallMetric({
  required String value,
  required String label,
  required IconData icon,
}) {
  return Container(
    width: 130,
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    decoration: BoxDecoration(
      color: const Color(0xFF151515),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Icon(icon, color: Color(0xFFE6B6FF)),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
      ],
    ),
  );
}
