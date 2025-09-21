class PlateValidationResult {
  final bool isValid;
  final String? errorMessage;

  PlateValidationResult({
    required this.isValid,
    this.errorMessage,
  });
}

class PlateValidator {
  static const Map<String, String> _patterns = {
    'ES': r'^[0-9]{4}[A-Z]{3}$', // 1234ABC
    'FR': r'^[A-Z]{2}[0-9]{3}[A-Z]{2}$', // AB-123-CD
    'DE': r'^[A-Z]{1,3}[A-Z]{1,2}[0-9]{1,4}[A-Z]{0,2}$', // ST-AB 1234
    'IT': r'^[A-Z]{2}[0-9]{3}[A-Z]{2}$', // AB123CD
    'PT': r'^[0-9]{2}[A-Z]{2}[0-9]{2}$', // 12-AB-34
    'GB': r'^[A-Z]{2}[0-9]{2}[A-Z]{3}$', // AB12 CDE
  };

  static const Map<String, String> _errorMessages = {
    'ES': 'Formato español: 4 números seguidos de 3 letras (ej: 1234ABC)',
    'FR': 'Formato francés: 2 letras, 3 números, 2 letras (ej: AB123CD)',
    'DE':
        'Formato alemán: 1-3 letras, 1-2 letras, 1-4 números, 0-2 letras (ej: ST-AB 1234)',
    'IT': 'Formato italiano: 2 letras, 3 números, 2 letras (ej: AB123CD)',
    'PT': 'Formato portugués: 2 números, 2 letras, 2 números (ej: 12AB34)',
    'GB': 'Formato británico: 2 letras, 2 números, 3 letras (ej: AB12CDE)',
  };

  PlateValidationResult validate(String plate, String country) {
    if (plate.isEmpty) {
      return PlateValidationResult(
        isValid: false,
        errorMessage: 'Introduzca una matrícula',
      );
    }

    final pattern = _patterns[country];
    if (pattern == null) {
      return PlateValidationResult(
        isValid: false,
        errorMessage: 'País no soportado',
      );
    }

    final regex = RegExp(pattern);
    if (!regex.hasMatch(plate)) {
      return PlateValidationResult(
        isValid: false,
        errorMessage:
            _errorMessages[country] ?? 'Formato de matrícula inválido',
      );
    }

    return PlateValidationResult(isValid: true);
  }

  String getExamplePlate(String country) {
    switch (country) {
      case 'ES':
        return '1234ABC';
      case 'FR':
        return 'AB123CD';
      case 'DE':
        return 'ST-AB 1234';
      case 'IT':
        return 'AB123CD';
      case 'PT':
        return '12AB34';
      case 'GB':
        return 'AB12CDE';
      default:
        return '1234ABC';
    }
  }

  List<String> getSupportedCountries() {
    return _patterns.keys.toList();
  }
}
