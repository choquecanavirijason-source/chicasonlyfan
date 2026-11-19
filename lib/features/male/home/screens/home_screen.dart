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

  /// Qué foto de la galería se está viendo, y el controlador que permite
  /// recorrerlas deslizando al costado.
  int _fotoActual = 0;
  final PageController _fotos = PageController();

  // Lista de perfiles de ejemplo
  // Cada perfil tiene su galería: varias fotos de la misma chica, que se
  // recorren deslizando al costado. Antes había una sola foto por perfil y
  // los puntos no llevaban a ninguna parte.
  final List<Map<String, dynamic>> _profiles = [
    {
      'siguiendo': true,
      'name': 'Carla',
      'age': 25,
      'distance': '18:32',
      'description':
          'Monday is closer and I dont want to get angry. Just get happy 🎉',
      'fotos': [
        'assets/images/galeria/carla/1.jpg',
        'assets/images/galeria/carla/2.jpg',
        'assets/images/galeria/carla/3.jpg',
        'assets/images/galeria/carla/4.jpg',
        'assets/images/galeria/carla/5.jpg',
        'assets/images/galeria/carla/6.jpg',
      ],
    },
    {
      'siguiendo': true,
      'name': 'María',
      'age': 23,
      'distance': '15:20',
      'description': 'Love traveling and meeting new people ✈️',
      'fotos': [
        'assets/images/galeria/maria/1.jpg',
        'assets/images/galeria/maria/2.jpg',
        'assets/images/galeria/maria/3.jpg',
      ],
    },
    {
      'siguiendo': true,
      'name': 'Sofia',
      'age': 28,
      'distance': '20:45',
      'description': 'Coffee lover ☕ and photography enthusiast 📸',
      'fotos': [
        'assets/images/galeria/sofia/1.jpg',
        'assets/images/galeria/sofia/2.jpg',
        'assets/images/galeria/sofia/3.jpg',
      ],
    },
    {
      'siguiendo': false,
      'name': 'Laura',
      'age': 24,
      'distance': '12:10',
      'description': 'Bailando mis canciones favoritas ✨',
      'fotos': [
        'assets/images/galeria/laura/1.jpg',
        'assets/images/galeria/laura/2.jpg',
        'assets/images/galeria/laura/3.jpg',
      ],
    },
    {
      'siguiendo': false,
      'name': 'Paula',
      'age': 26,
      'distance': '19:05',
      'description': 'Fin de semana de piscina y sol 🌴',
      'fotos': [
        'assets/images/galeria/paula/1.jpg',
        'assets/images/galeria/paula/2.jpg',
        'assets/images/galeria/paula/3.jpg',
      ],
    },
    {
      'siguiendo': false,
      'name': 'Camila',
      'age': 22,
      'distance': '16:40',
      'description': 'Nuevo contenido subido hoy 💜',
      'fotos': [
        'assets/images/galeria/camila/1.jpg',
        'assets/images/galeria/camila/2.jpg',
      ],
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
      setState(() {
        _currentProfileIndex = 0;
        _fotoActual = 0;
      });
      if (_fotos.hasClients) _fotos.jumpToPage(0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fotos.dispose();
    super.dispose();
  }

  /// Al cambiar de perfil la galería vuelve a empezar, si no el nuevo
  /// perfil se abriría en la foto 4 porque el anterior estaba ahí.
  void _reiniciarGaleria() {
    _fotoActual = 0;
    if (_fotos.hasClients) _fotos.jumpToPage(0);
  }

  void _perfilAnterior() {
    setState(() {
      if (_currentProfileIndex > 0) {
        _currentProfileIndex--;
      } else {
        _currentProfileIndex = _perfilesVisibles.length - 1;
      }
      _reiniciarGaleria();
    });
  }

  void _nextProfile() {
    setState(() {
      if (_currentProfileIndex < _perfilesVisibles.length - 1) {
        _currentProfileIndex++;
      } else {
        _currentProfileIndex = 0;
      }
      _reiniciarGaleria();
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
    final currentProfile =
        visibles[_currentProfileIndex.clamp(0, visibles.length - 1)];

    final fotos = (currentProfile['fotos'] as List).cast<String>();

    return Stack(
      children: [
        // La galería del perfil. Se recorre deslizando al costado; antes
        // había una sola foto fija y los puntos no llevaban a ninguna parte.
        Positioned.fill(
          // Deslizar hacia arriba pasa al siguiente perfil, hacia abajo al
          // anterior. El PageView de las fotos sólo reclama los arrastres
          // horizontales, así que los verticales llegan hasta acá.
          child: GestureDetector(
            onVerticalDragEnd: (d) {
              final v = d.primaryVelocity ?? 0;
              if (v < -300) {
                _nextProfile();
              } else if (v > 300) {
                _perfilAnterior();
              }
            },
            child: PageView.builder(
              controller: _fotos,
              itemCount: fotos.length,
              onPageChanged: (i) => setState(() => _fotoActual = i),
              itemBuilder: (context, i) => Image.asset(
                fotos[i],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Tok.superficie,
                  child: const Icon(Icons.person, size: 100, color: Tok.humo),
                ),
              ),
            ),
          ),
        ),

        // Gradiente oscuro en la parte inferior.
        // IgnorePointer es lo que hace que la galería se pueda deslizar:
        // esta capa cubre toda la pantalla y, sin esto, se quedaba con el
        // gesto antes de que llegara a las fotos.
        Positioned.fill(
          child: IgnorePointer(
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
        ),

        // Contenido superior
        SafeArea(
          child: Column(
            children: [
              // Tabs superiores
              Container(
                // El oro es una línea, no una superficie: la barra va en
                // negro y el oro marca sólo la pestaña activa.
                color: Tok.fondo,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Tok.oro,
                  indicatorWeight: 2,
                  labelColor: Tok.oro,
                  unselectedLabelColor: Tok.humo,
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
                      // Un punto por foto de la galería, no por perfil:
                      // es lo que el gesto de deslizar recorre.
                      children: List.generate(
                        fotos.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          width: i == _fotoActual ? 20 : 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: i == _fotoActual ? Tok.oro : Colors.white38,
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
