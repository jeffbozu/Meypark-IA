import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../supabase/supabase_client.dart';

class AdaptiveAIService {
  static const String _storageKey = 'adaptive_ai_data';
  static const String _lastPaymentsKey = 'last_payments';
  static const String _preferredZoneKey = 'preferred_zone';
  static const String _preferredDurationKey = 'preferred_duration';
  static const String _preferredPaymentKey = 'preferred_payment';

  static AdaptiveAIService? _instance;
  AdaptiveAIService._internal();
  factory AdaptiveAIService() => _instance ??= AdaptiveAIService._internal();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Registrar un nuevo pago para el aprendizaje
  Future<void> recordPayment({
    required String zoneId,
    required int durationMinutes,
    required String paymentMethod,
    required String licensePlate,
  }) async {
    await initialize();

    final payment = {
      'zoneId': zoneId,
      'duration': durationMinutes,
      'paymentMethod': paymentMethod,
      'licensePlate': licensePlate,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    // Guardar en storage local
    await _savePaymentLocally(payment);

    // Sincronizar con Supabase
    await _syncPaymentToSupabase(payment);

    // Actualizar recomendaciones
    await _updateRecommendations();
  }

  // Obtener la zona más usada (recomendación principal)
  Future<String?> getMostUsedZone() async {
    await initialize();

    final lastPayments = await _getLastPayments();
    if (lastPayments.isEmpty) return null;

    // Contar frecuencia de zonas en los últimos 5 pagos
    final zoneFrequency = <String, int>{};
    for (final payment in lastPayments.take(5)) {
      final zoneId = payment['zoneId'] as String;
      zoneFrequency[zoneId] = (zoneFrequency[zoneId] ?? 0) + 1;
    }

    // Encontrar la zona más frecuente
    String? mostUsedZone;
    int maxCount = 0;
    for (final entry in zoneFrequency.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        mostUsedZone = entry.key;
      }
    }

    return mostUsedZone;
  }

  // Obtener duración recomendada
  Future<int?> getRecommendedDuration() async {
    await initialize();

    final lastPayments = await _getLastPayments();
    if (lastPayments.isEmpty) return null;

    // Calcular promedio de duración de los últimos pagos
    final durations =
        lastPayments.take(5).map((p) => p['duration'] as int).toList();

    if (durations.isEmpty) return null;

    final averageDuration =
        durations.reduce((a, b) => a + b) / durations.length;
    return averageDuration.round();
  }

  // Obtener método de pago recomendado
  Future<String?> getRecommendedPaymentMethod() async {
    await initialize();

    final lastPayments = await _getLastPayments();
    if (lastPayments.isEmpty) return null;

    // Contar frecuencia de métodos de pago
    final methodFrequency = <String, int>{};
    for (final payment in lastPayments.take(5)) {
      final method = payment['paymentMethod'] as String;
      methodFrequency[method] = (methodFrequency[method] ?? 0) + 1;
    }

    // Encontrar el método más frecuente
    String? mostUsedMethod;
    int maxCount = 0;
    for (final entry in methodFrequency.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        mostUsedMethod = entry.key;
      }
    }

    return mostUsedMethod;
  }

  // Obtener recomendaciones completas
  Future<Map<String, dynamic>> getRecommendations() async {
    return {
      'zone': await getMostUsedZone(),
      'duration': await getRecommendedDuration(),
      'paymentMethod': await getRecommendedPaymentMethod(),
      'confidence': await _calculateConfidence(),
    };
  }

  // Guardar pago localmente
  Future<void> _savePaymentLocally(Map<String, dynamic> payment) async {
    final payments = await _getLastPayments();
    payments.insert(0, payment);

    // Mantener solo los últimos 10 pagos
    if (payments.length > 10) {
      payments.removeRange(10, payments.length);
    }

    await _prefs!.setString(_lastPaymentsKey, jsonEncode(payments));
  }

  // Sincronizar con Supabase
  Future<void> _syncPaymentToSupabase(Map<String, dynamic> payment) async {
    try {
      await SupabaseService.client.from('ai_learning_data').insert({
        'device_id': 'device_001', // TODO: Obtener desde configuración
        'zone_id': payment['zoneId'],
        'duration_minutes': payment['duration'],
        'payment_method': payment['paymentMethod'],
        'license_plate': payment['licensePlate'],
        'recorded_at': DateTime.fromMillisecondsSinceEpoch(payment['timestamp'])
            .toIso8601String(),
        'data_json': payment,
      });
    } catch (e) {
      // Silencioso si falla la sincronización - funciona offline
      print('Error syncing to Supabase: $e');
    }
  }

  // Obtener últimos pagos del storage local
  Future<List<Map<String, dynamic>>> _getLastPayments() async {
    final paymentsJson = _prefs!.getString(_lastPaymentsKey);
    if (paymentsJson == null) return [];

    try {
      final paymentsList = jsonDecode(paymentsJson) as List;
      return paymentsList.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  // Actualizar recomendaciones basadas en patrones
  Future<void> _updateRecommendations() async {
    final recommendations = await getRecommendations();

    if (recommendations['zone'] != null) {
      await _prefs!.setString(_preferredZoneKey, recommendations['zone']);
    }

    if (recommendations['duration'] != null) {
      await _prefs!.setInt(_preferredDurationKey, recommendations['duration']);
    }

    if (recommendations['paymentMethod'] != null) {
      await _prefs!
          .setString(_preferredPaymentKey, recommendations['paymentMethod']);
    }
  }

  // Calcular nivel de confianza de las recomendaciones
  Future<double> _calculateConfidence() async {
    final payments = await _getLastPayments();
    if (payments.length < 2) return 0.0;

    // La confianza aumenta con más datos y patrones consistentes
    double confidence = (payments.length / 10.0).clamp(0.0, 1.0);

    // Bonus por consistencia en patrones
    final zones = payments.take(5).map((p) => p['zoneId']).toSet();
    if (zones.length <= 2) confidence += 0.2; // Pocas zonas = más consistente

    return confidence.clamp(0.0, 1.0);
  }

  // Limpiar datos de aprendizaje
  Future<void> clearLearningData() async {
    await initialize();
    await _prefs!.remove(_lastPaymentsKey);
    await _prefs!.remove(_preferredZoneKey);
    await _prefs!.remove(_preferredDurationKey);
    await _prefs!.remove(_preferredPaymentKey);
  }
}

// Provider para el servicio de IA adaptativa
final adaptiveAIServiceProvider = Provider<AdaptiveAIService>((ref) {
  return AdaptiveAIService();
});

// Provider para recomendaciones
final adaptiveRecommendationsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.read(adaptiveAIServiceProvider);
  return await service.getRecommendations();
});
