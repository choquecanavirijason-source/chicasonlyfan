import 'package:flutter_modular/flutter_modular.dart';
import '../../features/female/content/screens/contenido_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../guards/auth_guard.dart';
import '../../features/female/layout/female_layout.dart';

/// Módulo para creadoras de contenido/mujeres
class FemaleModule extends Module {
  @override
  void binds(i) {
    // Bindings específicos para el módulo female
  }

  @override
  void routes(r) {
    // Layout Shell - Envuelve todas las rutas principales del módulo
    r.child(
      Modular.initialRoute,
      child: (context) => const FemaleLayout(child: RouterOutlet()),
      guards: [AuthGuard(requiredType: 'female')],
      children: [
        // Rutas con navegación persistente (bottom nav)
        ParallelRoute.child(
          '/contenido',
          child: (context) => const CrearContenidoPage(),
        ),
        ParallelRoute.child(
          '/profile',
          child: (context) => const ProfileScreen(),
        ),
        // TODO: Agregar ruta de chat cuando esté implementada
        // ParallelRoute.child(
        //   '/chat',
        //   child: (context) => const ChatScreenWoman(),
        // ),
      ],
      transition: TransitionType.noTransition,
    );

    // Pantalla de donadores/top donadores (comentado hasta implementar)
    // r.child('/donadores', child: (context) => const DonadoresScreen());
  }
}
