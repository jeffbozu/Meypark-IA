import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/supabase_providers.dart';

class ExternalAPIService {
  static final Dio _dio = Dio();
  static const String _baseUrl = 'https://api.meypark.com'; // URL de ejemplo

  static Future<List<Map<String, dynamic>>> getZones(String companyId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/zones',
        queryParameters: {'company_id': companyId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['zones'] ?? []);
      } else {
        throw Exception('Failed to load zones: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching zones from external API: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getTariffs(String zoneId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/tariffs',
        queryParameters: {'zone_id': zoneId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['tariffs'] ?? []);
      } else {
        throw Exception('Failed to load tariffs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tariffs from external API: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> processPayment({
    required String zoneId,
    required String plate,
    required int amountCents,
    required String paymentMethod,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/payments',
        data: {
          'zone_id': zoneId,
          'plate': plate,
          'amount_cents': amountCents,
          'payment_method': paymentMethod,
          'timestamp': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Payment failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error processing payment: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getFine(String plate) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/fines',
        queryParameters: {'plate': plate},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to load fine: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching fine: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getCompanyConfig(String companyId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/companies/$companyId/config',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception(
            'Failed to load company config: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching company config: $e');
      rethrow;
    }
  }
}

// Provider para el servicio de API externa
final externalAPIServiceProvider =
    Provider<ExternalAPIService>((ref) => ExternalAPIService());

// Provider para zonas desde API externa
final externalZonesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return [];

  try {
    return await ExternalAPIService.getZones(companyId);
  } catch (e) {
    print('Error loading external zones: $e');
    return [];
  }
});

// Provider para tarifas desde API externa
final externalTariffsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, zoneId) async {
  try {
    return await ExternalAPIService.getTariffs(zoneId);
  } catch (e) {
    print('Error loading external tariffs: $e');
    return [];
  }
});

// Provider para configuración de compañía
final companyConfigProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  final companyId = ref.watch(companyIdProvider);
  if (companyId == null) return null;

  try {
    return await ExternalAPIService.getCompanyConfig(companyId);
  } catch (e) {
    print('Error loading company config: $e');
    return null;
  }
});

// Provider para procesar pagos
final paymentProcessorProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
        (ref, paymentData) async {
  try {
    return await ExternalAPIService.processPayment(
      zoneId: paymentData['zone_id'] as String,
      plate: paymentData['plate'] as String,
      amountCents: paymentData['amount_cents'] as int,
      paymentMethod: paymentData['payment_method'] as String,
    );
  } catch (e) {
    print('Error processing payment: $e');
    rethrow;
  }
});

// Provider para buscar multas
final fineSearchProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, plate) async {
  try {
    return await ExternalAPIService.getFine(plate);
  } catch (e) {
    print('Error searching fine: $e');
    return null;
  }
});
