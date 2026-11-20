import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/chicas_tokens.dart';

/// Visor de historias, al estilo de Instagram.
///
/// Se abre desde los círculos de Favoritos. Arriba hay una barra por cada
/// foto de la creadora que se está viendo; al terminar la última se pasa
/// sola a la siguiente creadora.
///
/// Gestos: tocar a la derecha avanza, a la izquierda retrocede, mantener
/// presionado pausa, y deslizar hacia abajo cierra.
class HistoriaScreen extends StatefulWidget {
  /// Las creadoras con historia, en el orden de la fila. Cada una necesita
  /// `name` y `fotos`.
  final List<Map<String, dynamic>> creadoras;

  /// Por cuál se abre.
  final int inicial;

  const HistoriaScreen({super.key, required this.creadoras, this.inicial = 0});

  @override
  State<HistoriaScreen> createState() => _HistoriaScreenState();
}

class _HistoriaScreenState extends State<HistoriaScreen>
    with SingleTickerProviderStateMixin {
  late int _creadora;
  int _foto = 0;
  late final AnimationController _progreso;

  /// Lo que dura cada foto en pantalla.
  static const _duracion = Duration(milliseconds: 4000);

  @override
  void initState() {
    super.initState();
    _creadora = widget.inicial;
    _progreso = AnimationController(vsync: this, duration: _duracion)
      ..addStatusListener((e) {
        if (e == AnimationStatus.completed) _avanzar();
      });
    _progreso.forward();
  }

  Map<String, dynamic> get _actual => widget.creadoras[_creadora];

  List<String> get _fotos =>
      (_actual['fotos'] as List?)?.cast<String>() ??
      [_actual['image'] as String];

  void _reiniciar() {
    _progreso
      ..stop()
      ..value = 0
      ..forward();
  }

  void _avanzar() {
    if (_foto < _fotos.length - 1) {
      setState(() => _foto++);
      _reiniciar();
      return;
    }
    if (_creadora < widget.creadoras.length - 1) {
      setState(() {
        _creadora++;
        _foto = 0;
      });
      _reiniciar();
      return;
    }
    Navigator.of(context).maybePop();
  }

  void _retroceder() {
    if (_foto > 0) {
      setState(() => _foto--);
      _reiniciar();
      return;
    }
    if (_creadora > 0) {
      setState(() {
        _creadora--;
        // Al volver atrás se entra por la última foto de esa creadora,
        // que es donde uno la dejó.
        _foto = _fotos.length - 1;
      });
      _reiniciar();
      return;
    }
    _reiniciar();
  }

  @override
  void dispose() {
    _progreso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final fotos = _fotos;
    final actual = fotos[_foto.clamp(0, fotos.length - 1)];

    return Scaffold(
      backgroundColor: Tok.fondo,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (d) =>
            d.globalPosition.dx < ancho / 3 ? _retroceder() : _avanzar(),
        onLongPressStart: (_) => _progreso.stop(),
        onLongPressEnd: (_) => _progreso.forward(),
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) > 300) Navigator.of(context).maybePop();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(actual, fit: BoxFit.cover),

            // Degradado para que el nombre y las barras se lean sobre
            // cualquier foto.
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 220,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xCC000000), Color(0x00000000)],
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Tok.s3, Tok.s3, Tok.s3, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _barras(fotos.length),
                    const SizedBox(height: Tok.s3),
                    _encabezado(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Una barra por foto de esta creadora: las vistas llenas, la actual
  /// avanzando, las que faltan vacías.
  Widget _barras(int total) {
    return Row(
      children: List.generate(total, (i) {
        return Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
            child: AnimatedBuilder(
              animation: _progreso,
              builder: (context, _) {
                final v = i < _foto
                    ? 1.0
                    : i == _foto
                    ? _progreso.value
                    : 0.0;
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: v,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Tok.oro,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _encabezado() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Tok.oro, width: 1.5),
            image: DecorationImage(
              image: AssetImage(_actual['image'] as String),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: Tok.s3),
        Expanded(
          child: Text(
            _actual['name'] as String,
            style: GoogleFonts.jost(
              color: Tok.marfil,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.close, color: Tok.marfil),
        ),
      ],
    );
  }
}
