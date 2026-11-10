import 'package:chicas_app/features/female/content/screens/contenido_screen.dart';
import 'package:chicas_app/features/female/streaming/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ContnScreen extends StatelessWidget {
  const ContnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomNavBar(context, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _header(),

              const SizedBox(height: 20),
              _statsRow(),

              const SizedBox(height: 25),
              const Text(
                "Vista Pública",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4c3a57),
                ),
              ),

              const SizedBox(height: 12),
              _publicViewCard(),

              const SizedBox(height: 20),
              const Text(
                "Actividad Reciente",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4c3a57),
                ),
              ),

              const SizedBox(height: 10),
              _activityItem("Ganaste 45 nuevos seguidores", "Hace 2 horas"),
              _activityItem(
                "Tus videos recibieron 1.2K \n interacciones",
                " Hace 4 horas",
              ),
              _activityItem(
                "Completaste un Live de 45 minutos",
                "Hace 6 horas",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("assets/Profile2.jpg"),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "María González",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff4c3a57),
              ),
            ),
            Text(
              "● Activa",
              style: TextStyle(fontSize: 13, color: Colors.green),
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: const [
            Icon(Icons.notifications_none, color: Color(0xff4c3a57)),
            SizedBox(width: 14),
            Icon(Icons.settings, color: Color(0xff4c3a57)),
          ],
        ),
      ],
    );
  }

  Widget _statsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statCard("2.4K", "Visitas"),
        _statCard("15.8K", "Seguidores"),
        _statCard("48.2K", "Me gusta"),
      ],
    );
  }

  Widget _statCard(String number, String label) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.purple.shade100),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.person_outline, color: Colors.purple.shade200, size: 28),
          const SizedBox(height: 5),
          Text(
            number,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff4c3a57),
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.purple.shade300),
          ),
        ],
      ),
    );
  }

  Widget _publicViewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Colors.purple.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage("assets/profile1.jpg"),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "María González",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4c3a57),
                    ),
                  ),
                  Text(
                    "Bailarina y creadora de contenido ✨",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _videoPreview("assets/profile2.jpg"),
                _videoPreview("assets/profile3.jpg"),
                _videoPreview("assets/profile4.jpg"),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4c2050),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "👁 Ver como público",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoPreview(String img) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
      ),
      child: const Center(
        child: Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _activityItem(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.star, color: Colors.purple.shade300),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4c3a57),
                ),
              ),
              const Text("Hace 6 horas", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: const Color(0xff4c2050),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == currentIndex) return;
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ContnScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CrearContenidoPage()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChatPage()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "ContenidoScreen",
        ),
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
