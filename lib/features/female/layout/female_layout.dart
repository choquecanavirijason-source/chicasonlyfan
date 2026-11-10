import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/config/auth_config.dart';

/// Layout persistente para el módulo Female (Creadoras)
/// Contiene el BottomNavigationBar que se mantiene cargado
/// mientras se navega entre las diferentes pantallas del módulo
class FemaleLayout extends ConsumerStatefulWidget {
  final Widget child;

  const FemaleLayout({super.key, required this.child});

  @override
  ConsumerState<FemaleLayout> createState() => _FemaleLayoutState();
}

class _FemaleLayoutState extends ConsumerState<FemaleLayout> {
  int _selectedIndex = 1; // Por defecto en "Crear"

  @override
  void initState() {
    super.initState();
    // Escuchar cambios de ruta para actualizar el índice seleccionado
    Modular.routerDelegate.addListener(_onRouteChanged);
    _updateSelectedIndex();
  }

  @override
  void dispose() {
    Modular.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    if (mounted) {
      _updateSelectedIndex();
    }
  }

  void _updateSelectedIndex() {
    final String location = Modular.to.path;
    setState(() {
      _selectedIndex = _getSelectedIndex(location);
    });
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(authenticationEnabled ? 'Cerrar Sesión' : 'Cambiar perfil'),
        content: Text(
          authenticationEnabled
              ? '¿Estás seguro de que deseas cerrar sesión?'
              : '¿Quieres volver a elegir el tipo de perfil?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              authenticationEnabled ? 'Cerrar Sesión' : 'Cambiar perfil',
            ),
          ),
        ],
      ),
    );

    if (confirm == true && authenticationEnabled) {
      // Usar AuthController para cerrar sesión y limpiar cache
      await ref.read(authControllerProvider.notifier).logout();
    }

    if (confirm == true && mounted) {
      Modular.to.navigate(authenticationEnabled ? '/auth/sign-in' : '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7e9f5),
      appBar: AppBar(
        backgroundColor: const Color(0xfff7e9f5),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xff4c3a57)),
            tooltip: authenticationEnabled ? 'Cerrar Sesión' : 'Cambiar perfil',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xff4c3a57),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.person_outline, false),
            activeIcon: _buildNavIcon(Icons.person, true),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.star_outline, false),
            activeIcon: _buildNavIcon(Icons.star, true),
            label: 'Crear',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.chat_bubble_outline, false),
            activeIcon: _buildNavIcon(Icons.chat_bubble, true),
            label: 'Chat',
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive) {
    return Icon(
      icon,
      color: isActive ? const Color(0xff4c3a57) : Colors.grey,
      size: 24,
    );
  }

  /// Determina el índice del tab basándose en la ruta actual
  int _getSelectedIndex(String location) {
    final normalizedLocation = location.toLowerCase();

    if (normalizedLocation.contains('/profile')) {
      return 0;
    }
    if (normalizedLocation.contains('/contenido') ||
        normalizedLocation.endsWith('/female/contenido') ||
        normalizedLocation == '/female' ||
        normalizedLocation == '/female/') {
      return 1;
    }
    if (normalizedLocation.contains('/chat')) {
      return 2;
    }

    // Por defecto, crear contenido
    return 1;
  }

  /// Navega a la ruta correspondiente según el tab seleccionado
  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // Ya estamos en el mismo tab, no hacer nada
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Modular.to.navigate('/female/profile');
        break;
      case 1:
        Modular.to.navigate('/female/contenido');
        break;
      case 2:
        // TODO: Implementar pantalla de chat para creadoras
        // Por ahora, volvemos a contenido
        Modular.to.navigate('/female/contenido');
        break;
    }
  }
}
