import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Servicio para almacenar datos del usuario en cache local
class UserCacheService {
  static const String _userIdKey = 'user_id';
  static const String _userTypeKey = 'user_type';
  static const String _userDataKey = 'user_data';
  static const String _isAuthenticatedKey = 'is_authenticated';

  /// Guarda los datos del usuario en cache
  Future<void> saveUser({
    required String userId,
    required String userType,
    Map<String, dynamic>? userData,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userTypeKey, userType);
    await prefs.setBool(_isAuthenticatedKey, true);

    if (userData != null) {
      await prefs.setString(_userDataKey, jsonEncode(userData));
    }
  }

  /// Obtiene el ID del usuario guardado
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Obtiene el tipo de usuario guardado (male o female)
  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }

  /// Obtiene los datos completos del usuario
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userDataKey);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Verifica si hay un usuario autenticado
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAuthenticatedKey) ?? false;
  }

  /// Limpia todos los datos del usuario (logout)
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userTypeKey);
    await prefs.remove(_userDataKey);
    await prefs.setBool(_isAuthenticatedKey, false);
  }

  /// Actualiza solo el tipo de usuario
  Future<void> updateUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, userType);
  }
}
