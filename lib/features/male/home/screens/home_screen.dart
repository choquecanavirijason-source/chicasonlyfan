import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:chicas_app/core/theme/chicas_tokens.dart';
import '../../../../core/widgets/clip_video.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// El feed: un clip por pantalla, se pasa deslizando hacia arriba.
///
/// Antes era una galería de fotos fijas. Ahora cada chica entra con su
/// video, que arranca solo y queda en bucle; el de al lado se detiene
/// para no tener diez videos sonando a la vez.
///
/// Algunos clips son VIP: se ven borrosos hasta que el usuario compra un
/// paquete, y el botón lleva directo a la pantalla de paquetes.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late PageController _paginas;

  /// Qué clip de la lista visible se está viendo.
  int _clip = 0;

  /// El sonido arranca apagado y se enciende con el botón del costado.
  bool _silencio = true;

  /// Los clips del feed. 'siguiendo' decide en qué pestaña aparece y
  /// 'vip' si hay que pagar para verlo.
  final List<Map<String, dynamic>> _clips = [
    {
      'name': 'Carla',
      'age': 25,
      'texto': 'Lunes de grabar un ratito para ustedes 🎬',
      'video': 'assets/videos/feed/1.mp4',
      'portada': 'assets/images/feed/portada1.jpg',
      'siguiendo': true,
      'vip': false,
      'likes': '12.4k',
    },
    {
      'name': 'María',
      'age': 23,
      'texto': 'Probando el vestido nuevo ✨',
      'video': 'assets/videos/feed/2.mp4',
      'portada': 'assets/images/feed/portada2.jpg',
      'siguiendo': true,
      'vip': false,
      'likes': '8.902',
    },
    {
      'name': 'Sofia',
      'age': 28,
      'texto': 'Lo que pasa después de esto es sólo para VIP 🔥',
      'video': 'assets/videos/feed/3.mp4',
      'portada': 'assets/images/feed/portada3.jpg',
      'siguiendo': true,
      'vip': true,
      'likes': '21.1k',
    },
    {
      'name': 'Laura',
      'age': 24,
      'texto': 'Bailando mis canciones favoritas 💃',
      'video': 'assets/videos/feed/4.mp4',
      'portada': 'assets/images/feed/portada4.jpg',
      'siguiendo': true,
      'vip': false,
      'likes': '5.431',
    },
    {
      'name': 'Paula',
      'age': 26,
      'texto': 'Domingo de piscina y sol 🌴',
      'video': 'assets/videos/feed/5.mp4',
      'portada': 'assets/images/feed/portada5.jpg',
      'siguiendo': true,
      'vip': false,
      'likes': '9.820',
    },
    {
      'name': 'Camila',
      'age': 22,
      'texto': 'Subí algo nuevo, está en mi sala privada 🔒',
      'video': 'assets/videos/feed/6.mp4',
      'portada': 'assets/images/feed/portada6.jpg',
      'siguiendo': true,
      'vip': true,
      'likes': '17.6k',
    },
    {
      'name': 'Valentina',
      'age': 24,
      'texto': 'Primera vez por acá, sean buenos conmigo 😘',
      'video': 'assets/videos/feed/7.mp4',
      'portada': 'assets/images/feed/portada7.jpg',
      'siguiendo': false,
      'vip': false,
      'likes': '3.204',
    },
    {
      'name': 'Antonella',
      'age': 27,
      'texto': 'Ensayando la rutina de la noche 🎧',
      'video': 'assets/videos/feed/8.mp4',
      'portada': 'assets/images/feed/portada8.jpg',
      'siguiendo': false,
      'vip': false,
      'likes': '6.118',
    },
    {
      'name': 'Daniela',
      'age': 23,
      'texto': 'El resto del video lo tengo guardado para mis VIP 💎',
      'video': 'assets/videos/feed/9.mp4',
      'portada': 'assets/images/feed/portada9.jpg',
      'siguiendo': false,
      'vip': true,
      'likes': '14.9k',
    },
    {
      'name': 'Luciana',
      'age': 25,
      'texto': 'Tarde tranquila en casa ☕',
      'video': 'assets/videos/feed/10.mp4',
      'portada': 'assets/images/feed/portada10.jpg',
      'siguiendo': false,
      'vip': false,
      'likes': '7.735',
    },
    {
      'name': 'Renata',
      'age': 21,
      'texto': 'Me arreglo y salimos en vivo 💄',
      'video': 'assets/videos/feed/11.mp4',
      'portada': 'assets/images/feed/portada11.jpg',
      'siguiendo': false,
      'vip': false,
      'likes': '4.560',
    },
    {
      'name': 'Isabela',
      'age': 26,
      'texto': 'Esto no lo subo a ninguna otra parte 🔥',
      'video': 'assets/videos/feed/12.mp4',
      'portada': 'assets/images/feed/portada12.jpg',
      'siguiendo': false,
      'vip': true,
      'likes': '25.3k',
    },
  ];

  /// "Siguiendo" muestra a las que el usuario ya sigue; "Para Ti", el
  /// resto, a modo de descubrimiento.
  List<Map<String, dynamic>> get _visibles {
    final enSiguiendo = _tabs.index == 0;
    return _clips
        .where((c) => (c['siguiendo'] == true) == enSiguiendo)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _paginas = PageController();
    _tabs = TabController(length: 2, vsync: this);
    // Al cambiar de pestaña cambia la lista entera, así que el feed
    // vuelve al primer clip para no quedar fuera de rango.
    _tabs.addListener(() {
      if (!mounted) return;
      setState(() => _clip = 0);
      if (_paginas.hasClients) _paginas.jumpToPage(0);
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    _paginas.dispose();
    super.dispose();
  }

  /// Va a la pestaña de Paquetes por la ruta, no empujando la pantalla
  /// encima: así queda una sola barra inferior y el usuario sigue
  /// ubicado dentro de la app.
  void _abrirPaquetes() => Modular.to.navigate('/male/packages');

  void _aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        duration: const Duration(seconds: 1),
        backgroundColor: Tok.superficieAlta,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _visibles;

    return Stack(
      children: [
        // El feed en sí: un clip por página, deslizando hacia arriba.
        PageView.builder(
          controller: _paginas,
          scrollDirection: Axis.vertical,
          itemCount: visibles.length,
          onPageChanged: (i) => setState(() => _clip = i),
          itemBuilder: (context, i) => _tarjetaClip(visibles[i], i == _clip),
        ),

        // Las pestañas van encima del video, sin fondo: el clip se ve
        // completo de borde a borde.
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 260,
              child: TabBar(
                controller: _tabs,
                indicatorColor: Tok.oro,
                indicatorWeight: 2,
                dividerColor: Colors.transparent,
                labelColor: Tok.oro,
                unselectedLabelColor: Colors.white,
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
          ),
        ),
      ],
    );
  }

  /// Un clip a pantalla completa: el video, el degradado, los datos de
  /// la chica y la botonera del costado.
  Widget _tarjetaClip(Map<String, dynamic> c, bool activo) {
    final vip = c['vip'] == true;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipVideo(
          // La clave es el archivo: al cambiar de pestaña la lista cambia
          // entera y, sin esto, Flutter reusaba el reproductor y seguía
          // viéndose el clip anterior con el nombre nuevo.
          key: ValueKey(c['video']),
          video: c['video'] as String,
          portada: c['portada'] as String,
          activo: activo,
          silenciado: _silencio,
        ),

        // Un clip VIP se ve, pero borroso: se entiende qué hay detrás
        // sin mostrarlo.
        if (vip) _candado(),

        // Degradado para que el texto se lea sobre cualquier clip.
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.45),
                  Colors.transparent,
                  Colors.black.withOpacity(0.85),
                ],
                stops: const [0.0, 0.35, 1.0],
              ),
            ),
          ),
        ),

        _datos(c, vip),
        _botonera(c, vip),
      ],
    );
  }

  Widget _candado() {
    return Stack(
      fit: StackFit.expand,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(color: Colors.black.withOpacity(0.35)),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Tok.oro, width: 1.5),
                  color: Colors.black.withOpacity(0.4),
                  boxShadow: const [Tok.glowOro],
                ),
                child: const Icon(Icons.lock, color: Tok.oro, size: 28),
              ),
              const SizedBox(height: Tok.s4),
              Text(
                'Contenido VIP',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: Tok.s2),
              const Text(
                'Desbloquealo con cualquier paquete',
                style: TextStyle(color: Tok.humo, fontSize: 14),
              ),
              const SizedBox(height: Tok.s5),
              DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Tok.rPill)),
                  boxShadow: [Tok.glowOroCarta],
                ),
                child: ElevatedButton(
                  onPressed: _abrirPaquetes,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('HAZTE VIP'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _datos(Map<String, dynamic> c, bool vip) {
    return Positioned(
      left: Tok.s5,
      right: 84,
      bottom: Tok.s5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '${c['name']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: Tok.s2),
              Text(
                '${c['age']}',
                style: const TextStyle(color: Colors.white70, fontSize: 22),
              ),
              if (vip) ...[
                const SizedBox(width: Tok.s3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Tok.oro,
                    borderRadius: BorderRadius.circular(Tok.rPill),
                  ),
                  child: const Text(
                    'VIP',
                    style: TextStyle(
                      color: Tok.tinta,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: Tok.s2),
          Text(
            c['texto'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _botonera(Map<String, dynamic> c, bool vip) {
    return Positioned(
      right: Tok.s3,
      bottom: 90,
      child: Column(
        children: [
          _boton(
            Icons.favorite,
            etiqueta: c['likes'] as String,
            onTap: () => _aviso('Te gusta el video de ${c['name']}'),
          ),
          const SizedBox(height: Tok.s5),
          _boton(
            Icons.chat_bubble,
            etiqueta: 'Chat',
            onTap: () => _aviso('Abriendo chat con ${c['name']}'),
          ),
          const SizedBox(height: Tok.s5),
          _boton(
            vip ? Icons.lock : Icons.workspace_premium,
            etiqueta: 'VIP',
            onTap: _abrirPaquetes,
          ),
          const SizedBox(height: Tok.s5),
          _boton(
            _silencio ? Icons.volume_off : Icons.volume_up,
            etiqueta: _silencio ? 'Sin audio' : 'Audio',
            onTap: () => setState(() => _silencio = !_silencio),
          ),
        ],
      ),
    );
  }

  Widget _boton(
    IconData icono, {
    required String etiqueta,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.45),
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icono, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
