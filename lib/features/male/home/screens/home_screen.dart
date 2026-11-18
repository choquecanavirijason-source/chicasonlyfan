import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:chicas_app/core/theme/chicas_tokens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentProfileIndex = 0;

  // Lista de perfiles de ejemplo
  final List<Map<String, dynamic>> _profiles = [
    {
      'siguiendo': true,
      'name': 'Carla',
      'age': 25,
      'distance': '18:32',
      'description':
          'Monday is closer and I dont want to get angry. Just get happy 🎉',
      'image': 'assets/images/profiles/chica1.jpg',
    },
    {
      'siguiendo': true,
      'name': 'María',
      'age': 23,
      'distance': '15:20',
      'description': 'Love traveling and meeting new people ✈️',
      'image': 'assets/images/profiles/chica2.jpg',
    },
    {
      'siguiendo': true,
      'name': 'Sofia',
      'age': 28,
      'distance': '20:45',
      'description': 'Coffee lover ☕ and photography enthusiast 📸',
      'image': 'assets/images/profiles/chica3.jpg',
    },
    {
      'siguiendo': false,
      'name': 'Laura',
      'age': 24,
      'distance': '12:10',
      'description': 'Bailando mis canciones favoritas ✨',
      'image': 'assets/images/profiles/chica4.jpg',
    },
    {
      'siguiendo': false,
      'name': 'Paula',
      'age': 26,
      'distance': '19:05',
      'description': 'Fin de semana de piscina y sol 🌴',
      'image': 'assets/images/profiles/chica5.jpg',
    },
    {
      'siguiendo': false,
      'name': 'Camila',
      'age': 22,
      'distance': '16:40',
      'description': 'Nuevo contenido subido hoy 💜',
      'image': 'assets/images/contenido/portada2.jpg',
    },
    {
      'siguiendo': false,
      'name': 'Valentina',
      'age': 27,
      'distance': '21:15',
      'description': 'Preparando el live de esta noche 🔥',
      'image': 'assets/images/contenido/portada5.jpg',
    },
    {
      'siguiendo': false,
      'name': 'Antonella',
      'age': 25,
      'distance': '14:55',
      'description': 'Gracias por todos los regalos de ayer 🎁',
      'image': 'assets/images/contenido/portada9.jpg',
    },
  ];

  /// "Siguiendo" muestra solo a las creadoras que el usuario ya sigue;
  /// "Para Ti" muestra el resto, a modo de descubrimiento. Antes las dos
  /// pestañas mostraban exactamente lo mismo.
  List<Map<String, dynamic>> get _perfilesVisibles {
    final enSiguiendo = _tabController.index == 0;
    return _profiles
        .where((p) => (p['siguiendo'] == true) == enSiguiendo)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Al cambiar de pestaña cambia la lista, así que hay que volver al
    // primer perfil para no quedar fuera de rango.
    _tabController.addListener(() {
      if (!mounted) return;
      setState(() => _currentProfileIndex = 0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextProfile() {
    setState(() {
      if (_currentProfileIndex < _perfilesVisibles.length - 1) {
        _currentProfileIndex++;
      } else {
        _currentProfileIndex = 0;
      }
    });
  }

  void _likeProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Te gusta este perfil! 💜'),
        duration: Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );
    _nextProfile();
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _perfilesVisibles;
    final currentProfile = visibles[_currentProfileIndex.clamp(
      0,
      visibles.length - 1,
    )];

    return Stack(
      children: [
        // Imagen de fondo del perfil
        Positioned.fill(
          // Las fotos de los perfiles viven en el APK, no en la red:
          // con Image.network siempre fallaban y se veía el ícono gris.
          child: Image.asset(
            currentProfile['image'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white54,
                ),
              );
            },
          ),
        ),

        // Gradiente oscuro en la parte inferior
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Contenido superior
        SafeArea(
          child: Column(
            children: [
              // Tabs superiores
              Container(
                color: AppColors.primary,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Siguiendo'),
                    Tab(text: 'Para Ti'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Indicador de tiempo/distancia
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Tok.superficie,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      currentProfile['distance'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Información del perfil en la parte inferior
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre y edad
                    Row(
                      children: [
                        Text(
                          currentProfile['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentProfile['age'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Descripción
                    Text(
                      currentProfile['description'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    // Sin esto parecía que hubiera un solo perfil: la pantalla
                    // muestra uno por vez y nada indicaba que hubiera más.
                    Row(
                      children: List.generate(
                        visibles.length,
                        (i) => Container(
                          width: i == _currentProfileIndex ? 20 : 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: i == _currentProfileIndex
                                ? Colors.white
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Botones de acción en el lado derecho
        Positioned(
          right: 12,
          bottom: 100,
          child: Column(
            children: [
              _buildActionButton(
                icon: Icons.share,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compartir perfil')),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                icon: Icons.favorite_border,
                onTap: _likeProfile,
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                icon: Icons.star_border,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Agregar a favoritos')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(icon, color: AppColors.primary, size: 26),
      ),
    );
  }
}
