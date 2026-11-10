import 'package:flutter/material.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/services/streaming_service.dart';

class VideoCallScreen extends StatefulWidget {
  final String name;
  final String avatar;
  final String? streamId; // ID del stream activo
  final String? playbackUrl; // URL HLS de AWS IVS

  const VideoCallScreen({
    super.key,
    required this.name,
    required this.avatar,
    this.streamId,
    this.playbackUrl,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _seconds = 0;
  bool _isMuted = false;
  final bool _isCameraOff = false;
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  // Video Player
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  final StreamingService _streamingService = StreamingService();
  Timer? _viewerUpdateTimer;

  @override
  void initState() {
    super.initState();
    // Iniciar el contador de tiempo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });

    // Animación de parpadeo para el punto rojo
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _blinkAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(_blinkController);

    // Inicializar video player
    _initializeVideoPlayer();

    // Incrementar contador de viewers
    if (widget.streamId != null) {
      _streamingService.incrementViewerCount(widget.streamId!);
      _startViewerUpdate();
    }
  }

  void _initializeVideoPlayer() async {
    if (widget.playbackUrl == null || widget.playbackUrl!.isEmpty) {
      debugPrint('❌ No hay URL de reproducción');
      return;
    }

    debugPrint('🎬 Inicializando video player con URL: ${widget.playbackUrl}');

    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.playbackUrl!),
      );

      await _videoController!.initialize();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }

      // Configurar para loop y auto-play
      _videoController!.setLooping(true);
      await _videoController!.play();

      debugPrint('✅ Video player inicializado y reproduciendo');

      // Listener para errores
      _videoController!.addListener(() {
        if (_videoController!.value.hasError) {
          debugPrint(
            '❌ Error en video player: ${_videoController!.value.errorDescription}',
          );
        }
      });
    } catch (e) {
      debugPrint('❌ Error al inicializar video: $e');

      // Reintentar después de 3 segundos
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Conectando al stream... Esto puede tardar unos segundos',
            ),
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _initializeVideoPlayer();
          }
        });
      }
    }
  }

  void _startViewerUpdate() {
    _viewerUpdateTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (widget.streamId != null) {
        _streamingService.incrementViewerCount(widget.streamId!);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _blinkController.dispose();
    _videoController?.dispose();
    _viewerUpdateTimer?.cancel();

    // Decrementar contador de viewers
    if (widget.streamId != null) {
      _streamingService.decrementViewerCount(widget.streamId!);
    }

    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video principal (AWS IVS HLS stream)
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: _isVideoInitialized && _videoController != null
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController!.value.size.width,
                        height: _videoController!.value.size.height,
                        child: VideoPlayer(_videoController!),
                      ),
                    )
                  : Container(
                      color: Colors.grey[900],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Conectando al stream...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'AWS IVS puede tardar 5-10 segundos',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Stream ID: ${widget.streamId?.substring(0, 8) ?? "N/A"}...',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),

          // Header con nombre y tiempo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botón Sala VIP
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Sala VIP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Nombre con "Videollamada con"
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Videollamada con',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Indicador EN VIVO con tiempo (clickeable)
                      GestureDetector(
                        onTap: () {
                          _showBuyMinutesModal(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Punto rojo parpadeante
                              FadeTransition(
                                opacity: _blinkAnimation,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red,
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatTime(_seconds),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Video del usuario (esquina inferior derecha)
          Positioned(
            bottom: 120,
            right: 20,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _isCameraOff
                    ? Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(
                            Icons.videocam_off,
                            color: Colors.white54,
                            size: 40,
                          ),
                        ),
                      )
                    : Image.network(
                        'https://randomuser.me/api/portraits/men/32.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),

          // Controles inferiores
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.95),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        onTap: () {
                          setState(() {
                            _isMuted = !_isMuted;
                          });
                        },
                        isActive: !_isMuted,
                      ),
                      _buildControlButton(
                        icon: Icons.cameraswitch,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cambiar cámara'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      _buildControlButton(
                        icon: Icons.call_end,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        isEndCall: true,
                      ),
                      _buildControlButton(
                        icon: Icons.chat_bubble_outline,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Abrir chat'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      Builder(
                        builder: (btnContext) {
                          return _buildControlButton(
                            icon: Icons.more_horiz,
                            onTap: () {
                              _showMoreOptions(btnContext);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isEndCall = false,
    bool isActive = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isEndCall
              ? Colors.red
              : (isActive
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white.withOpacity(0.1)),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    // Calcular posición relativa al botón
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    if (button == null) return;

    final offset = button.localToGlobal(Offset.zero);

    // Posicionar el menú arriba del botón
    final top =
        offset.dy -
        120; // 120px arriba del botón (altura aproximada de 2 items)
    final left = offset.dx - 100; // Centrar más o menos con el botón

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Stack(
          children: [
            Positioned(
              top: top,
              left: left,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuOption(
                        context: context,
                        icon: Icons.mic_off,
                        title: 'Desactivar micrófono',
                        subtitle: 'Audio activo',
                        onTap: () {
                          Navigator.pop(dialogContext);
                          setState(() {
                            _isMuted = true;
                          });
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      _buildMenuOption(
                        context: context,
                        icon: Icons.volume_up,
                        title: 'Silenciar sala',
                        subtitle: 'Escuchando',
                        onTap: () {
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sala silenciada'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBuyMinutesModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (dialogContext) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              constraints: const BoxConstraints(maxWidth: 350),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header morado
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Comprar más minutos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Requiere aprobación de María Castro',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(dialogContext),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Lista de opciones
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildMinuteOption(
                          context: dialogContext,
                          minutes: '5 minutos',
                          price: '7 Bs',
                          paymentType: 'Pago directo',
                        ),
                        const SizedBox(height: 12),
                        _buildMinuteOption(
                          context: dialogContext,
                          minutes: '10 minutos',
                          price: '15 Bs',
                          paymentType: 'Pago directo',
                        ),
                        const SizedBox(height: 12),
                        _buildMinuteOption(
                          context: dialogContext,
                          minutes: '15 minutos',
                          price: '20 Bs',
                          paymentType: 'Pago directo',
                        ),

                        // Nota informativa
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'María González debe aprobar la compra para que se agreguen los minutos a la llamada actual.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
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
      },
    );
  }

  Widget _buildMinuteOption({
    required BuildContext context,
    required String minutes,
    required String price,
    required String paymentType,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitud enviada: $minutes por $price'),
            backgroundColor: const Color(0xFFE991C5),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  minutes,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  paymentType,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE991C5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
