import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:chicas_app/features/female/earnings/screens/donadores_screen.dart';
import 'package:chicas_app/features/female/content/screens/contenido_screen.dart';
import 'package:chicas_app/shared/services/streaming_service.dart';
import 'package:chicas_app/core/config/aws_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LiveScreen extends StatefulWidget {
  final String? existingStreamId;

  const LiveScreen({super.key, this.existingStreamId});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  late CameraController _controller;
  bool camaraLista = false;

  // AWS IVS Streaming
  ApiVideoLiveStreamController? _liveStreamController;
  final StreamingService _streamingService = StreamingService();
  String? _streamId;
  bool _isStreaming = false;
  int _viewerCount = 0;
  Timer? _viewerTimer;

  int botonSeleccionado = -1;

  // ===== NUEVAS VARIABLES =====
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Map<String, String>> mensajes = [
    {
      "img": "assets/user1.jpg",
      "nombre": "Mario Castro",
      "mensaje": "Hola a todos 👋",
    },
    {
      "img": "assets/user2.jpg",
      "nombre": "Sofía Ramirez",
      "mensaje": "Bienvenidos al Live!",
    },
    {
      "img": "assets/user3.jpg",
      "nombre": "Laura Torres",
      "mensaje": "Qué bonita cámara 😍",
    },
  ];

  Timer? _timer;
  int _contadorMensajes = 30;

  @override
  void initState() {
    super.initState();
    iniciarCamara();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      iniciarMensajesAutomaticos();

      // Si ya existe un streamId, no iniciar nuevo streaming
      if (widget.existingStreamId != null) {
        setState(() {
          _streamId = widget.existingStreamId;
          _isStreaming = true;
        });
        print('📺 Reconectando a stream existente: ${widget.existingStreamId}');
        _iniciarStreaming();
      } else {
        _iniciarStreaming();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _viewerTimer?.cancel();
    _detenerStreaming();
    try {
      if (camaraLista && _controller.value.isInitialized) {
        _controller.dispose();
      }
    } catch (e) {
      // si el controlador no fue inicializado, ignorar
    }
    super.dispose();
  }

  // ===== INICIAR CAMARA =====
  Future<void> iniciarCamara() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() => camaraLista = false);
        }
        return;
      }

      final camaraTrasera = cameras.first;

      _controller = CameraController(
        camaraTrasera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _controller.initialize();

      if (mounted) {
        setState(() {
          camaraLista = _controller.value.isInitialized;
        });
      }
    } on CameraException catch (e) {
      debugPrint('CameraException iniciarCamara: $e');
      if (mounted) setState(() => camaraLista = false);
    } catch (e) {
      debugPrint('Error iniciarCamara: $e');
      if (mounted) setState(() => camaraLista = false);
    }
  }

  // ===== AWS IVS STREAMING =====
  Future<void> _iniciarStreaming() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('❌ Usuario no autenticado');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Debes estar autenticado para iniciar un live'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      debugPrint('✅ Usuario autenticado: ${user.uid}');

      // Si no existe un streamId, crear sesión en Firestore
      if (_streamId == null) {
        final streamId = await _streamingService.startStreaming(
          userId: user.uid,
          userName: '@maria_gz', // TODO: Get from user profile
          userAvatar: 'assets/model.jpg', // TODO: Get from user profile
        );

        debugPrint('✅ Stream registrado en Firestore: $streamId');

        setState(() {
          _streamId = streamId;
        });
      } else {
        debugPrint('📺 Usando stream existente: $_streamId');
      }

      // Inicializar LiveStreamController
      _liveStreamController = ApiVideoLiveStreamController(
        initialAudioConfig: AudioConfig(),
        initialVideoConfig: VideoConfig.withDefaultBitrate(
          resolution: Resolution.RESOLUTION_720,
        ),
        onConnectionSuccess: () {
          debugPrint('✅ Conectado a AWS IVS');
          if (mounted) {
            setState(() => _isStreaming = true);
            _iniciarContadorViewers();
          }
        },
        onConnectionFailed: (error) {
          debugPrint('❌ Error de conexión: $error');
          if (mounted) setState(() => _isStreaming = false);
        },
        onDisconnection: () {
          debugPrint('🔌 Desconectado de AWS IVS');
          if (mounted) setState(() => _isStreaming = false);
        },
      );

      // Inicializar el controlador
      await _liveStreamController!.initialize();

      // Iniciar streaming a AWS IVS
      await _liveStreamController!.startStreaming(
        streamKey: AWSConfig.streamKey,
        url: AWSConfig.ingestEndpoint,
      );

      debugPrint('🎥 Streaming iniciado a AWS IVS');
    } on FirebaseException catch (e) {
      debugPrint('❌ Firebase Error: ${e.code} - ${e.message}');
      if (mounted) {
        String errorMessage = 'Error al iniciar transmisión';

        if (e.code == 'permission-denied') {
          errorMessage =
              'Error de permisos: Configura las reglas de Firestore.\nVe a SOLUCION_PERMISOS_FIRESTORE.md';
        } else if (e.code == 'unavailable') {
          errorMessage = 'Sin conexión a internet';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error al iniciar streaming: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar transmisión: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _detenerStreaming() async {
    try {
      // Detener streaming
      await _liveStreamController?.stopStreaming();
      _liveStreamController?.dispose();
      _liveStreamController = null;

      // Actualizar Firestore
      if (_streamId != null) {
        await _streamingService.stopStreaming(_streamId!);
      }

      setState(() {
        _isStreaming = false;
        _streamId = null;
        _viewerCount = 0;
      });

      debugPrint('🛑 Streaming detenido');
    } catch (e) {
      debugPrint('Error al detener streaming: $e');
    }
  }

  void _iniciarContadorViewers() {
    _viewerTimer?.cancel();
    _viewerTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (_streamId != null) {
        final count = await _streamingService.getViewerCount(_streamId!);
        if (mounted) {
          setState(() => _viewerCount = count);
        }
      }
    });
  }

  // ===== MENSAJES AUTOMÁTICOS CON ANIMACIÓN =====
  void iniciarMensajesAutomaticos() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _contadorMensajes++;
      Map<String, String> nuevo = {
        "img": "assets/user${(_contadorMensajes % 5) + 1}.jpg",
        "nombre": "Usuario $_contadorMensajes",
        "mensaje": "Mensaje automático $_contadorMensajes ✨",
      };
      mensajes.insert(0, nuevo);
      _listKey.currentState?.insertItem(
        0,
        duration: const Duration(milliseconds: 50),
      );

      // Limitar lista a 20 mensajes
      if (mensajes.length > 20) {
        mensajes.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ===== FONDO DE CÁMARA / STREAMING =====
          Positioned.fill(
            child: _liveStreamController != null && _isStreaming
                ? ApiVideoCameraPreview(controller: _liveStreamController!)
                : camaraLista
                ? CameraPreview(_controller)
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
          ),

          // ===== BARRA SUPERIOR =====
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- BURBUJA IZQUIERDA ---
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      20,
                      20,
                      20,
                    ).withOpacity(0.50),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.pinkAccent, Colors.orange],
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage("assets/model.jpg"),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // --- TEXTO IZQUIERDO ---
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "@maria_gz",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              if (_isStreaming)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              Text(
                                _isStreaming ? "EN VIVO" : "Iniciando...",
                                style: TextStyle(
                                  color: _isStreaming
                                      ? Colors.red
                                      : Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.remove_red_eye,
                                color: Colors.white70,
                                size: 14,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '$_viewerCount',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // --- AVATARES DERECHA ---
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RankingDonadores(),
                          ),
                        );
                      },
                      child: _miniViewer(
                        "assets/view1.jpg",
                        Colors.yellow,
                        "1",
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RankingDonadores(),
                          ),
                        );
                      },
                      child: _miniViewer(
                        "assets/view2.jpg",
                        Colors.purple,
                        "2",
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RankingDonadores(),
                          ),
                        );
                      },
                      child: _miniViewer(
                        "assets/view3.jpg",
                        Colors.orange,
                        "3",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===== AVATARES IZQUIERDA =====
          Positioned(
            top: 120,
            left: 10,
            child: Column(
              children: [
                _avatar("assets/profile1.png"),
                const SizedBox(height: 10),
                _avatar("assets/a2.png"),
                const SizedBox(height: 10),
                _avatar("assets/a3.png"),
                const SizedBox(height: 10),
                _avatar("assets/a4.png"),
                const SizedBox(height: 20),

                // Botón "+"
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),

          // ===== BOTONES DERECHA =====
          Positioned(
            right: 10,
            bottom: 200,
            child: Column(
              children: [
                _rightBtn(Icons.flip_camera_android, "Voltear", 0),
                const SizedBox(height: 22),
                _rightBtn(Icons.filter_alt_rounded, "Filtros", 1),
                const SizedBox(height: 22),
                _rightBtn(Icons.auto_fix_high, "Efectos", 2),
                const SizedBox(height: 22),
                _rightBtn(Icons.people_alt, "Doble", 3),
                const SizedBox(height: 22),
                _rightBtn(Icons.text_fields, "Texto", 4),
              ],
            ),
          ),

          // ===== LISTA DE COMENTARIOS =====
          Positioned(
            left: 10,
            bottom: 120,
            width: 260,
            height: 240,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.white],
                  stops: [0.0, 0.15],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: AnimatedList(
                key: _listKey,
                reverse: true,
                padding: const EdgeInsets.only(bottom: 20),
                initialItemCount: mensajes.length,
                itemBuilder: (context, index, animation) {
                  final item = mensajes[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: 0.0,
                    child: _chatItem(
                      img: item["img"]!,
                      nombre: item["nombre"]!,
                      online: false,
                      mensaje: item["mensaje"]!,
                    ),
                  );
                },
              ),
            ),
          ),

          // ===== INPUT DE COMENTARIO =====
          Positioned(
            left: 10,
            right: 10,
            bottom: 70,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        58,
                        57,
                        57,
                      ).withOpacity(0.20),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Escribe un comentario...",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.pinkAccent, Colors.orange],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),

          // ===== BOTÓN FINALIZAR =====
          Positioned(
            bottom: 8,
            right: 12,
            child: GestureDetector(
              onTap: () async {
                await _detenerStreaming();
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CrearContenidoPage(),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 84, 21, 89),
                      Color.fromARGB(255, 249, 101, 177),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Text(
                  "Finalizar Sala",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ), //termina boton finalizar
        ],
      ),
    );
  }

  // ================== Widgets ==================

  Widget _avatar(String img) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
      ),
    );
  }

  // Función única de botones derechos
  Widget _rightBtn(IconData icon, String text, int index) {
    bool activo = botonSeleccionado == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          botonSeleccionado = index;
        });
      },
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: activo
                  ? Colors.pinkAccent
                  : Colors.white.withOpacity(0.20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 5),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _chatItem({
    required String img,
    required String nombre,
    required bool online,
    required String mensaje,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 16, backgroundImage: AssetImage(img)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mensaje,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniViewer(String img, Color color, String number) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          child: CircleAvatar(radius: 18, backgroundImage: AssetImage(img)),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
