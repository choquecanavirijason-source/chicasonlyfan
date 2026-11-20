import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Reproductor para el contenido subido por las creadoras (fotos y videos).
///
/// Antes las tarjetas de Favoritos no abrían nada: solo mostraban un aviso
/// "Abriendo: ..." y ahí terminaba. El único reproductor de la app era el
/// del live.
class ContenidoVideoScreen extends StatefulWidget {
  final String titulo;
  final String subtitulo;
  final String portada;

  /// Ruta del video dentro del APK. Si viene null, se muestra solo la foto.
  final String? video;

  const ContenidoVideoScreen({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.portada,
    this.video,
  });

  @override
  State<ContenidoVideoScreen> createState() => _ContenidoVideoScreenState();
}

class _ContenidoVideoScreenState extends State<ContenidoVideoScreen> {
  VideoPlayerController? _controller;
  bool _listo = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _preparar();
  }

  Future<void> _preparar() async {
    final ruta = widget.video;
    if (ruta == null) return;

    final c = VideoPlayerController.asset(ruta);
    _controller = c;
    try {
      await c.initialize();
      await c.setLooping(true);
      await c.play();
      if (mounted) setState(() => _listo = true);
    } catch (e) {
      if (mounted) setState(() => _error = 'No se pudo abrir el video.\n$e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _alternarPausa() {
    final c = _controller;
    if (c == null || !_listo) return;
    setState(() => c.value.isPlaying ? c.pause() : c.play());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: _contenido()),

          // Degradado para que el texto se lea sobre cualquier imagen.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitulo,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 12,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido() {
    if (widget.video == null) {
      return Image.asset(widget.portada, fit: BoxFit.contain);
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_off, color: Colors.white54, size: 60),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    if (!_listo) {
      // Mientras carga se muestra la portada, así no se ve un hueco negro.
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(widget.portada, fit: BoxFit.cover),
          Container(color: Colors.black38),
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      );
    }

    final c = _controller!;
    return GestureDetector(
      onTap: _alternarPausa,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(aspectRatio: c.value.aspectRatio, child: VideoPlayer(c)),
          if (!c.value.isPlaying)
            const Icon(Icons.play_arrow, color: Colors.white70, size: 80),
        ],
      ),
    );
  }
}
