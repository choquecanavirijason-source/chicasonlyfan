import 'package:flutter/material.dart';

class RankingDonadores extends StatelessWidget {
  const RankingDonadores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A0C3A),
      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF3C1251),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TÍTULO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.yellow, size: 22),
                      SizedBox(width: 6),
                      Text(
                        "Ranking de Donadores",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.close, color: Colors.white70),
                ],
              ),

              const SizedBox(height: 5),
              const Text(
                "Agradece a tus top supporters",
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),

              const SizedBox(height: 20),

              // TOP 1
              _topCard(
                avatar: "https://i.pravatar.cc/150?img=12",
                name: "Carlos_VIP",
                puesto: "#1 - 450 Bs",
                badgeColor: Colors.yellow,
                botonTexto: "Acceso VIP",
                botonColor: Color(0xFFF38AE0),
                bordeColor: Color(0xFFFA8AD2),
              ),

              const SizedBox(height: 12),

              // TOP 2
              _topCard(
                avatar: "https://i.pravatar.cc/150?img=11",
                name: "Diego_Pro",
                puesto: "#2 - 320 Bs",
                badgeColor: Colors.grey,
                botonTexto: "Boleto 30 min",
                botonColor: Color(0xFFE3CFF3),
                bordeColor: Colors.white24,
              ),

              const SizedBox(height: 12),

              // TOP 3
              _topCard(
                avatar: "https://i.pravatar.cc/150?img=14",
                name: "Luis_Fan",
                puesto: "#3 - 180 Bs",
                badgeColor: Colors.brown,
                botonTexto: "Boleto 15 min",
                botonColor: Color(0xFFD6CED6),
                bordeColor: Colors.white24,
              ),

              const SizedBox(height: 20),

              // LISTA NORMAL
              _itemNormal(
                "Pedro_92",
                120,
                "#4",
                "https://i.pravatar.cc/150?img=5",
              ),
              _itemNormal(
                "Roberto_X",
                95,
                "#5",
                "https://i.pravatar.cc/150?img=7",
              ),
              _itemNormal(
                "Miguel_01",
                75,
                "#6",
                "https://i.pravatar.cc/150?img=21",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TARJETA TOP 1 / 2 / 3 ---
  Widget _topCard({
    required String avatar,
    required String name,
    required String puesto,
    required Color badgeColor,
    required String botonTexto,
    required Color botonColor,
    required Color bordeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF512165),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bordeColor, width: 1.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 25, backgroundImage: NetworkImage(avatar)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.emoji_events, color: badgeColor, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        puesto,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Botón rosado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: botonColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                botonTexto,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ITEM NORMAL ---
  Widget _itemNormal(String name, int monto, String puesto, String avatar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF462055),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatar)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$name\n$monto Bs",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Text(
            puesto,
            style: const TextStyle(color: Colors.white54, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
