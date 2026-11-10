import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/atoms/custom_back_button.dart';
import '../../../../../core/widgets/atoms/primary_button.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/enums/user_type.dart';
import '../../controllers/auth_controller.dart';

class VerificationCodeScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final UserType userType;
  final bool isLogin;
  final String? email;
  final bool isDevelopmentVerification;

  const VerificationCodeScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    this.userType = UserType.male,
    this.isLogin = false,
    this.email,
    this.isDevelopmentVerification = false,
  });

  @override
  ConsumerState<VerificationCodeScreen> createState() =>
      _VerificationCodeScreenState();
}

class _VerificationCodeScreenState
    extends ConsumerState<VerificationCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _codeController.text.length == 6;
    });
  }

  void _handleContinue() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (kDebugMode && widget.isDevelopmentVerification) {
          if (_codeController.text != '000000') {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Código de prueba incorrecto. Ingresa 000000.'),
                backgroundColor: AppColors.error,
                duration: Duration(seconds: 3),
              ),
            );
            return;
          }

          final userType = widget.userType == UserType.female
              ? 'female'
              : 'male';
          await ref
              .read(authControllerProvider.notifier)
              .signInWithoutPhoneVerification(
                userType: userType,
                isLogin: widget.isLogin,
              );

          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });

          if (widget.isLogin) {
            Modular.to.navigate(
              userType == 'female' ? '/female/contenido' : '/male/home',
            );
          } else {
            Modular.to.pushNamed(
              '/auth/name',
              arguments: {
                'phoneNumber': widget.phoneNumber,
                'userType': userType,
                'email': widget.email,
              },
            );
          }
          return;
        }

        // Verificar el código OTP
        await ref
            .read(authControllerProvider.notifier)
            .verifyPhoneOTP(
              verificationId: widget.verificationId,
              otp: _codeController.text,
              phoneNumber: widget.phoneNumber,
            );

        if (!mounted) return;

        // Si es login, verificar si el usuario existe en Firestore
        if (widget.isLogin) {
          final userId = ref
              .read(authControllerProvider.notifier)
              .getCurrentUserId();

          if (userId != null) {
            final userExists = await ref
                .read(authControllerProvider.notifier)
                .checkUserExistsInFirestore(userId);

            if (!userExists) {
              // Usuario NO existe → Mostrar pantalla de error (Ops!)
              print(
                '🔵 Usuario no encontrado en login, redirigiendo a ErrorScreen',
              );

              if (!mounted) return;

              setState(() {
                _isLoading = false;
              });

              // Navegar a ErrorScreen con el número de teléfono
              Modular.to.navigate(
                '/auth/error',
                arguments: {
                  'phoneNumber': widget.phoneNumber,
                  'fromPhoneLogin': true,
                },
              );
              return;
            }
          }
        }

        setState(() {
          _isLoading = false;
        });

        // Código verificado correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Código verificado correctamente'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );

        // Navegar a la siguiente pantalla
        Modular.to.pushNamed(
          '/auth/name',
          arguments: {
            'phoneNumber': widget.phoneNumber,
            'userType': widget.userType == UserType.female ? 'female' : 'male',
            'email': widget.email,
          },
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                kDebugMode && widget.isDevelopmentVerification
                    ? 'No se pudo crear la sesión de prueba: ${e.toString()}'
                    : 'Error verificando el código: ${e.toString()}',
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                // Título
                const Text(
                  AppStrings.codeTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 16),

                // Mensaje con número de teléfono
                Text(
                  kDebugMode && widget.isDevelopmentVerification
                      ? 'Código de prueba fijo para +591 ${widget.phoneNumber}: 000000'
                      : 'Código enviado a +591 ${widget.phoneNumber}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // Campo de código con indicadores
                Column(
                  children: [
                    TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 16,
                      ),
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: const InputDecoration(
                        hintText: '000000',
                        counterText: '',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: Validators.validateCode,
                      onChanged: (value) => _validateForm(),
                    ),

                    const SizedBox(height: 16),

                    // Indicadores de progreso
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: index < _codeController.text.length
                                ? AppColors.primary
                                : AppColors.textHint,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Botón reenviar código
                if (!(kDebugMode && widget.isDevelopmentVerification))
                  Center(
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Código reenviado'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      child: Text(
                        '¿No recibiste el código? Reenviar',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                const Spacer(),

                // Botón continuar
                PrimaryButton(
                  text: _isLoading
                      ? 'Verificando...'
                      : AppStrings.continueButton,
                  onPressed: (_isButtonEnabled && !_isLoading)
                      ? _handleContinue
                      : null,
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
