import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/services/streaming_service.dart';
import '../../../videocall/presentation/screens/videocall_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _selectedFilter = 0;
  final TextEditingController _searchController = TextEditingController();
  final StreamingService _streamingService = StreamingService();

  // Lista de favoritos (círculos superiores)
  final List<Map<String, String>> _favorites = [
    {'name': 'Ana', 'image': 'assets/images/profiles/chica1.jpg'},
    {'name': 'María', 'image': 'assets/images/profiles/chica2.jpg'},
    {'name': 'Sofia', 'image': 'assets/images/profiles/chica3.jpg'},
    {'name': 'Laura', 'image': 'assets/images/profiles/chica4.jpg'},
    {'name': 'Paula', 'image': 'assets/images/profiles/chica5.jpg'},
  ];

  // Lista de contenido estático en grid
  final List<Map<String, dynamic>> _content = [
    {
      'type': 'FOTO',
      'title': 'Fascinado por ell',
      'subtitle': 'Nueva foto',
      'image': 'https://picsum.photos/400/600?random=3',
    },
    {
      'type': 'VIDEO',
      'title': 'Vender o renta',
      'subtitle': 'Nuevo video',
      'image': 'https://picsum.photos/400/600?random=4',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Center(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Interactúa con tu ',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    TextSpan(
                      text: 'favorita',
                      style: TextStyle(color: Color(0xFFFF69B4)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textHint,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
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
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(favorite['image']!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        favorite['name']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
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
                    child: CircularProgressIndicator(color: AppColors.primary),
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

                print('📺 Lives activos encontrados: ${activeStreams.length}');
                for (var doc in activeStreams) {
                  print('  - ${doc.id}: ${doc.data()}');
                }

                // Combinar lives activos con contenido estático
                final allContent = [
                  ...activeStreams.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'type': 'EN VIVO',
                      'title': data['userName'] ?? 'Live',
                      'subtitle': 'En vivo ahora',
                      'image':
                          data['userAvatar'] ??
                          'https://picsum.photos/400/600?random=1',
                      'isLive': true,
                      'streamId': doc.id,
                      'playbackUrl': data['playbackUrl'] ?? '',
                      'viewerCount': data['viewerCount'] ?? 0,
                    };
                  }),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
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
          // Mostrar mensaje para contenido estático
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Abriendo: ${item['title']}'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Stack(
          children: [
            // Imagen de fondo
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item['image'].startsWith('http')
                  ? Image.network(
                      item['image'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      item['image'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
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
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: item['type'] == 'EN VIVO'
                      ? [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
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
