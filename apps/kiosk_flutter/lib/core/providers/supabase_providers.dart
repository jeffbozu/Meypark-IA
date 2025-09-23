import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

// Supabase client provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return SupabaseService.client;
});

// Current user provider
final currentUserProvider = StreamProvider<User?>((ref) {
  return SupabaseService.client.auth.onAuthStateChange
      .map((data) => data.session?.user);
});

// Device ID provider - se carga desde configuración del sistema
final deviceIdProvider = StateProvider<String?>((ref) => null);

// Company ID provider - se carga desde configuración del dispositivo
final companyIdProvider = StateProvider<String?>((ref) => null);

// System initialization provider
final systemInitProvider = FutureProvider<bool>((ref) async {
  try {
    // Intentar cargar configuración del dispositivo desde storage local
    final deviceId = await _loadDeviceIdFromStorage();
    if (deviceId != null) {
      ref.read(deviceIdProvider.notifier).state = deviceId;

      // Cargar companyId desde dispositivo en Supabase
      final response = await SupabaseService.client
          .from('devices')
          .select('company_id')
          .eq('id', deviceId)
          .single();

      if (response['company_id'] != null) {
        ref.read(companyIdProvider.notifier).state = response['company_id'];
        return true;
      }
    }

    // Si no hay configuración, usar valores demo
    ref.read(deviceIdProvider.notifier).state = 'device_001';
    ref.read(companyIdProvider.notifier).state =
        'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
    return true;
  } catch (e) {
    // En caso de error, usar configuración demo
    ref.read(deviceIdProvider.notifier).state = 'device_001';
    ref.read(companyIdProvider.notifier).state =
        'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
    return true;
  }
});

// Helper function para cargar device ID desde storage
Future<String?> _loadDeviceIdFromStorage() async {
  // TODO: Implementar storage local (SharedPreferences o similar)
  // Por ahora devolver null para usar demo
  return null;
}

// Current device config provider
final deviceConfigProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final deviceId = ref.watch(deviceIdProvider);
  if (deviceId == null) return null;

  final response = await SupabaseService.client
      .from('devices')
      .select()
      .eq('id', deviceId)
      .single();

  return response;
});

// UI overrides provider
final uiOverridesProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return null;

  final response = await SupabaseService.client
      .from('ui_overrides')
      .select()
      .eq('company_id', companyId)
      .eq('scope', 'default_ui')
      .single();

  return response;
});

// Themes provider
final themesProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return null;

  final response = await SupabaseService.client
      .from('themes')
      .select()
      .eq('company_id', companyId)
      .eq('scope', 'default_ui')
      .single();

  return response;
});

// Zones provider
final zonesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) {
    // Si no hay companyId, intentar cargar desde configuración demo
    ref.read(companyIdProvider.notifier).state =
        'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
    return _getDemoZones();
  }

  try {
    // Usar la nueva tabla parking_zones en lugar de zones
    final response =
        await SupabaseService.client.from('parking_zones').select('''
          id,
          zone_code,
          name,
          description,
          color,
          icon,
          schedule_json,
          price_per_hour_cents,
          price_per_minute_cents,
          max_duration_hours,
          min_duration_minutes,
          is_active,
          created_at,
          updated_at
        ''').eq('company_id', companyId).eq('is_active', true).order('name');

    if (response.isNotEmpty) {
      // Transformar los datos para mantener compatibilidad con el código existente
      return response
          .map((zone) => {
                'id': zone['zone_code'],
                'name': zone['name'],
                'description': zone['description'],
                'color': zone['color'],
                'icon': zone['icon'],
                'schedule_json': zone['schedule_json'],
                'price_per_hour_cents': zone['price_per_hour_cents'],
                'price_per_minute_cents': zone['price_per_minute_cents'],
                'max_duration_hours': zone['max_duration_hours'],
                'min_duration_minutes': zone['min_duration_minutes'],
                'is_active': zone['is_active'],
                'created_at': zone['created_at'],
                'updated_at': zone['updated_at'],
              })
          .toList();
    }

    return _getDemoZones();
  } catch (e) {
    print('Error cargando zonas desde Supabase: $e');
    // Si falla la conexión, usar datos demo como fallback
    return _getDemoZones();
  }
});

// Datos de prueba para zonas
List<Map<String, dynamic>> _getDemoZones() {
  return [
    {
      'id': 'zone_001',
      'name': 'Zona Centro',
      'color': '#FF6B6B',
      'is_active': true,
      'schedule_json': {
        'monday': {'start': '08:00', 'end': '20:00'},
        'tuesday': {'start': '08:00', 'end': '20:00'},
        'wednesday': {'start': '08:00', 'end': '20:00'},
        'thursday': {'start': '08:00', 'end': '20:00'},
        'friday': {'start': '08:00', 'end': '20:00'},
        'saturday': {'start': '09:00', 'end': '14:00'},
        'sunday': {'start': '10:00', 'end': '14:00'},
      },
    },
    {
      'id': 'zone_002',
      'name': 'Zona Comercial',
      'color': '#4ECDC4',
      'is_active': true,
      'schedule_json': {
        'monday': {'start': '09:00', 'end': '21:00'},
        'tuesday': {'start': '09:00', 'end': '21:00'},
        'wednesday': {'start': '09:00', 'end': '21:00'},
        'thursday': {'start': '09:00', 'end': '21:00'},
        'friday': {'start': '09:00', 'end': '21:00'},
        'saturday': {'start': '10:00', 'end': '22:00'},
        'sunday': {'start': '10:00', 'end': '20:00'},
      },
    },
    {
      'id': 'zone_003',
      'name': 'Zona Residencial',
      'color': '#45B7D1',
      'is_active': true,
      'schedule_json': {
        'monday': {'start': '08:00', 'end': '18:00'},
        'tuesday': {'start': '08:00', 'end': '18:00'},
        'wednesday': {'start': '08:00', 'end': '18:00'},
        'thursday': {'start': '08:00', 'end': '18:00'},
        'friday': {'start': '08:00', 'end': '18:00'},
        'saturday': {'start': '09:00', 'end': '15:00'},
        'sunday': {'start': '10:00', 'end': '14:00'},
      },
    },
    {
      'id': 'zone_004',
      'name': 'Zona Turística',
      'color': '#96CEB4',
      'is_active': true,
      'schedule_json': {
        'monday': {'start': '07:00', 'end': '23:00'},
        'tuesday': {'start': '07:00', 'end': '23:00'},
        'wednesday': {'start': '07:00', 'end': '23:00'},
        'thursday': {'start': '07:00', 'end': '23:00'},
        'friday': {'start': '07:00', 'end': '23:00'},
        'saturday': {'start': '07:00', 'end': '23:00'},
        'sunday': {'start': '07:00', 'end': '23:00'},
      },
    },
    {
      'id': 'zone_005',
      'name': 'Zona Hospital',
      'color': '#FECA57',
      'is_active': true,
      'schedule_json': {
        'monday': {'start': '00:00', 'end': '23:59'},
        'tuesday': {'start': '00:00', 'end': '23:59'},
        'wednesday': {'start': '00:00', 'end': '23:59'},
        'thursday': {'start': '00:00', 'end': '23:59'},
        'friday': {'start': '00:00', 'end': '23:59'},
        'saturday': {'start': '00:00', 'end': '23:59'},
        'sunday': {'start': '00:00', 'end': '23:59'},
      },
    },
    {
      'id': 'zone_006',
      'name': 'Zona Universidad',
      'color': '#FF9FF3',
      'is_active': true,
      'schedule_json': {
        'monday': {'start': '07:00', 'end': '19:00'},
        'tuesday': {'start': '07:00', 'end': '19:00'},
        'wednesday': {'start': '07:00', 'end': '19:00'},
        'thursday': {'start': '07:00', 'end': '19:00'},
        'friday': {'start': '07:00', 'end': '19:00'},
        'saturday': {'start': '08:00', 'end': '14:00'},
        'sunday': {'start': '09:00', 'end': '13:00'},
      },
    },
  ];
}

// Tariffs provider
final tariffsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final zones = await ref.watch(zonesProvider.future);
  if (zones.isEmpty) return [];

  final zoneIds = zones.map((zone) => zone['id']).toList();

  final response = await SupabaseService.client
      .from('tariffs')
      .select()
      .inFilter('zone_id', zoneIds);

  return List<Map<String, dynamic>>.from(response);
});

// Accessibility settings provider
final accessibilityProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return _getDefaultAccessibilitySettings();

  try {
    final response = await SupabaseService.client
        .from('accessibility_configs')
        .select()
        .eq('company_id', companyId)
        .eq('is_active', true)
        .single();

    return response;
  } catch (e) {
    return _getDefaultAccessibilitySettings();
  }
});

// Language settings provider
final languageProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return _getDefaultLanguageSettings();

  try {
    final response = await SupabaseService.client
        .from('language_configs')
        .select()
        .eq('company_id', companyId)
        .eq('is_active', true);

    final languages = List<Map<String, dynamic>>.from(response);
    return {
      'available': languages,
      'default': languages.firstWhere((l) => l['is_default'] == true,
          orElse: () => languages.isNotEmpty
              ? languages.first
              : _getDefaultLanguageSettings()['default'])
    };
  } catch (e) {
    return _getDefaultLanguageSettings();
  }
});

// UI Configuration provider
final uiConfigProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return _getDefaultUIConfig();

  try {
    final response = await SupabaseService.client
        .from('ui_configs')
        .select()
        .eq('company_id', companyId)
        .eq('is_active', true)
        .single();

    return response;
  } catch (e) {
    return _getDefaultUIConfig();
  }
});

// Helper functions for default configurations
Map<String, dynamic> _getDefaultAccessibilitySettings() {
  return {
    'high_contrast': false,
    'large_text': false,
    'voice_guidance': false,
    'simplified_mode': false,
    'dark_mode': false,
    'adaptive_ai': true,
  };
}

Map<String, dynamic> _getDefaultLanguageSettings() {
  return {
    'available': [
      {'code': 'es', 'name': 'Español', 'is_default': true},
      {'code': 'en', 'name': 'English', 'is_default': false},
      {'code': 'ca', 'name': 'Català', 'is_default': false},
    ],
    'default': {'code': 'es', 'name': 'Español', 'is_default': true}
  };
}

Map<String, dynamic> _getDefaultUIConfig() {
  return {
    'primary_color': '#E62144',
    'secondary_color': '#8B1538',
    'accent_color': '#FF6B6B',
    'font_size_base': 16.0,
    'font_size_large': 20.0,
    'button_height': 56.0,
    'company_name': 'MEYPARK',
    'logo_url': null,
    'show_clock': true,
    'time_format_24h': true,
  };
}

// AI Settings provider
final aiSettingsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  final deviceId = ref.watch(deviceIdProvider);
  if (companyId == null) return null;

  final response = await SupabaseService.client
      .from('ai_settings')
      .select()
      .eq('company_id', companyId)
      .eq('device_id', deviceId!)
      .single();

  return response;
});

// Accessibility prefs provider
final accessibilityPrefsProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  final deviceId = ref.watch(deviceIdProvider);
  if (deviceId == null) return null;

  final response = await SupabaseService.client
      .from('accessibility_prefs')
      .select()
      .eq('device_id', deviceId!)
      .single();

  return response;
});

// AI Recommendations provider
final aiRecommendationsProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  final deviceId = ref.watch(deviceIdProvider);
  final companyId = ref.watch(companyIdProvider);
  if (deviceId == null || companyId == null) return null;

  // Obtener zona más usada
  final lastPayments = await SupabaseService.client
      .from('payments')
      .select('*, tickets(zones(*))')
      .eq('device_id', deviceId!)
      .order('created_at', ascending: false)
      .limit(5);

  // Contar frecuencia por zona
  final zoneCount = <String, int>{};
  for (final payment in lastPayments) {
    final zoneId = payment['tickets']?['zone_id'];
    if (zoneId != null) {
      zoneCount[zoneId] = (zoneCount[zoneId] ?? 0) + 1;
    }
  }

  String? mostUsedZoneId;
  if (zoneCount.isNotEmpty) {
    mostUsedZoneId =
        zoneCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  // Obtener método de pago recomendado
  final paymentStats = await SupabaseService.client
      .from('payments')
      .select('provider, status')
      .eq('device_id', deviceId!)
      .order('created_at', ascending: false)
      .limit(10);

  final successRate = <String, double>{};
  final methodCount = <String, int>{};

  for (final payment in paymentStats) {
    final provider = payment['provider'] as String;
    final isSuccess = payment['status'] == 'succeeded';

    methodCount[provider] = (methodCount[provider] ?? 0) + 1;
    if (isSuccess) {
      successRate[provider] = (successRate[provider] ?? 0) + 1;
    }
  }

  String? recommendedPaymentMethod;
  if (successRate.isNotEmpty) {
    final finalRates = <String, double>{};
    for (final method in methodCount.keys) {
      final success = successRate[method] ?? 0;
      final total = methodCount[method]!;
      finalRates[method] = success / total;
    }

    recommendedPaymentMethod =
        finalRates.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  return {
    'most_used_zone_id': mostUsedZoneId,
    'recommended_payment_method': recommendedPaymentMethod,
    'recommended_duration': 30, // Default
  };
});

// Payment methods provider
final paymentMethodsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return _getDemoPaymentMethods();

  try {
    final response = await SupabaseService.client
        .from('payment_methods')
        .select('''
          id,
          method_code,
          name,
          description,
          icon,
          color,
          is_digital,
          requires_network,
          supports_refund,
          commission_percentage,
          fixed_fee_cents,
          is_active,
          sort_order,
          created_at,
          updated_at
        ''')
        .eq('company_id', companyId)
        .eq('is_active', true)
        .order('sort_order');

    if (response.isNotEmpty) {
      return response
          .map((method) => {
                'id': method['method_code'],
                'name': method['name'],
                'description': method['description'],
                'icon': method['icon'],
                'color': method['color'],
                'is_digital': method['is_digital'],
                'requires_network': method['requires_network'],
                'supports_refund': method['supports_refund'],
                'commission_percentage': method['commission_percentage'],
                'fixed_fee_cents': method['fixed_fee_cents'],
                'is_active': method['is_active'],
                'sort_order': method['sort_order'],
                'created_at': method['created_at'],
                'updated_at': method['updated_at'],
              })
          .toList();
    }

    return _getDemoPaymentMethods();
  } catch (e) {
    print('Error cargando métodos de pago desde Supabase: $e');
    return _getDemoPaymentMethods();
  }
});

// Supported countries provider
final supportedCountriesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return _getDemoCountries();

  try {
    final response = await SupabaseService.client
        .from('supported_countries')
        .select('''
          id,
          country_code,
          name,
          plate_patterns,
          currency_code,
          currency_symbol,
          is_active,
          sort_order,
          created_at,
          updated_at
        ''')
        .eq('company_id', companyId)
        .eq('is_active', true)
        .order('sort_order');

    if (response.isNotEmpty) {
      return response
          .map((country) => {
                'id': country['country_code'],
                'code': country['country_code'],
                'name': country['name'],
                'plate_patterns': country['plate_patterns'],
                'currency_code': country['currency_code'],
                'currency_symbol': country['currency_symbol'],
                'is_active': country['is_active'],
                'sort_order': country['sort_order'],
                'created_at': country['created_at'],
                'updated_at': country['updated_at'],
              })
          .toList();
    }

    return _getDemoCountries();
  } catch (e) {
    print('Error cargando países desde Supabase: $e');
    return _getDemoCountries();
  }
});

// Fines provider
final finesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
    (ref, plateNumber) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return [];

  try {
    final response = await SupabaseService.client
        .from('fines')
        .select('''
          id,
          fine_number,
          plate_number,
          country_code,
          reason,
          amount_cents,
          status,
          location_description,
          violation_time,
          created_at,
          paid_at,
          cancelled_at,
          inspector_notes,
          zone:parking_zones(zone_code, name)
        ''')
        .eq('company_id', companyId)
        .eq('plate_number', plateNumber)
        .order('violation_time', ascending: false);

    return response
        .map((fine) => {
              'id': fine['id'],
              'fine_number': fine['fine_number'],
              'plate': fine['plate_number'],
              'country': fine['country_code'],
              'reason': fine['reason'],
              'amount_cents': fine['amount_cents'],
              'status': fine['status'],
              'location_description': fine['location_description'],
              'violation_time': fine['violation_time'],
              'created_at': fine['created_at'],
              'paid_at': fine['paid_at'],
              'cancelled_at': fine['cancelled_at'],
              'inspector_notes': fine['inspector_notes'],
              'zone': fine['zone'],
            })
        .toList();
  } catch (e) {
    print('Error cargando denuncias desde Supabase: $e');
    return [];
  }
});

// Datos demo para métodos de pago
List<Map<String, dynamic>> _getDemoPaymentMethods() {
  return [
    {
      'id': 'card',
      'name': 'Tarjeta de Crédito/Débito',
      'description': 'Pago con tarjeta de crédito o débito',
      'icon': 'credit_card',
      'color': '#2196F3',
      'is_digital': true,
      'requires_network': true,
      'supports_refund': true,
      'commission_percentage': 2.50,
      'fixed_fee_cents': 0,
      'is_active': true,
      'sort_order': 1,
    },
    {
      'id': 'contactless',
      'name': 'Pago Sin Contacto',
      'description': 'Pago sin contacto con tarjeta o móvil',
      'icon': 'nfc',
      'color': '#4CAF50',
      'is_digital': true,
      'requires_network': true,
      'supports_refund': true,
      'commission_percentage': 1.80,
      'fixed_fee_cents': 0,
      'is_active': true,
      'sort_order': 2,
    },
    {
      'id': 'mobile',
      'name': 'Pago Móvil',
      'description': 'Pago con aplicación móvil',
      'icon': 'phone_android',
      'color': '#9C27B0',
      'is_digital': true,
      'requires_network': true,
      'supports_refund': true,
      'commission_percentage': 1.50,
      'fixed_fee_cents': 0,
      'is_active': true,
      'sort_order': 3,
    },
    {
      'id': 'cash',
      'name': 'Efectivo',
      'description': 'Pago en efectivo',
      'icon': 'money',
      'color': '#FF9800',
      'is_digital': false,
      'requires_network': false,
      'supports_refund': false,
      'commission_percentage': 0.00,
      'fixed_fee_cents': 0,
      'is_active': true,
      'sort_order': 4,
    },
  ];
}

// Datos demo para países
List<Map<String, dynamic>> _getDemoCountries() {
  return [
    {
      'id': 'ES',
      'code': 'ES',
      'name': 'España',
      'plate_patterns': [
        {
          'pattern': '^[0-9]{4}[A-Z]{3}\$',
          'description': 'Formato español: 4 números + 3 letras'
        },
        {
          'pattern': '^[A-Z]{1,2}[0-9]{4}[A-Z]{1,2}\$',
          'description': 'Formato antiguo español'
        }
      ],
      'currency_code': 'EUR',
      'currency_symbol': '€',
      'is_active': true,
      'sort_order': 1,
    },
    {
      'id': 'FR',
      'code': 'FR',
      'name': 'Francia',
      'plate_patterns': [
        {
          'pattern': '^[A-Z]{2}[0-9]{3}[A-Z]{2}\$',
          'description': 'Formato francés: 2 letras + 3 números + 2 letras'
        }
      ],
      'currency_code': 'EUR',
      'currency_symbol': '€',
      'is_active': true,
      'sort_order': 2,
    },
    {
      'id': 'DE',
      'code': 'DE',
      'name': 'Alemania',
      'plate_patterns': [
        {
          'pattern': '^[A-Z]{1,3}[A-Z]{1,2}[0-9]{1,4}[A-Z]{1,2}\$',
          'description': 'Formato alemán'
        }
      ],
      'currency_code': 'EUR',
      'currency_symbol': '€',
      'is_active': true,
      'sort_order': 3,
    },
    {
      'id': 'IT',
      'code': 'IT',
      'name': 'Italia',
      'plate_patterns': [
        {
          'pattern': '^[A-Z]{2}[0-9]{3}[A-Z]{2}\$',
          'description': 'Formato italiano: 2 letras + 3 números + 2 letras'
        }
      ],
      'currency_code': 'EUR',
      'currency_symbol': '€',
      'is_active': true,
      'sort_order': 4,
    },
    {
      'id': 'PT',
      'code': 'PT',
      'name': 'Portugal',
      'plate_patterns': [
        {
          'pattern': '^[0-9]{2}[A-Z]{2}[0-9]{2}\$',
          'description': 'Formato portugués: 2 números + 2 letras + 2 números'
        }
      ],
      'currency_code': 'EUR',
      'currency_symbol': '€',
      'is_active': true,
      'sort_order': 5,
    },
    {
      'id': 'GB',
      'code': 'GB',
      'name': 'Reino Unido',
      'plate_patterns': [
        {
          'pattern': '^[A-Z]{2}[0-9]{2}[A-Z]{3}\$',
          'description': 'Formato británico: 2 letras + 2 números + 3 letras'
        }
      ],
      'currency_code': 'GBP',
      'currency_symbol': '£',
      'is_active': true,
      'sort_order': 6,
    },
  ];
}

// System passwords provider
final systemPasswordsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return _getDemoPasswords();

  try {
    final response =
        await SupabaseService.client.from('system_passwords').select('''
          password_type,
          is_active,
          max_attempts,
          lockout_duration_minutes,
          created_at,
          updated_at,
          last_used_at
        ''').eq('company_id', companyId).eq('is_active', true);

    if (response.isNotEmpty) {
      final passwords = <String, Map<String, dynamic>>{};
      for (final password in response) {
        passwords[password['password_type']] = {
          'type': password['password_type'],
          'is_active': password['is_active'],
          'max_attempts': password['max_attempts'],
          'lockout_duration_minutes': password['lockout_duration_minutes'],
          'created_at': password['created_at'],
          'updated_at': password['updated_at'],
          'last_used_at': password['last_used_at'],
        };
      }
      return passwords;
    }

    return _getDemoPasswords();
  } catch (e) {
    print('Error cargando contraseñas del sistema desde Supabase: $e');
    return _getDemoPasswords();
  }
});

// Función para verificar contraseña
final verifyPasswordProvider =
    FutureProvider.family<bool, Map<String, String>>((ref, params) async {
  final companyId = ref.watch(companyIdProvider);
  final passwordType = params['type']!;
  final password = params['password']!;

  if (companyId == null) {
    // Fallback a contraseñas demo
    return _verifyDemoPassword(passwordType, password);
  }

  try {
    final response =
        await SupabaseService.client.rpc('verify_system_password', params: {
      'p_company_id': companyId,
      'p_password_type': passwordType,
      'p_password': password,
    });

    // Registrar intento de acceso
    await SupabaseService.client.rpc('log_access_attempt', params: {
      'p_company_id': companyId,
      'p_device_id': ref.watch(deviceIdProvider),
      'p_password_type': passwordType,
      'p_attempt_ip': null, // No disponible en Flutter
      'p_success': response,
    });

    return response;
  } catch (e) {
    print('Error verificando contraseña: $e');
    return _verifyDemoPassword(passwordType, password);
  }
});

// Datos demo para contraseñas
Map<String, dynamic> _getDemoPasswords() {
  return {
    'login': {
      'type': 'login',
      'is_active': true,
      'max_attempts': 3,
      'lockout_duration_minutes': 15,
    },
    'tech_mode': {
      'type': 'tech_mode',
      'is_active': true,
      'max_attempts': 5,
      'lockout_duration_minutes': 30,
    },
  };
}

// Verificar contraseña demo
bool _verifyDemoPassword(String type, String password) {
  switch (type) {
    case 'login':
      return password == 'meypark2025';
    case 'tech_mode':
      return password == 'admin123';
    default:
      return false;
  }
}
