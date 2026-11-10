import 'package:flutter_modular/flutter_modular.dart';
import '../../features/male/home/screens/home_screen.dart';
import '../../features/male/home/screens/favorites_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/chat/presentation/screens/chats_screen.dart';
import '../../features/chat/presentation/screens/chat_detail_screen.dart';
import '../../features/male/packages/screens/packages_screen.dart';
import '../guards/auth_guard.dart';
import '../../features/male/layout/male_layout.dart';

/// Módulo para usuarios hombres/suscriptores
class MaleModule extends Module {
  @override
  void binds(i) {
    // Bindings específicos para el módulo male
  }

  @override
  void routes(r) {
    // Layout Shell - Envuelve todas las rutas principales del módulo
    r.child(
      Modular.initialRoute,
      child: (context) => const MaleLayout(child: RouterOutlet()),
      guards: [AuthGuard(requiredType: 'male')],
      children: [
        // Rutas con navegación persistente (bottom nav)
        ParallelRoute.child('/home', child: (context) => const HomeScreen()),
        ParallelRoute.child(
          '/favorites',
          child: (context) => const FavoritesScreen(),
        ),
        ParallelRoute.child('/chats', child: (context) => const ChatsScreen()),
        ParallelRoute.child(
          '/packages',
          child: (context) => const PackagesScreen(),
        ),
        ParallelRoute.child(
          '/profile',
          child: (context) => const ProfileScreen(),
        ),
      ],
      transition: TransitionType.noTransition,
    );

    // Rutas fuera del layout (sin bottom nav)
    r.child(
      '/chats/:chatId',
      child: (context) => ChatDetailScreen(
        name: r.args.data['name'] ?? 'Chat',
        avatar: r.args.data['avatar'] ?? '',
        isOnline: r.args.data['isOnline'] ?? false,
      ),
      guards: [AuthGuard(requiredType: 'male')],
    );

    // Pantalla de videollamada (comentado hasta implementar)
    // r.child(
    //   '/videocall/:creatorId',
    //   child: (context) => const VideocallScreen(),
    // );
  }
}
