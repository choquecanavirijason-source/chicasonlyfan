import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../chat/presentation/screens/chats_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../home/screens/favorites_screen.dart';
import 'package:chicas_app/core/widgets/fondo_video.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chicas_app/core/theme/chicas_tokens.dart';

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
      'color': Tok.oro,
      'video': 'assets/videos/contenido6.mp4',
      'portada': 'assets/images/contenido/portada6.jpg',
      'icon': Icons.favorite,
      'minutes': 30,
      'price': 25,
      'description': 'Paga con tarjeta',
    },
    {
      'name': 'Mejor Valor',
      'destacado': true,
      'color': Tok.vino,
      'video': 'assets/videos/contenido2.mp4',
      'portada': 'assets/images/contenido/portada2.jpg',
      'icon': Icons.workspace_premium,
      'minutes': 60,
      'price': 40,
      'description': 'Paga con tarjeta',
    },
    {
      'name': 'Super Pack',
      'color': Color(0xFF9E9E9E),
      'video': 'assets/videos/contenido5.mp4',
      'portada': 'assets/images/contenido/portada5.jpg',
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
                color: Tok.superficie,
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
                          fillColor: Tok.superficieAlta,
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
                                    fillColor: Tok.superficieAlta,
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
                                    fillColor: Tok.superficieAlta,
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
                                ? Tok.oro
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
      backgroundColor: Tok.fondo,
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
                            Text(
                              'Compra tus minutos',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 30,
                                height: 1.13,
                                fontWeight: FontWeight.w600,
                                color: Tok.marfil,
                              ),
                            ),
                            const SizedBox(height: Tok.s3),
                            const Icon(
                              Icons.access_time,
                              size: 30,
                              color: Tok.oro,
                            ),
                            const SizedBox(height: Tok.s3),
                            Text(
                              'Selecciona un paquete y paga con tu tarjeta',
                              style: GoogleFonts.jost(
                                fontSize: 14,
                                height: 1.43,
                                color: Tok.humo,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Título Premium
                      Text(
                        'Paquetes Premium',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          height: 1.27,
                          fontWeight: FontWeight.w500,
                          color: Tok.marfil,
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
                      Text(
                        'Paquetes Básicos',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          height: 1.27,
                          fontWeight: FontWeight.w500,
                          color: Tok.marfil,
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
          color: Tok.superficie,
          borderRadius: BorderRadius.circular(Tok.rL),
          // El hilo de oro marca el paquete recomendado; los otros dos
          // llevan el borde tenue. Si los tres lo llevaran, no destacaría ninguno.
          border: package['destacado'] == true ? Tok.hiloOro : Tok.hiloTenue,
          boxShadow: package['destacado'] == true
              ? const [Tok.glowOroCarta, Tok.sombraCarta]
              : const [Tok.sombraCarta],
        ),
        // Cada paquete lleva de fondo un video corto en bucle y sin sonido.
        // Antes el velo iba en el color del paquete y tapaba el video; ahora
        // es un velo oscuro, que deja ver la imagen y mantiene legible el texto.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Tok.rL),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned.fill(
                child: FondoVideo(
                  video: package['video'],
                  portada: package['portada'],
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xF0060606), Color(0x66060606)],
                    ),
                  ),
                ),
              ),
              Padding(
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
                      color: Tok.superficieAlta,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      package['name'],
                      style: const TextStyle(
                        color: Tok.champan,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Ícono
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Tok.superficieAlta,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(package['icon'], color: Tok.oro, size: 24),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Precio
              Text(
                '${package['price']} Bs.',
                style: const TextStyle(
                  color: Tok.marfil,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                package['description'],
                style: TextStyle(
                  color: Tok.humo,
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
                      color: Tok.oro,
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
                    style: TextStyle(color: Tok.humo, fontSize: 16),
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
                    // La acción de la tarjeta: oro y resplandor, uno por paquete.
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Tok.oro, Color(0xFF9D7C14)],
                    ),
                    borderRadius: BorderRadius.circular(Tok.rPill),
                    boxShadow: const [Tok.glowOro],
                  ),
                  child: Text(
                    'COMPRAR',
                    style: GoogleFonts.jost(
                      color: const Color(0xFF140F02),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                    ),
                  ),
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

  Widget _buildBasicCard(Map<String, dynamic> package) {
    return Container(
      decoration: BoxDecoration(
        color: Tok.superficie,
        borderRadius: BorderRadius.circular(Tok.rL),
        border: Tok.hiloTenue,
        boxShadow: const [Tok.sombraCarta],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ícono
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Tok.superficieAlta,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time,
                color: Tok.oro,
                size: 22,
              ),
            ),

            const SizedBox(height: 12),

            // Minutos
            Text(
              '${package['minutes']}',
              style: const TextStyle(
                color: Tok.marfil,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'minutos',
              style: TextStyle(color: Tok.humo, fontSize: 11),
            ),

            const SizedBox(height: 12),

            // Precio
            Text(
              '${package['price']} Bs.',
              style: const TextStyle(
                color: Tok.champan,
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
                foregroundColor: Tok.champan,
                side: const BorderSide(color: Tok.borde),
                padding: const EdgeInsets.symmetric(
                  horizontal: Tok.s2,
                  vertical: 6,
                ),
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Tok.rPill),
                ),
              ),
              // La tarjeta básica es angosta: con el espaciado de la etiqueta
              // grande, "COMPRAR" se partía en dos líneas.
              child: const Text(
                'COMPRAR',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      // El morado venía del diseño claro anterior. Sobre negro con oro
      // competía en vez de acompañar: saturaciones muy distintas y tonos
      // casi opuestos. La barra pasa a ser una superficie del sistema y
      // el oro marca lo que está activo.
      decoration: const BoxDecoration(
        color: Tok.superficie,
        border: Border(top: BorderSide(color: Tok.borde, width: 1)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Tok.rL),
          topRight: Radius.circular(Tok.rL),
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
          color: isSelected ? Tok.superficieAlta : Colors.transparent,
          shape: BoxShape.circle,
          border: isSelected ? Tok.hiloOro : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? Tok.oro : Tok.humo,
          size: 24,
        ),
      ),
    );
  }
}
