import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/atoms/custom_back_button.dart';
import '../../../../../core/widgets/atoms/primary_button.dart';
import '../../../../../core/enums/user_type.dart';
import '../../controllers/auth_controller.dart';

class FollowProfilesScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String name;
  final String username;
  final String birthDate;
  final String? email;
  final UserType userType;

  const FollowProfilesScreen({
    super.key,
    required this.phoneNumber,
    required this.name,
    required this.username,
    required this.birthDate,
    this.email,
    this.userType = UserType.male,
  });

  @override
  ConsumerState<FollowProfilesScreen> createState() =>
      _FollowProfilesScreenState();
}

class _FollowProfilesScreenState extends ConsumerState<FollowProfilesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _followingIds = {};
  bool _isLoading = false;

  // Lista de perfiles sugeridos
  final List<Map<String, dynamic>> _profiles = [
    {
      'id': 1,
      'name': 'Jane Cooper',
      'location': 'La Paz',
      'image': 'assets/images/profiles/chica1.jpg',
    },
    {
      'id': 2,
      'name': 'Jenny Rivero',
      'location': 'Cochabamba',
      'image': 'assets/images/profiles/chica2.jpg',
    },
    {
      'id': 3,
      'name': 'Camila Ovando',
      'location': 'Oruro',
      'image': 'assets/images/profiles/chica3.jpg',
    },
    {
      'id': 4,
      'name': 'Vania Paz',
      'location': 'Beni',
      'image': 'assets/images/profiles/chica4.jpg',
    },
    {
      'id': 5,
      'name': 'Isabel Campo',
      'location': 'Tarija',
      'image': 'assets/images/profiles/chica5.jpg',
    },
    {
      'id': 6,
      'name': 'Ana Cardoz',
      'location': 'La Paz',
      'image': 'assets/images/profiles/chica1.jpg',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFollow(int id) {
    setState(() {
      if (_followingIds.contains(id)) {
        _followingIds.remove(id);
      } else {
        _followingIds.add(id);
      }
    });
  }

  void _handleContinue() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Parsear la fecha de cumpleaños
      final parts = widget.birthDate.split('/');
      DateTime birthDate = DateTime.now();
      if (parts.length == 3) {
        birthDate = DateTime(
          int.parse(parts[2]), // año
          int.parse(parts[1]), // mes
          int.parse(parts[0]), // día
        );
      }

      // Usar el userType que viene de la pantalla 05
      final userTypeString = widget.userType == UserType.female
          ? 'female'
          : 'male';

      // Guardar el perfil completo del usuario
      await ref
          .read(authControllerProvider.notifier)
          .updateProfile(
            name: widget.name,
            username: widget.username,
            birthDate: birthDate,
            email: widget.email,
          );

      // Guardar el userType
      await ref
          .read(authControllerProvider.notifier)
          .saveUserType(userTypeString);

      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.userType == UserType.female
                  ? '¡Bienvenida creadora! Ya puedes empezar a crear contenido'
                  : '¡Registro completado! Ya puedes explorar contenido',
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );

        // Redirigir según el tipo de usuario
        await Future.delayed(const Duration(milliseconds: 500));

        if (widget.userType == UserType.female) {
          // Creador de contenido → Ir a pantalla de female
          Modular.to.navigate('/female/contenido');
        } else {
          // Usuario regular → Ir a pantalla de male
          Modular.to.navigate('/male/home');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar perfil: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: CustomBackButton(color: AppColors.textSecondary),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Título
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Seguir perfil',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Subtítulo
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Sigue a alguien que quieras conocerte o\npuedas saltar esta parte.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  hintStyle: const TextStyle(color: AppColors.textHint),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textHint,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Lista de perfiles
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: _profiles.length,
                itemBuilder: (context, index) {
                  final profile = _profiles[index];
                  final isFollowing = _followingIds.contains(profile['id']);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.background,
                          backgroundImage: AssetImage(profile['image']),
                        ),

                        const SizedBox(width: 12),

                        // Nombre y ubicación
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    profile['location'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Botón Seguir/Siguiendo
                        OutlinedButton(
                          onPressed: () => _toggleFollow(profile['id']),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isFollowing
                                ? Colors.transparent
                                : AppColors.primary,
                            foregroundColor: isFollowing
                                ? AppColors.primary
                                : AppColors.white,
                            side: BorderSide(
                              color: AppColors.primary,
                              width: isFollowing ? 1.5 : 0,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            isFollowing ? 'Siguiendo' : 'Seguir',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Botón Continuar
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton(
                text: _isLoading ? 'Guardando...' : AppStrings.continueButton,
                onPressed: _isLoading ? null : _handleContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
