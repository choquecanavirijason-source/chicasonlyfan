import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/atoms/custom_back_button.dart';
import '../../../../../core/widgets/atoms/primary_button.dart';
import '../../../../../core/enums/user_type.dart';
import '../../controllers/auth_controller.dart';

class ProfileConfirmationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String name;
  final String birthDate; // Cambiar de DateTime a String
  final UserType userType;
  final String? email; // Email de Google (opcional)

  const ProfileConfirmationScreen({
    super.key,
    required this.phoneNumber,
    required this.name,
    required this.birthDate,
    this.userType = UserType.male,
    this.email,
  });

  @override
  ConsumerState<ProfileConfirmationScreen> createState() =>
      _ProfileConfirmationScreenState();
}

class _ProfileConfirmationScreenState
    extends ConsumerState<ProfileConfirmationScreen> {
  Uint8List? _profileImage;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _birthDateController;
  late TextEditingController _emailController;
  bool _isContentCreator = false; // Switch para creador de contenido
  bool _isLoading = false; // Estado de carga

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    // Dejar campo de username vacío
    _usernameController = TextEditingController(text: '');
    _birthDateController = TextEditingController(text: widget.birthDate);
    // Usar email de Google si está disponible
    _emailController = TextEditingController(text: widget.email ?? '');
    // Inicializar según el userType actual
    _isContentCreator = widget.userType == UserType.female;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _profileImage = bytes;
      });
    }
  }

  void _handleContinue() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Parsear la fecha de cumpleaños
      final parts = _birthDateController.text.split('/');
      DateTime birthDate = DateTime.now();
      if (parts.length == 3) {
        birthDate = DateTime(
          int.parse(parts[2]), // año
          int.parse(parts[1]), // mes
          int.parse(parts[0]), // día
        );
      }

      // Determinar userType según el switch
      final userTypeString = _isContentCreator ? 'female' : 'male';

      // Guardar el perfil completo del usuario
      await ref
          .read(authControllerProvider.notifier)
          .updateProfile(
            name: _nameController.text,
            username: _usernameController.text,
            birthDate: birthDate,
            email: _emailController.text.isEmpty ? null : _emailController.text,
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
              _isContentCreator
                  ? '¡Bienvenida creadora! Ya puedes empezar a crear contenido'
                  : '¡Registro completado! Ya puedes explorar contenido',
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );

        // Redirigir según el tipo de usuario
        await Future.delayed(const Duration(milliseconds: 500));

        if (_isContentCreator) {
          Modular.to.navigate('/female/contenido');
        } else {
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
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        leading: CustomBackButton(color: AppColors.textSecondary),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indicador de progreso completo
                Row(
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // Título
                const Text(
                  'Confirma tu perfil 123',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 48),

                // Foto de perfil
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 4,
                            ),
                            color: const Color(0xFFE0E0E0),
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: MemoryImage(_profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _profileImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: AppColors.textWhite,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Nombre completo - EDITABLE
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Nombre completo',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.all(18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Nombre de usuario - EDITABLE
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Nombre de usuario',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.all(18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Fecha de nacimiento - EDITABLE
                TextFormField(
                  controller: _birthDateController,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Fecha de nacimiento',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    contentPadding: const EdgeInsets.all(18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Email - NO EDITABLE si ya existe
                TextFormField(
                  controller: _emailController,
                  enabled: widget.email == null || widget.email!.isEmpty,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 16,
                    color: (widget.email != null && widget.email!.isNotEmpty)
                        ? AppColors.textSecondary
                        : Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        (widget.email != null && widget.email!.isNotEmpty)
                        ? const Color(0xFFF0F0F0)
                        : Colors.white,
                    hintText: 'E-mail',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: Icon(
                      Icons.email_outlined,
                      color: (widget.email != null && widget.email!.isNotEmpty)
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                    contentPadding: const EdgeInsets.all(18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            (widget.email != null && widget.email!.isNotEmpty)
                            ? AppColors.primary
                            : const Color(0xFFE0E0E0),
                        width:
                            (widget.email != null && widget.email!.isNotEmpty)
                            ? 2
                            : 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Teléfono - NO EDITABLE, siempre remarqué
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Text('🇧🇴  ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          widget.phoneNumber,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.phone_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Switch para creador de contenido
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isContentCreator
                          ? AppColors.primary
                          : const Color(0xFFE0E0E0),
                      width: _isContentCreator ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.video_camera_front_rounded,
                        color: _isContentCreator
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¿Eres creador de contenido?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _isContentCreator
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isContentCreator
                                  ? 'Podrás publicar contenido exclusivo'
                                  : 'Podrás ver y seguir creadores',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isContentCreator,
                        onChanged: (value) {
                          setState(() {
                            _isContentCreator = value;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Botón continuar
                PrimaryButton(
                  text: _isLoading ? 'Guardando...' : 'CONTINUAR',
                  onPressed: _isLoading ? null : _handleContinue,
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
