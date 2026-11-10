import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/atoms/custom_back_button.dart';
import '../../../../../core/widgets/atoms/primary_button.dart';

class ErrorScreen extends StatelessWidget {
  final String? phoneNumber;
  final bool fromPhoneLogin;
  final String? email;

  const ErrorScreen({
    super.key,
    this.phoneNumber,
    this.fromPhoneLogin = false,
    this.email,
  });

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Título
              const Text(
                AppStrings.errorTitle,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 24),

              // Mensaje de error
              Text(
                AppStrings.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // Botón crear cuenta
              PrimaryButton(
                text: AppStrings.createNewAccount,
                onPressed: () {
                  // Si viene de phone login, ya tenemos el número, saltar a screen 03
                  if (fromPhoneLogin && phoneNumber != null) {
                    Modular.to.pushNamed(
                      '/auth/name',
                      arguments: {'phoneNumber': phoneNumber},
                    );
                  } else {
                    // Si viene de Google login, empezar desde screen 01
                    Modular.to.pushNamed(
                      '/auth/phone',
                      arguments: {'email': email},
                    );
                  }
                },
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
