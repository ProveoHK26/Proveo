class Validators {
  static String? required(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'El correo es obligatorio';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(email)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  static String? price(String? value) {
    final price = value?.trim() ?? '';
    if (price.isEmpty) return 'El precio es obligatorio';
    final parsed = double.tryParse(price);
    if (parsed == null || parsed <= 0) {
      return 'Ingresa un precio válido';
    }
    return null;
  }
}
