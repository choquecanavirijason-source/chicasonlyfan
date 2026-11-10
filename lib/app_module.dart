import 'package:flutter_modular/flutter_modular.dart';
import 'core/modules/auth_module.dart';
import 'core/modules/male_module.dart';
import 'core/modules/female_module.dart';
import 'main.dart';
import 'core/config/auth_config.dart';
import 'features/auth/presentation/screens/temporary_access_screen.dart';

/// Módulo principal de la aplicación
class AppModule extends Module {
  @override
  void binds(i) {
    // Aquí van los bindings globales (servicios singleton, repositorios, etc.)
  }

  @override
  void routes(r) {
    // Ruta inicial: permite probar la app sin iniciar sesión si está desactivado.
    r.child(
      '/',
      child: (context) => authenticationEnabled
          ? const AuthWrapper()
          : const TemporaryAccessScreen(),
    );

    // Módulo de autenticación
    r.module('/auth', module: AuthModule());

    // Módulo para usuarios hombres/suscriptores
    r.module('/male', module: MaleModule());

    // Módulo para creadoras/mujeres
    r.module('/female', module: FemaleModule());
  }
}
