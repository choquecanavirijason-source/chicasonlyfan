import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TemporaryAccessScreen extends StatelessWidget {
  const TemporaryAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A148C),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'ChicasApp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Modo temporal sin inicio de sesión',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 36),
                ElevatedButton(
                  onPressed: () => Modular.to.navigate('/male/home'),
                  child: const Text('Continuar como usuario'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Modular.to.navigate('/female/contenido'),
                  child: const Text('Continuar como creadora'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
