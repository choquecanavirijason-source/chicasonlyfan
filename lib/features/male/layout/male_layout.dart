import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/auth_config.dart';

/// Layout persistente para el módulo Male (Suscriptores)
/// Contiene el BottomNavigationBar que se mantiene cargado
/// mientras se navega entre las diferentes pantallas del módulo
class MaleLayout extends ConsumerStatefulWidget {
  final Widget child;

  const MaleLayout({super.key, required this.child});

  @override
  ConsumerState<MaleLayout> createState() => _MaleLayoutState();
}

class _MaleLayoutState extends ConsumerState<MaleLayout> {
  int _selectedIndex = 0;

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
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
        color: const Color(0xFF1C1C1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1C1C1E),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.home_outlined, false),
            activeIcon: _buildNavIcon(Icons.home, true),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.favorite_border, false),
            activeIcon: _buildNavIcon(Icons.favorite, true),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.chat_bubble_outline, false),
            activeIcon: _buildNavIcon(Icons.chat_bubble, true),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.card_giftcard_outlined, false),
            activeIcon: _buildNavIcon(Icons.card_giftcard, true),
            label: 'Paquetes',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.person_outline, false),
            activeIcon: _buildNavIcon(Icons.person, true),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive) {
    return Icon(
      icon,
      color: isActive ? AppColors.primary : Colors.grey,
      size: 24,
    );
  }

  /// Determina el índice del tab basándose en la ruta actual
  int _getSelectedIndex(String location) {
    final normalizedLocation = location.toLowerCase();

    if (normalizedLocation.endsWith('/home') ||
        normalizedLocation.endsWith('/male/home') ||
        normalizedLocation == '/male' ||
        normalizedLocation == '/male/') {
      return 0;
    }
    if (normalizedLocation.contains('/favorites')) {
      return 1;
    }
    if (normalizedLocation.contains('/chats')) {
      return 2;
    }
    if (normalizedLocation.contains('/packages')) {
      return 3;
    }
    if (normalizedLocation.contains('/profile')) {
      return 4;
    }

    // Por defecto, inicio
    return 0;
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
        Modular.to.navigate('/male/home');
        break;
      case 1:
        Modular.to.navigate('/male/favorites');
        break;
      case 2:
        Modular.to.navigate('/male/chats');
        break;
      case 3:
        Modular.to.navigate('/male/packages');
        break;
      case 4:
        Modular.to.navigate('/male/profile');
        break;
    }
  }
}
