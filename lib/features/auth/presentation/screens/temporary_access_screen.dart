import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../data/services/phone_auth_service.dart';

/// Pantalla de acceso temporal (modo sin inicio de sesión).
///
/// Aunque la app no pida credenciales en este modo, Firebase sí necesita una
/// sesión: las reglas de Firestore exigen `request.auth != null` y el flujo de
/// live usa `FirebaseAuth.instance.currentUser.uid` como identificador del
/// stream. Por eso aquí se abre una sesión anónima antes de navegar.
class TemporaryAccessScreen extends StatefulWidget {
  const TemporaryAccessScreen({super.key});

  @override
  State<TemporaryAccessScreen> createState() => _TemporaryAccessScreenState();
}

class _TemporaryAccessScreenState extends State<TemporaryAccessScreen> {
  final PhoneAuthService _authService = PhoneAuthService();

  bool _cargando = false;
  String? _error;

  /// Intenta abrir una sesión de Firebase, sin bloquear si no se puede.
  ///
  /// Con sesión, el live se registra en Firestore y aparece en "Lives en Vivo".
  /// Sin ella, la app sigue siendo usable y la transmisión funciona igual,
  /// porque el video va directo a AWS IVS. Por eso un fallo aquí es un aviso,
  /// no un error que corte el paso.
  ///
  /// Si ya hay un usuario se reutiliza, para no generar un uid nuevo en cada
  /// arranque y perder los lives registrados con el anterior.
  Future<void> _intentarSesion() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return;
    }

    try {
      await _authService.signInAnonymously();
    } on StateError catch (e) {
      // signInAnonymously lanza StateError con instrucciones cuando el
      // proveedor Anónimo está deshabilitado en Firebase Console.
      _avisarModoDemo(e.message);
    } on FirebaseAuthException catch (e) {
      _avisarModoDemo('Firebase rechazó la sesión (${e.code}).');
    } catch (e) {
      _avisarModoDemo('No se pudo iniciar la sesión temporal.');
    }
  }

  void _avisarModoDemo(String motivo) {
    debugPrint('⚠️ Entrando en modo demo sin sesión: $motivo');
    if (mounted) {
      setState(
        () => _error =
            'Modo demo: sin sesión de Firebase. El live funciona, pero no '
            'aparecerá en la lista de transmisiones ni contará espectadores.',
      );
    }
  }

  Future<void> _continuar(String ruta) async {
    if (_cargando) return;

    setState(() {
      _cargando = true;
      _error = null;
    });

    await _intentarSesion();

    if (!mounted) return;
    setState(() => _cargando = false);

    // Se entra siempre: la sesión mejora la experiencia, no la condiciona.
    Modular.to.navigate(ruta);
  }

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
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade900.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (_cargando)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                else ...[
                  ElevatedButton(
                    onPressed: () => _continuar('/male/home'),
                    child: const Text('Continuar como usuario'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _continuar('/female/contenido'),
                    child: const Text('Continuar como creadora'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
