import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../videocall/presentation/screens/videocall_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.notifications, color: Colors.white, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Notificaciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE991C5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '2 nuevas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de notificaciones
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildNotificationCard(
                    context: context,
                    avatar: 'https://randomuser.me/api/portraits/women/28.jpg',
                    name: 'Laura Torres',
                    action: 'no aceptó tu solicitud',
                    time: 'Hace 2 horas',
                    description: 'No se realizó ningún cargo a tu tarjeta',
                    icon: Icons.close_rounded,
                    iconColor: Colors.grey,
                    isAccepted: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    context: context,
                    avatar: 'https://randomuser.me/api/portraits/women/50.jpg',
                    name: 'María González',
                    action: 'aceptó tu solicitud',
                    time: 'Hace 5 minutos',
                    description: null,
                    icon: Icons.check_circle_rounded,
                    iconColor: const Color(0xFFE991C5),
                    isAccepted: true,
                    appointmentDate: 'Martes 4 de Noviembre',
                    appointmentTime: 'Hora: 15:30',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required BuildContext context,
    required String avatar,
    required String name,
    required String action,
    required String time,
    String? description,
    required IconData icon,
    required Color iconColor,
    required bool isAccepted,
    String? appointmentDate,
    String? appointmentTime,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar y título
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar con icono
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(avatar),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 16, color: iconColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' $action',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Descripción adicional
          if (description != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.credit_card, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],

          // Información de cita (si fue aceptada)
          if (isAccepted &&
              appointmentDate != null &&
              appointmentTime != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F0FC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Color(0xFFE991C5),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appointmentDate,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Color(0xFFE991C5),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appointmentTime,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Cerrar el modal de notificaciones
                  Navigator.pop(context);
                  // Abrir la videollamada
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoCallScreen(name: name, avatar: avatar),
                    ),
                  );
                },
                icon: const Icon(Icons.videocam, size: 18),
                label: const Text(
                  'Entrar a videollamada',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE991C5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
