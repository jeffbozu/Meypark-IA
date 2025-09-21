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

// Device ID provider
final deviceIdProvider = StateProvider<String?>((ref) => null);

// Company ID provider
final companyIdProvider = StateProvider<String?>((ref) => null);

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
  if (companyId == null) return [];

  final response = await SupabaseService.client
      .from('zones')
      .select()
      .eq('company_id', companyId)
      .eq('is_active', true)
      .order('name');

  return List<Map<String, dynamic>>.from(response);
});

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
