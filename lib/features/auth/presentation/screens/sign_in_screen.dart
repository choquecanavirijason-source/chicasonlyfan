import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    // Escuchar cambios de estado para navegación
    ref.listen<AuthState>(authControllerProvider, (previous, next) async {
      print('🟡 SignInScreen Listener - Estado: ${next.runtimeType}');

      if (next is AuthStateAuthenticated) {
        // Usuario autenticado - obtener userType del cache
        print('🟢 Obteniendo userType del cache...');
        final userType = await ref
            .read(authControllerProvider.notifier)
            .getUserType();

        print('🟢 UserType del cache: $userType');

        if (userType == 'female') {
          print('🔵 Navegando a /female/contenido');
          Modular.to.navigate('/female/contenido');
        } else if (userType == 'male') {
          print('🔵 Navegando a /male/home');
          Modular.to.navigate('/male/home');
        } else {
          print('⚠️ UserType indefinido o null: $userType');
        }
      } else if (next is AuthStateNeedsProfileCompletion) {
        // Usuario nuevo de Google → Mostrar pantalla de error (Ops!)
        print(
          '🔵 Usuario nuevo de Google detectado, redirigiendo a ErrorScreen',
        );
        Modular.to.navigate(
          '/auth/error',
          arguments: {'email': next.user.email},
        );
      } else if (next is AuthStateError) {
        // Mostrar error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message), backgroundColor: Colors.red),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF4A148C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Logo o título de la app
              const Text(
                'ChicasApp',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

              // Estado de carga
              if (authState is AuthStateLoading)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              else ...[
                // Botón de Google
                _SocialButton(
                  text: 'INICIAR SESIÓN CON GOOGLE',
                  icon: Icons.g_mobiledata,
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  onPressed: () {
                    print('🔵 BOTÓN DE GOOGLE PRESIONADO (SignInScreen)');
                    ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle();
                  },
                ),

                const SizedBox(height: 16),

                // Botón de Apple
                _SocialButton(
                  text: 'INICIAR SESIÓN CON APPLE',
                  icon: Icons.apple,
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  onPressed: () {
                    // TODO: Implementar Apple Sign In
                  },
                ),

                const SizedBox(height: 16),

                // Botón de Número de Teléfono para Login
                _SocialButton(
                  text: 'INICIAR SESIÓN',
                  icon: Icons.phone_android,
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  onPressed: () {
                    Modular.to.pushNamed(
                      '/auth/phone',
                      arguments: {'isLogin': true},
                    );
                  },
                ),
              ],

              const Spacer(),

              // Texto de registro - sin especificar tipo
              TextButton(
                onPressed: () {
                  Modular.to.pushNamed(
                    '/auth/phone',
                    arguments: {'isLogin': false},
                  );
                },
                child: const Text(
                  '¿No tienes cuenta? Regístrate',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 0,
      ),
    );
  }
}
