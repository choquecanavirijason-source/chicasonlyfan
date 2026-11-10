import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/atoms/custom_back_button.dart';
import '../../../../../core/widgets/atoms/primary_button.dart';
import '../../../../../core/widgets/molecules/phone_input_field.dart';
import '../../../../../core/enums/user_type.dart';
import '../../controllers/auth_controller.dart';

class PhoneNumberScreen extends ConsumerStatefulWidget {
  final UserType userType;
  final bool isLogin;
  final String? email;

  const PhoneNumberScreen({
    super.key,
    this.userType = UserType.male,
    this.isLogin = false,
    this.email,
  });

  @override
  ConsumerState<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends ConsumerState<PhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _phoneController.text.length >= 8;
    });
  }

  void _handleContinue() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        final phoneNumber = _phoneController.text;
        if (kDebugMode) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
          Modular.to.pushNamed(
            '/auth/verification',
            arguments: {
              'phoneNumber': phoneNumber,
              'verificationId': '',
              'userType': widget.userType == UserType.female
                  ? 'female'
                  : 'male',
              'isLogin': widget.isLogin,
              'email': widget.email,
              'isDevelopmentVerification': true,
            },
          );
          return;
        }

        final verificationId = await ref
            .read(authControllerProvider.notifier)
            .sendPhoneOTP(phoneNumber);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Código enviado a +591 $phoneNumber'),
              backgroundColor: AppColors.success,
            ),
          );

          Modular.to.pushNamed(
            '/auth/verification',
            arguments: {
              'phoneNumber': phoneNumber,
              'verificationId': verificationId,
              'userType': widget.userType == UserType.female
                  ? 'female'
                  : 'male',
              'isLogin': widget.isLogin,
              'email': widget.email,
            },
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: AppColors.error,
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
                  AppStrings.phoneTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 32),

                // Campo de teléfono con validación
                PhoneInputField(
                  phoneController: _phoneController,
                  onPhoneChanged: (value) => _validateForm(),
                ),

                const SizedBox(height: 16),

                // Mensaje
                Text(
                  kDebugMode
                      ? 'Modo de prueba: ingresa el código fijo 000000. '
                            'Se creará una sesión de demostración.'
                      : AppStrings.codeMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                const Spacer(),

                // Botón continuar
                PrimaryButton(
                  text: _isLoading
                      ? 'Continuando...'
                      : kDebugMode
                      ? 'Continuar al código de prueba'
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
