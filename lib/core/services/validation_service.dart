class ValidationService {
  /// Checks if the value is empty or null
  static String? isEmpty(String? value, {String? name}) {
    if (value == null || value.trim().isEmpty) {
      return '${name ?? "This field"} is required';
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Email is required';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates phone number format
  static String? validatePhone(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^[0-9\-\+\s\(\)]{10,15}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
