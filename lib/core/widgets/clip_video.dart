import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Un clip del feed, a pantalla completa y en bucle.
///
/// Sólo el clip que se está viendo reproduce: los de al lado quedan
/// cargados pero en pausa, así el feed no abre diez videos a la vez.
/// Mientras carga se ve la portada, de modo que al deslizar nunca
/// aparece un hueco negro.
class ClipVideo extends StatefulWidget {
  final String video;
  final String portada;

  /// Verdadero sólo para el clip que ocupa la pantalla.
  final bool activo;

  /// El sonido arranca apagado, como en cualquier feed.
  final bool silenciado;

  const ClipVideo({
    super.key,
    required this.video,
    required this.portada,
    required this.activo,
    this.silenciado = true,
  });

  @override
  State<ClipVideo> createState() => _ClipVideoState();
}

class _ClipVideoState extends State<ClipVideo> {
  VideoPlayerController? _c;
  bool _listo = false;

  @override
  void initState() {
    super.initState();
    _arrancar();
  }

  Future<void> _arrancar() async {
    final c = VideoPlayerController.asset(widget.video);
    _c = c;
    try {
      await c.initialize();
      await c.setLooping(true);
      await c.setVolume(widget.silenciado ? 0 : 1);
      if (widget.activo) await c.play();
      if (mounted) setState(() => _listo = true);
    } catch (_) {
      // Si el clip no abre queda la portada: el feed sigue andando.
    }
  }

  @override
  void didUpdateWidget(ClipVideo viejo) {
    super.didUpdateWidget(viejo);
    final c = _c;
    if (c == null || !_listo) return;
    if (widget.activo != viejo.activo) {
      widget.activo ? c.play() : c.pause();
    }
    if (widget.silenciado != viejo.silenciado) {
      c.setVolume(widget.silenciado ? 0 : 1);
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _c;
    if (!_listo || c == null) {
      return Image.asset(
        widget.portada,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
      );
    }

    // Recorta el video a la pantalla sin deformarlo, igual que
    // BoxFit.cover con una imagen.
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: c.value.size.width,
        height: c.value.size.height,
        child: VideoPlayer(c),
      ),
    );
  }
}
