import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../chat/presentation/screens/chats_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../home/screens/favorites_screen.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  // Paquetes Premium
  final List<Map<String, dynamic>> _premiumPackages = [
    {
      'name': 'Popular',
      'color': Color(0xFFE991C5),
      'icon': Icons.favorite,
      'minutes': 30,
      'price': 25,
      'description': 'Paga con tarjeta',
    },
    {
      'name': 'Mejor Valor',
      'color': Color(0xFF4A1942),
      'icon': Icons.workspace_premium,
      'minutes': 60,
      'price': 40,
      'description': 'Paga con tarjeta',
    },
    {
      'name': 'Super Pack',
      'color': Color(0xFF9E9E9E),
      'icon': Icons.diamond,
      'minutes': 120,
      'price': 60,
      'description': 'Paga con tarjeta',
    },
  ];

  // Paquetes Básicos
  final List<Map<String, dynamic>> _basicPackages = [
    {'minutes': 5, 'price': 7},
    {'minutes': 10, 'price': 9},
    {'minutes': 15, 'price': 12},
  ];

  void _showPaymentModal(Map<String, dynamic> package) {
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    bool isFormValid = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // Validar formulario
          void validateForm() {
            setState(() {
              isFormValid =
                  cardNumberController.text.length >= 16 &&
                  expiryController.text.length == 5 &&
                  cvvController.text.length == 3;
            });
          }

          // Formatear fecha de vencimiento automáticamente
          void formatExpiryDate(String value) {
            if (value.length == 2 && !value.contains('/')) {
              expiryController.text = '$value/';
              expiryController.selection = TextSelection.fromPosition(
                TextPosition(offset: expiryController.text.length),
              );
            }
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header con título y botón cerrar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pago tarjeta',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.textSecondary,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Información del paquete
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.credit_card,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pago con tarjeta',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${package['minutes']} minutos • ${package['price']} Bs',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Número de tarjeta
                      const Text(
                        'Número de tarjeta',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: cardNumberController,
                        keyboardType: TextInputType.number,
                        maxLength: 19,
                        onChanged: (value) {
                          // Formatear número de tarjeta con espacios
                          String formatted = value.replaceAll(' ', '');
                          if (formatted.length > 16) {
                            formatted = formatted.substring(0, 16);
                          }
                          String result = '';
                          for (int i = 0; i < formatted.length; i++) {
                            if (i > 0 && i % 4 == 0) result += ' ';
                            result += formatted[i];
                          }
                          if (result != value) {
                            cardNumberController.value = TextEditingValue(
                              text: result,
                              selection: TextSelection.collapsed(
                                offset: result.length,
                              ),
                            );
                          }
                          validateForm();
                        },
                        decoration: InputDecoration(
                          hintText: '1234 5678 9012 3456',
                          hintStyle: const TextStyle(color: AppColors.textHint),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          counterText: '',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Fecha de vencimiento y CVV
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fecha de vencimiento',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: expiryController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 5,
                                  onChanged: (value) {
                                    formatExpiryDate(value);
                                    validateForm();
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'MM/AA',
                                    hintStyle: const TextStyle(
                                      color: AppColors.textHint,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.background,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    counterText: '',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CVV',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: cvvController,
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  maxLength: 3,
                                  onChanged: (value) => validateForm(),
                                  decoration: InputDecoration(
                                    hintText: '123',
                                    hintStyle: const TextStyle(
                                      color: AppColors.textHint,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.background,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    counterText: '',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Total a pagar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total a pagar:',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${package['price']} Bs.',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Botón Confirmar compra
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isFormValid
                              ? () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '¡Compra confirmada! ${package['minutes']} minutos agregados',
                                      ),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFormValid
                                ? const Color(0xFFE991C5)
                                : Colors.grey[300],
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: isFormValid ? 2 : 0,
                          ),
                          child: Text(
                            'Confirmar compra',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isFormValid
                                  ? Colors.white
                                  : Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Contenido scrolleable
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // Título principal centrado
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              'Compra tus minutos',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Icon(
                              Icons.access_time,
                              size: 40,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Selecciona un paquete y paga con tu tarjeta',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Título Premium
                      const Text(
                        'Paquetes Premium',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tarjetas Premium
                      ..._premiumPackages.map(
                        (package) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildPremiumCard(package),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Título Básicos
                      const Text(
                        'Paquetes Básicos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Grid de paquetes básicos
                      Row(
                        children: _basicPackages.map((package) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: _buildBasicCard(package),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(
                        height: 100,
                      ), // Espacio para el menú inferior
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildPremiumCard(Map<String, dynamic> package) {
    return GestureDetector(
      onTap: () => _showPaymentModal(package),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [package['color'], package['color'].withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: package['color'].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      package['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Ícono
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(package['icon'], color: Colors.white, size: 28),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Precio
              Text(
                '${package['price']} Bs.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                package['description'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 16),

              // Minutos
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${package['minutes']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'minutos',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Botón Comprar centrado
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Comprar',
                    style: TextStyle(
                      color: package['color'],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicCard(Map<String, dynamic> package) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ícono
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE991C5).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time,
                color: Color(0xFFE991C5),
                size: 24,
              ),
            ),

            const SizedBox(height: 12),

            // Minutos
            Text(
              '${package['minutes']}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'minutos',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),

            const SizedBox(height: 12),

            // Precio
            Text(
              '${package['price']} Bs.',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Botón Comprar
            OutlinedButton(
              onPressed: () => _showPaymentModal({
                'name': 'Básico',
                'minutes': package['minutes'],
                'price': package['price'],
                'description': 'Paga con tarjeta',
              }),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE991C5),
                side: const BorderSide(color: Color(0xFFE991C5)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Comprar',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
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
              _buildNavButton(Icons.add_circle_outline, 0, false),
              _buildNavButton(Icons.grid_view, 1, false),
              _buildNavButton(Icons.store, 2, true), // Cambiado a tienda
              _buildNavButton(Icons.chat_bubble_outline, 3, false),
              _buildNavButton(Icons.person_outline, 4, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          // Volver al home (primera pantalla)
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (index == 1) {
          // Navegar a Favoritos
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
          );
        } else if (index == 3) {
          // Navegar a Chats
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatsScreen()),
          );
        } else if (index == 4) {
          // Navegar a Perfil
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
        // index == 2 no hace nada porque ya estamos en Packages
      },
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
