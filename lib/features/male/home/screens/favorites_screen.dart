import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/chicas_tokens.dart';
import '../../../../shared/services/streaming_service.dart';
import '../../../videocall/presentation/screens/videocall_screen.dart';
import 'contenido_video_screen.dart';
import 'historia_screen.dart';
import 'package:chicas_app/core/widgets/fondo_video.dart';
import 'package:chicas_app/core/widgets/foto.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _selectedFilter = 0;
  final TextEditingController _searchController = TextEditingController();
  final StreamingService _streamingService = StreamingService();

  // Lista de favoritos (círculos superiores).
  // 'fav' marca a las que el usuario tiene como favoritas: llevan corazón
  // y borde resaltado. El resto aparecen como sugerencias.
  final List<Map<String, dynamic>> _favorites = [
    {
      'name': 'Ana',
      'fotos': [
        'assets/images/galeria/carla/1.jpg',
        'assets/images/galeria/carla/2.jpg',
        'assets/images/galeria/carla/3.jpg',
        'assets/images/galeria/carla/4.jpg',
        'assets/images/galeria/carla/5.jpg',
        'assets/images/galeria/carla/6.jpg',
      ],
      'video': 'assets/videos/contenido1.mp4',
      'portada': 'assets/images/contenido/portada1.jpg',
      'image': 'assets/images/profiles/avatar1.jpg',
      'fav': true,
    },
    {
      'name': 'María',
      'fotos': [
        'assets/images/galeria/maria/1.jpg',
        'assets/images/galeria/maria/2.jpg',
        'assets/images/galeria/maria/3.jpg',
      ],
      'video': 'assets/videos/contenido3.mp4',
      'portada': 'assets/images/contenido/portada3.jpg',
      'image': 'assets/images/profiles/avatar2.jpg',
      'fav': true,
    },
    {
      'name': 'Sofia',
      'fotos': [
        'assets/images/galeria/sofia/1.jpg',
        'assets/images/galeria/sofia/2.jpg',
        'assets/images/galeria/sofia/3.jpg',
      ],
      'video': 'assets/videos/contenido5.mp4',
      'portada': 'assets/images/contenido/portada5.jpg',
      'image': 'assets/images/profiles/avatar3.jpg',
      'fav': true,
    },
    {
      'name': 'Laura',
      'fotos': [
        'assets/images/galeria/laura/1.jpg',
        'assets/images/galeria/laura/2.jpg',
        'assets/images/galeria/laura/3.jpg',
      ],
      'video': 'assets/videos/contenido7.mp4',
      'portada': 'assets/images/contenido/portada7.jpg',
      'image': 'assets/images/profiles/avatar4.jpg',
      'fav': false,
    },
    {
      'name': 'Paula',
      'fotos': [
        'assets/images/galeria/paula/1.jpg',
        'assets/images/galeria/paula/2.jpg',
        'assets/images/galeria/paula/3.jpg',
      ],
      'video': 'assets/videos/contenido9.mp4',
      'portada': 'assets/images/contenido/portada9.jpg',
      'image': 'assets/images/profiles/avatar5.jpg',
      'fav': false,
    },
    {
      'name': 'Valentina',
      'fotos': [
        'assets/images/galeria/valentina/1.jpg',
        'assets/images/galeria/valentina/2.jpg',
        'assets/images/galeria/valentina/3.jpg',
        'assets/images/galeria/valentina/4.jpg',
      ],
      'video': 'assets/videos/feed/7.mp4',
      'portada': 'assets/images/feed/portada7.jpg',
      'image': 'assets/images/galeria/valentina/1.jpg',
      'fav': false,
    },
    {
      'name': 'Antonella',
      'fotos': [
        'assets/images/galeria/antonella/1.jpg',
        'assets/images/galeria/antonella/2.jpg',
        'assets/images/galeria/antonella/3.jpg',
      ],
      'video': 'assets/videos/feed/8.mp4',
      'portada': 'assets/images/feed/portada8.jpg',
      'image': 'assets/images/galeria/antonella/1.jpg',
      'fav': false,
    },
    {
      'name': 'Daniela',
      'fotos': [
        'assets/images/galeria/daniela/1.jpg',
        'assets/images/galeria/daniela/2.jpg',
        'assets/images/galeria/daniela/3.jpg',
        'assets/images/galeria/daniela/4.jpg',
      ],
      'video': 'assets/videos/feed/9.mp4',
      'portada': 'assets/images/feed/portada9.jpg',
      'image': 'assets/images/galeria/daniela/1.jpg',
      'fav': false,
    },
  ];

  int get _cantidadFavoritas =>
      _favorites.where((f) => f['fav'] == true).length;

  // Lista de contenido estático en grid
  /// Lives de demostración. Aparecen sólo cuando no hay ninguno real en
  /// Firestore, para que la sección nunca se vea vacía al mostrar la app.
  /// Apuntan a un video del APK, así funcionan sin servidor ni conexión.
  final List<Map<String, dynamic>> _livesDemo = [
    {
      'type': 'EN VIVO',
      'title': '@ana_gz',
      'subtitle': 'En vivo ahora',
      'image': 'assets/images/contenido/portada2.jpg',
      'video': 'assets/videos/contenido2.mp4',
      'isLive': true,
      'streamId': 'demo-1',
      'playbackUrl': 'assets/videos/contenido2.mp4',
      'viewerCount': 128,
    },
    {
      'type': 'EN VIVO',
      'title': '@sofi',
      'subtitle': 'En vivo ahora',
      'image': 'assets/images/contenido/portada6.jpg',
      'video': 'assets/videos/contenido6.mp4',
      'isLive': true,
      'streamId': 'demo-2',
      'playbackUrl': 'assets/videos/contenido6.mp4',
      'viewerCount': 47,
    },
  ];

  final List<Map<String, dynamic>> _content = [
    {
      'type': 'VIDEO',
      'title': 'Tarde de piscina',
      'subtitle': '@ana · hace 2 h',
      'image': 'assets/images/contenido/portada1.jpg',
      'video': 'assets/videos/contenido1.mp4',
    },
    {
      'type': 'VIDEO',
      'title': 'Probando el filtro nuevo',
      'subtitle': '@maria · hace 3 h',
      'image': 'assets/images/contenido/portada2.jpg',
      'video': 'assets/videos/contenido2.mp4',
    },
    {
      'type': 'VIDEO',
      'title': 'Antes del live',
      'subtitle': '@sofia · hace 5 h',
      'image': 'assets/images/contenido/portada3.jpg',
      'video': 'assets/videos/contenido3.mp4',
    },
    {
      'type': 'VIDEO',
      'title': 'Rutina de la mañana',
      'subtitle': '@laura · hace 8 h',
      'image': 'assets/images/contenido/portada4.jpg',
      'video': 'assets/videos/contenido4.mp4',
    },
    {
      'type': 'VIDEO',
      'title': 'Gracias por los regalos',
      'subtitle': '@paula · ayer',
      'image': 'assets/images/contenido/portada5.jpg',
      'video': 'assets/videos/contenido5.mp4',
    },
    {
      'type': 'VIDEO',
      'title': 'Bailando un ratito',
      'subtitle': '@camila · ayer',
      'image': 'assets/images/contenido/portada6.jpg',
      'video': 'assets/videos/contenido6.mp4',
    },
    {
      'type': 'VIDEO',
      'title': 'Sesión de fotos',
      'subtitle': '@valentina · ayer',
      'image': 'assets/images/contenido/portada7.jpg',
      'video': 'assets/videos/contenido7.mp4',
    },
    {
      'type': 'VIDEO',
      'title': 'Respondiendo preguntas',
      'subtitle': '@antonella · hace 2 días',
      'image': 'assets/images/contenido/portada8.jpg',
      'video': 'assets/videos/contenido8.mp4',
    },
    {
      // Decía FOTO pero reproducía video: la etiqueta tiene que decir
      // la verdad sobre lo que se abre al tocarla.
      'type': 'VIDEO',
      'title': 'Charlando un rato',
      'subtitle': '@ana · hace 2 días',
      'image': 'assets/images/contenido/portada9.jpg',
      'video': 'assets/videos/contenido9.mp4',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Tok.fondo,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título.
            // Antes usaba textPrimary (#212121) sobre fondo negro: el texto
            // quedaba invisible. Ahora va en marfil, con la serif de display.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Tok.s5,
                Tok.s5,
                Tok.s5,
                Tok.s2,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      height: 1.13,
                      fontWeight: FontWeight.w600,
                    ),
                    children: const [
                      TextSpan(
                        text: 'Interactúa con tu ',
                        style: TextStyle(color: Tok.marfil),
                      ),
                      TextSpan(
                        text: 'favorita',
                        style: TextStyle(color: Tok.oro),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Cuántas favoritas tiene el usuario, para que la fila de arriba
            // se entienda como "mis favoritas" y no como una lista cualquiera.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Tok.s5,
                Tok.s1,
                Tok.s5,
                Tok.s3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, size: 12, color: Tok.oro),
                  const SizedBox(width: Tok.s2),
                  // Etiqueta en mayúscula espaciada: la mitad del aire caro
                  // del sistema sale de este detalle.
                  Text(
                    '$_cantidadFavoritas FAVORITAS',
                    style: GoogleFonts.jost(
                      fontSize: 12,
                      height: 1.33,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                      color: Tok.oro,
                    ),
                  ),
                ],
              ),
            ),

            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(color: Tok.marfil, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  hintStyle: GoogleFonts.jost(color: Tok.humo, fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Tok.humo,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Tok.superficieAlta,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Tok.rPill),
                    borderSide: const BorderSide(color: Tok.borde, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Tok.rPill),
                    borderSide: const BorderSide(color: Tok.borde, width: 1),
                  ),
                  // Al enfocar aparece el hilo de oro: el campo activo es lo
                  // único que lo lleva en esta pantalla.
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Tok.rPill),
                    borderSide: const BorderSide(color: Tok.oro, width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Carrusel horizontal de favoritos
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final favorite = _favorites[index];
                  return GestureDetector(
                    // Por el navegador raíz, para que la historia tape
                    // también la barra inferior y se vea a pantalla completa.
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => HistoriaScreen(
                              creadoras: _favorites,
                              inicial: index,
                            ),
                          ),
                        ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: favorite['fav'] == true
                                        ? Tok.oro
                                        : Tok.borde,
                                    width: 1.5,
                                  ),
                                  // Las favoritas respiran; las sugerencias no.
                                  boxShadow: favorite['fav'] == true
                                      ? const [Tok.glowSuave]
                                      : null,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  // El estado se ve en movimiento, como en
                                  // cualquier app de historias.
                                  child: ClipOval(
                                    child: FondoVideo(
                                      video: favorite['video'] as String,
                                      portada: favorite['image'] as String,
                                    ),
                                  ),
                                ),
                              ),
                              if (favorite['fav'] == true)
                                Positioned(
                                  right: -2,
                                  bottom: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Tok.oro,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.favorite,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            favorite['name'] as String,
                            style: GoogleFonts.jost(
                              fontSize: 12,
                              color: favorite['fav'] == true
                                  ? Tok.champan
                                  : Tok.humo,
                              fontWeight: favorite['fav'] == true
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Botones de filtro
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterButton('Lives', 0),
                  const SizedBox(width: 12),
                  _buildFilterButton('Salas', 1),
                  const SizedBox(width: 12),
                  _buildFilterButton('Todo', 2),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Grid de contenido con StreamBuilder
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _streamingService.getActiveStreamsStream(),
                builder: (context, snapshot) {
                  // Debug: Log del estado
                  print(
                    '🔍 StreamBuilder - ConnectionState: ${snapshot.connectionState}',
                  );
                  print('🔍 StreamBuilder - HasData: ${snapshot.hasData}');
                  if (snapshot.hasError) {
                    print('❌ StreamBuilder Error: ${snapshot.error}');
                  }

                  // Mostrar loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  // Mostrar error si hay
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // Lista de lives activos
                  final activeStreams = snapshot.hasData
                      ? snapshot.data!.docs
                      : [];

                  print(
                    '📺 Lives activos encontrados: ${activeStreams.length}',
                  );
                  for (var doc in activeStreams) {
                    print('  - ${doc.id}: ${doc.data()}');
                  }

                  // Combinar lives activos con contenido estático
                  final allContent = [
                    // Los lives reales van primero; detrás quedan los de
                    // demostración, así la sección nunca se ve vacía aunque
                    // nadie esté transmitiendo.
                    ...activeStreams.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return {
                        'type': 'EN VIVO',
                        'title': data['userName'] ?? 'Live',
                        'subtitle': 'En vivo ahora',
                        'image': data['userAvatar'] ?? 'assets/model.jpg',
                        // Para la demo la miniatura del live va en movimiento,
                        // que es lo que un live debería parecer.
                        'video': 'assets/videos/contenido4.mp4',
                        'isLive': true,
                        'streamId': doc.id,
                        'playbackUrl': data['playbackUrl'] ?? '',
                        'viewerCount': data['viewerCount'] ?? 0,
                      };
                    }),
                    ..._livesDemo,
                    ..._content,
                  ];

                  // Filtrar según el botón seleccionado
                  List<Map<String, dynamic>> filteredContent = allContent;
                  if (_selectedFilter == 0) {
                    // Solo Lives
                    filteredContent = allContent
                        .where((item) => item['type'] == 'EN VIVO')
                        .toList();
                  } else if (_selectedFilter == 1) {
                    // Solo Salas (contenido estático)
                    filteredContent = allContent
                        .where((item) => item['type'] != 'EN VIVO')
                        .toList();
                  }

                  print(
                    '🎯 Contenido filtrado: ${filteredContent.length} items (filtro: $_selectedFilter)',
                  );

                  if (filteredContent.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.live_tv_outlined,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedFilter == 0
                                ? 'No hay lives activos'
                                : 'No hay contenido disponible',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (_selectedFilter == 0) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Espera a que tus favoritas inicien live',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: filteredContent.length,
                    itemBuilder: (context, index) {
                      final item = filteredContent[index];
                      return _buildContentCard(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: Tok.s5,
          vertical: Tok.s2 + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Tok.superficieAlta : Colors.transparent,
          borderRadius: BorderRadius.circular(Tok.rPill),
          border: Border.all(color: isSelected ? Tok.oro : Tok.borde, width: 1),
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.jost(
            color: isSelected ? Tok.champan : Tok.humo,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(Map<String, dynamic> item) {
    final isLive = item['isLive'] ?? false;

    return GestureDetector(
      onTap: () {
        if (isLive) {
          // Navegar a la pantalla de videollamada para ver el live
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoCallScreen(
                name: item['title'],
                avatar: item['image'],
                streamId: item['streamId'],
                playbackUrl: item['playbackUrl'],
              ),
            ),
          );
        } else {
          // Contenido subido: se abre en el reproductor propio.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ContenidoVideoScreen(
                titulo: item['title'],
                subtitulo: item['subtitle'] ?? '',
                portada: item['image'],
                video: item['video'],
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Tok.rL),
          color: Tok.superficie,
          // El hilo de oro solo en el live: es lo que hay que mirar.
          border: isLive ? Tok.hiloOro : Tok.hiloTenue,
          // La del live es la única que resplandece: es lo que hay que mirar.
          boxShadow: isLive
              ? const [Tok.glowOroCarta, Tok.sombraCarta]
              : const [Tok.sombraCarta],
        ),
        child: Stack(
          children: [
            // El fondo de la tarjeta. Si hay video, se reproduce en bucle
            // y sin sonido: para la demo, la grilla se ve viva en vez de
            // ser un muro de fotos quietas.
            ClipRRect(
              borderRadius: BorderRadius.circular(Tok.rL),
              child: item['video'] != null
                  ? FondoVideo(
                      video: item['video'] as String,
                      portada: item['image'] as String,
                    )
                  : foto(
                      item['image'] as String,
                      width: double.infinity,
                      height: double.infinity,
                    ),
            ),

            // Badge superior (EN VIVO, FOTO, VIDEO)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: item['type'] == 'EN VIVO'
                      ? Colors.red
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(Tok.rPill),
                  boxShadow: item['type'] == 'EN VIVO'
                      ? const [Tok.glowVivo]
                      : const [Tok.glowSuave],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item['type'] == 'EN VIVO')
                      const Icon(Icons.circle, color: Colors.white, size: 8),
                    if (item['type'] == 'EN VIVO') const SizedBox(width: 4),
                    Text(
                      item['type'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Viewer count para lives
            if (isLive)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item['viewerCount'] ?? 0}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Información inferior
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
