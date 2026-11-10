class Validators {
  // Validar número de teléfono
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu número de teléfono';
    }

    // Remover espacios y caracteres especiales excepto +
    final cleanValue = value.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleanValue.length < 8) {
      return 'El número es demasiado corto';
    }

    if (cleanValue.length > 15) {
      return 'El número es demasiado largo';
    }

    return null;
  }

  // Validar código de verificación
  static String? validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa el código';
    }

    if (value.length != 6) {
      return 'El código debe tener 6 dígitos';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Solo se permiten números';
    }

    return null;
  }

  // Validar nombre
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu nombre';
    }

    if (value.length < 2) {
      return 'El nombre es demasiado corto';
    }

    if (value.length > 30) {
      return 'El nombre es demasiado largo (máx. 30 caracteres)';
    }

    return null;
  }

  // Validar fecha de nacimiento
  static String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu fecha de nacimiento';
    }

    // Formato esperado: YYYY/MM/DD
    final regex = RegExp(r'^(\d{4})/(\d{2})/(\d{2})$');
    if (!regex.hasMatch(value)) {
      return 'Formato inválido. Use YYYY/MM/DD';
    }

    final match = regex.firstMatch(value);
    if (match != null) {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);

      // Validar rangos
      if (month < 1 || month > 12) {
        return 'Mes inválido';
      }

      if (day < 1 || day > 31) {
        return 'Día inválido';
      }

      // Calcular edad
      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();
      final age = today.year - birthDate.year;

      if (age < 18) {
        return 'Debes ser mayor de 18 años';
      }

      if (age > 100) {
        return 'Fecha inválida';
      }
    }

    return null;
  }

  // Validar email (opcional)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email es opcional
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }

    return null;
  }
}
