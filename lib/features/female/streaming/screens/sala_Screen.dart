import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chicas_app/features/female/streaming/screens/live3_pague.dart';

class SalaScreen extends StatefulWidget {
  const SalaScreen({super.key});

  @override
  State<SalaScreen> createState() => _SalaScreenState();
}

class _SalaScreenState extends State<SalaScreen> {
  late CameraController _controller;
  bool _camaraLista = false;
  String? _error;
  List<CameraDescription> _cameras = const [];
  int _selectedCameraIndex = 0;

  int selectedImage = -1;
  int selectedButton = -1;

  final efectos = [
    {"name": "Glamour", "img": "assets/profile1.jpg"},
    {"name": "Flower", "img": "assets/profile3.jpg"},
    {"name": "Frog Hat", "img": "assets/profile4.jpg"},
    {"name": "Hearts", "img": "assets/filtro.png"},
    {"name": "Butterfly", "img": "assets/filtro1.jpg"},
    {"name": "Butter", "img": "assets/filtro2.jpg"},
  ];

  @override
  void initState() {
    super.initState();
    iniciarCamara();
  }

  Future<void> iniciarCamara() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() {
          _error = 'Permiso de cámara denegado';
          _camaraLista = false;
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _error = 'No se encontró ninguna cámara';
        });
        return;
      }

      _selectedCameraIndex = 0;
      final camera = _cameras[_selectedCameraIndex];
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller.initialize();

      if (!mounted) return;
      setState(() {
        _camaraLista = true;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'Error inicializando cámara: $e';
        _camaraLista = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> tomarFoto() async {
    if (!_controller.value.isInitialized) return;

    final foto = await _controller.takePicture();

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Foto guardada en: ${foto.path}")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _camaraLista
          ? Stack(
              children: [
                Positioned.fill(child: CameraPreview(_controller)),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 156, 67, 151),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 30),
                      child: Container(
                        height: 350,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        color: Colors.black.withValues(alpha: 0.20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  "Efectos",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              height: 110,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: efectos.length,
                                itemBuilder: (context, i) {
                                  final e = efectos[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() => selectedImage = i);
                                          },
                                          child: Container(
                                            width: 80,
                                            height: 65,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: selectedImage == i
                                                    ? const Color.fromARGB(
                                                        255,
                                                        241,
                                                        50,
                                                        104,
                                                      )
                                                    : Colors.transparent,
                                                width: 3,
                                              ),
                                            ),
                                            child: Image.asset(
                                              e["img"]!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          e["name"]!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _iconBtn(0, Icons.flip_camera_ios, "Voltear"),
                                const SizedBox(width: 13),
                                _iconBtn(
                                  1,
                                  Icons.filter_alt_outlined,
                                  "Filtros",
                                ),
                                const SizedBox(width: 13),
                                _iconBtn(2, Icons.auto_awesome, "Efectos"),
                                const SizedBox(width: 13),
                                _iconBtn(3, Icons.people_alt_outlined, "Doble"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ---------------- INICIAR LIVE ----------------
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 270,
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 142, 234),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color.fromARGB(255, 244, 94, 144),
                          width: 1,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConfiguracionSalaPanel(),
                            ),
                          );
                        },
                        child: const Text(
                          "Iniciar Sala",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    if (_error != null)
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  // ----------- BOTONE INFERIORES -----------
  Widget _iconBtn(
    int index,
    IconData icon,
    String label, {
    EdgeInsets? padding,
  }) {
    final bool active = selectedButton == index;

    return GestureDetector(
      onTap: () async {
        setState(() => selectedButton = index);
        if (index == 0) {
          await _switchCamera();
        }
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: padding ?? const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: active
                  ? Colors.pinkAccent
                  : Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: active
                  ? Colors.white
                  : const Color.fromARGB(255, 255, 255, 255),
              size: 23,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: active
                  ? const Color.fromARGB(255, 244, 94, 144)
                  : const Color.fromARGB(255, 255, 255, 255),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    try {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
      final camera = _cameras[_selectedCameraIndex];
      final prev = _controller;
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller.initialize();
      await prev.dispose();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      setState(() {
        _error = 'Error al cambiar cámara: $e';
      });
    }
  }
}
