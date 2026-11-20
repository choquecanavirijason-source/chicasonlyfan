import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Video corto en bucle y sin sonido, para usar de fondo decorativo
/// (el efecto "gif" de las tarjetas de paquetes).
///
/// Mientras carga muestra la portada, así la tarjeta nunca queda en negro.
/// Si el video no se puede abrir, se queda en la portada y no rompe nada.
class FondoVideo extends StatefulWidget {
  final String video;
  final String portada;

  const FondoVideo({super.key, required this.video, required this.portada});

  @override
  State<FondoVideo> createState() => _FondoVideoState();
}

class _FondoVideoState extends State<FondoVideo> {
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
      await c.setVolume(0);
      await c.play();
      if (mounted) setState(() => _listo = true);
    } catch (_) {
      // Sin video, queda la portada de fondo.
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
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    }

    // FittedBox + SizedBox recorta el video para que cubra la tarjeta
    // sin deformarse, igual que BoxFit.cover con una imagen.
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
