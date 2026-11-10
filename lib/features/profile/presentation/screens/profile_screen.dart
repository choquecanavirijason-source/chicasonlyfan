// filepath: d:\OnlyFansApp_Chasky\chicas-onlyfans\lib\features\profile\presentation\screens\profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../male/packages/screens/packages_screen.dart';
import '../../../chat/presentation/screens/chats_screen.dart';
import '../../../male/home/screens/favorites_screen.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Contenido scrolleable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header del perfil
                    _buildProfileHeader(),

                    const SizedBox(height: 20),

                    // Sección Mis Minutos
                    _buildMyMinutesSection(),

                    const SizedBox(height: 20),

                    // Videollamadas VIP
                    _buildVIPSection(),

                    const SizedBox(height: 20),

                    // Métodos de Pago
                    _buildPaymentMethodsSection(),

                    const SizedBox(height: 20),

                    // Seguridad y Privacidad
                    _buildSecuritySection(ref),

                    const SizedBox(height: 100), // Espacio para el menú
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Foto de perfil con badge
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE991C5), width: 3),
                ),
                child: const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage(
                    'assets/images/profiles/chico1.jpg',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE991C5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'ELITE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Nombre
          const Text(
            'Carlos Méndez',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 4),

          // Edad
          const Text(
            '28 años',
            style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),

          const SizedBox(height: 20),

          // Información de contacto
          _buildInfoRow(Icons.cake_outlined, '16 de Marzo'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone_outlined, '76543230'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.email_outlined, 'carlos.mendez@gmail.com'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF999999)),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _buildMyMinutesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mis Minutos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 16),

          // Tarjeta Minutos Live
          _buildMinutesCard(
            icon: Icons.videocam,
            title: 'Minutos Live',
            minutes: 45,
            remaining: '45 minutos restantes',
            color: const Color(0xFFE991C5),
          ),

          const SizedBox(height: 16),

          // Tarjeta Minutos Salas
          _buildMinutesCard(
            icon: Icons.people,
            title: 'Minutos Salas',
            minutes: 120,
            remaining: '120 minutos restantes',
            color: const Color(0xFF4A1A4A),
          ),
        ],
      ),
    );
  }

  Widget _buildMinutesCard({
    required IconData icon,
    required String title,
    required int minutes,
    required String remaining,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header con icono y título
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              // Badge con minutos
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$minutes min',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Minutos restantes
          Text(
            remaining,
            style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
          ),

          const SizedBox(height: 16),

          // Botón Comprar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Comprar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVIPSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Videollamadas VIP',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),

          // Solicitudes Enviadas
          _buildVIPCard(
            icon: Icons.send,
            title: 'Solicitudes Enviadas',
            count: 2,
            items: [
              {
                'name': 'María González',
                'status': 'Esperando aprobación • Hace 2 días',
              },
              {
                'name': 'Laura Torres',
                'status': 'Esperando aprobación • Hace 1 día',
              },
            ],
          ),

          const SizedBox(height: 16),

          // VIP Programadas
          _buildVIPCard(
            icon: Icons.calendar_today,
            title: 'VIP Programadas',
            count: 1,
            items: [
              {
                'name': 'Ana Rodríguez',
                'status': 'Lunes 5 de Noviembre • 19:30',
              },
            ],
            showButtons: true,
          ),

          const SizedBox(height: 16),

          // Historial VIP
          _buildVIPHistoryCard(),
        ],
      ),
    );
  }

  Widget _buildVIPCard({
    required IconData icon,
    required String title,
    required int count,
    required List<Map<String, String>> items,
    bool showButtons = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFE991C5), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE991C5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/women/1.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['status']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showButtons) ...[
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE991C5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ] else
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.close, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVIPHistoryCard() {
    final historyItems = [
      {'name': 'Sofía Martínez', 'time': 'Ayer', 'price': '65 Bs'},
      {
        'name': 'Valentina López',
        'time': '10 min • 04.04.2025',
        'price': '35 Bs',
      },
      {'name': 'Isabella Cruz', 'time': '6 min • 30.04.2025', 'price': '20 Bs'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: Color(0xFF4A1A4A), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Historial VIP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...historyItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/women/4.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          item['time']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item['price']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A1A4A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Métodos de Pago',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildPaymentMethodItem(
                  'Visa',
                  '**** 4242 • Exp. 12/26',
                  isPrincipal: true,
                ),
                const Divider(height: 24),
                _buildPaymentMethodItem('Mastercard', '**** 5880 • Exp. 08/27'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Agregar tarjeta'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE991C5),
                      side: const BorderSide(color: Color(0xFFE991C5)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const Divider(height: 24),
                _buildMenuItem(Icons.receipt_long, 'Historial de compras'),
                const SizedBox(height: 8),
                _buildMenuItem(
                  Icons.description,
                  'Configuración de facturación',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(
    String cardType,
    String cardNumber, {
    bool isPrincipal = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.credit_card,
            color: Color(0xFF4A1A4A),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    cardType,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  if (isPrincipal) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE991C5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Principal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                cardNumber,
                style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC), size: 20),
      ],
    );
  }

  Widget _buildSecuritySection(WidgetRef ref) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seguridad y Privacidad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.lock_outline, 'Cambiar contraseña'),
                    const SizedBox(height: 8),
                    _buildMenuItem(
                      Icons.verified_user_outlined,
                      'Verificación en dos pasos',
                    ),
                    const SizedBox(height: 8),
                    _buildMenuItem(
                      Icons.camera_alt_outlined,
                      'Permisos de cámara',
                    ),
                    const SizedBox(height: 8),
                    _buildMenuItem(Icons.mic_outlined, 'Permisos de micrófono'),
                    const Divider(height: 24),
                    _buildMenuItem(
                      Icons.logout,
                      'Cerrar sesión',
                      color: Colors.red,
                      onTap: () async {
                        // Mostrar diálogo de confirmación
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Cerrar sesión'),
                              content: const Text(
                                '¿Seguro que quieres cerrar sesión?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Sí'),
                                ),
                              ],
                            );
                          },
                        );

                        // Si el usuario confirmó, cerrar sesión
                        if (shouldLogout == true) {
                          await ref
                              .read(authControllerProvider.notifier)
                              .logout();

                          // Navegar a login
                          Modular.to.navigate('/auth/sign-in');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(icon, color: color ?? const Color(0xFFE991C5), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: color ?? const Color(0xFF333333),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFFCCCCCC),
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(Icons.add_circle_outline, 0, false, () {
                // Volver al home (primera pantalla)
                Navigator.of(context).popUntil((route) => route.isFirst);
              }),
              _buildNavIcon(Icons.grid_view, 1, false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              }),
              _buildNavIcon(Icons.store, 2, false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PackagesScreen(),
                  ),
                );
              }),
              _buildNavIcon(Icons.chat_bubble_outline, 3, false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatsScreen()),
                );
              }),
              _buildNavIcon(Icons.person, 4, true, () {}), // Ya está en perfil
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(
    IconData icon,
    int index,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
