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
    ref.read(companyIdProvider.notifier).state = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
    return true;
  } catch (e) {
    // En caso de error, usar configuración demo
    ref.read(deviceIdProvider.notifier).state = 'device_001';
    ref.read(companyIdProvider.notifier).state = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
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
    ref.read(companyIdProvider.notifier).state = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
    return _getDemoZones();
  }
  
  try {
    final response = await SupabaseService.client
        .from('zones')
        .select('*, tariffs(*)')
        .eq('company_id', companyId)
        .eq('is_active', true);
    
    final zones = List<Map<String, dynamic>>.from(response);
    return zones.isNotEmpty ? zones : _getDemoZones();
  } catch (e) {
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
          orElse: () => languages.isNotEmpty ? languages.first : _getDefaultLanguageSettings()['default'])
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
