import 'package:flutter/material.dart';
import 'package:chicas_app/features/female/content/screens/contn_screen.dart';
import 'package:chicas_app/features/female/content/screens/contenido_screen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int filtroIndex = 0; // 0 = Todos, 1 = En línea, 2 = VIP

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3b0a42),
      bottomNavigationBar: _bottomNavBar(context, 2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Chats",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // ------------------ BUSCADOR ------------------
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    hintText: "Buscar conversaciones...",
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ------------------ FILTROS ------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _filtroBtn("Todos", 0),
                  _filtroBtn("En línea", 1),
                  _filtroBtn("VIP", 2),
                ],
              ),

              const SizedBox(height: 20),

              // ------------------ chats ------------------
              Expanded(
                child: ListView(
                  children: [
                    _chatItem(
                      img: "assets/user1.jpg",
                      nombre: "Mario Castro",
                      online: true,
                      mensaje: "Gracias por el regalo! 💕",
                      notificaciones: 2,
                    ),
                    _chatItem(
                      img: "assets/user2.jpg",
                      nombre: "Sofía Ramirez",
                      online: true,
                      mensaje: "Nos vemos mañana en la transmisión",
                      notificaciones: 1,
                    ),
                    _chatItem(
                      img: "assets/user3.jpg",
                      nombre: "Laura Torres",
                      online: false,
                      vip: true,
                      mensaje: "Hasta pronto! 👋",
                      notificaciones: 0,
                    ),
                    _chatItem(
                      img: "assets/user4.jpg",
                      nombre: "Eduardo Sanc",
                      online: false,
                      mensaje: "Estoy esperando en la sala",
                      vip: true,
                      notificaciones: 2,
                    ),
                    _chatItem(
                      img: "assets/user5.jpg",
                      nombre: "Carmen López",
                      online: true,
                      mensaje: "¿Dónde está la transmisión?",
                      notificaciones: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ boton filtro ------------------
  Widget _filtroBtn(String text, int index) {
    final isActive = filtroIndex == index;

    return GestureDetector(
      onTap: () => setState(() => filtroIndex = index),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? Colors.white : Colors.white38),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ------------------ items chat ------------------
  Widget _chatItem({
    required String img,
    required String nombre,
    required bool online,
    required String mensaje,
    bool vip = false,
    int notificaciones = 0,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.07),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(radius: 28, backgroundImage: AssetImage(img)),
              if (online)
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 14),

          // Nombre y mensaje
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (vip)
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(Icons.star, color: Colors.yellow, size: 18),
                      ),
                  ],
                ),
                Text(
                  online ? "Activa ahora" : mensaje,
                  style: TextStyle(
                    color: online ? Colors.greenAccent : Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Badge notificaciones
          if (notificaciones > 0)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.circle,
              ),
              child: Text(
                "$notificaciones",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  // ------------------bottom nav ChatPage ------------------
  Widget _bottomNavBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: const Color(0xff4c2050),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (i) {
        if (i == currentIndex) return;
        switch (i) {
          case 0:
            //perfil
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ContnScreen()),
            );
            break;
          case 1:
            //crear
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CrearContenidoPage()),
            );
            break;
          case 2:
            //chat
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChatPage()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "ContScreen"),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: "ContenidoScreen",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: "MensajeríaScreen",
        ),
      ],
    );
  }
}
