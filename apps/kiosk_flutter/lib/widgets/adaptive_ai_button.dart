import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/services/adaptive_ai_service.dart';
import '../core/providers/supabase_providers.dart';

class AdaptiveAIButton extends ConsumerWidget {
  const AdaptiveAIButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(adaptiveRecommendationsProvider);
    final zones = ref.watch(zonesProvider);

    return recommendations.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (recommendations) => zones.when(
        loading: () => const SizedBox.shrink(),
        error: (error, stack) => const SizedBox.shrink(),
        data: (zonesList) =>
            _buildAdaptiveButton(context, ref, recommendations, zonesList),
      ),
    );
  }

  Widget _buildAdaptiveButton(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> recommendations,
    List<Map<String, dynamic>> zones,
  ) {
    final recommendedZoneId = recommendations['zone'];
    final confidence = recommendations['confidence'] ?? 0.0;

    // Solo mostrar si hay recomendaciones con suficiente confianza
    if (recommendedZoneId == null || confidence < 0.3) {
      return const SizedBox.shrink();
    }

    // Buscar la zona recomendada
    final recommendedZone = zones.firstWhere(
      (zone) => zone['id'] == recommendedZoneId,
      orElse: () => {},
    );

    if (recommendedZone.isEmpty) return const SizedBox.shrink();

    final zoneName = recommendedZone['name'] ?? 'Zona desconocida';
    final zoneColor = recommendedZone['color'] ?? '#E62144';
    final duration = recommendations['duration'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color(int.parse(zoneColor.replaceFirst('#', '0xFF')))
                    .withOpacity(0.8),
                Color(int.parse(zoneColor.replaceFirst('#', '0xFF'))),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            onTap: () => _handleQuickPay(context, recommendedZoneId),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Icono de IA
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Información de la recomendación
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.psychology,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'IA RECOMIENDA',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pago rápido en $zoneName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (duration != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Duración sugerida: ${duration}min',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Indicador de confianza
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(confidence * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getConfidenceLabel(confidence),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // Flecha
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleQuickPay(BuildContext context, String zoneId) {
    // Navegar directamente a la zona recomendada
    context
        .goNamed('plate-input', extra: {'zoneId': zoneId, 'isQuickPay': true});
  }

  String _getConfidenceLabel(double confidence) {
    if (confidence >= 0.8) return 'MUY SEGURO';
    if (confidence >= 0.6) return 'SEGURO';
    if (confidence >= 0.4) return 'PROBABLE';
    return 'NUEVA SUGERENCIA';
  }
}

// Widget para mostrar estadísticas de la IA (modo técnico)
class AdaptiveAIStats extends ConsumerWidget {
  const AdaptiveAIStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(adaptiveRecommendationsProvider);

    return recommendations.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (data) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estadísticas de IA Adaptativa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStatRow('Zona recomendada', data['zone'] ?? 'N/A'),
              _buildStatRow(
                  'Duración recomendada', '${data['duration'] ?? 'N/A'} min'),
              _buildStatRow('Método de pago', data['paymentMethod'] ?? 'N/A'),
              _buildStatRow('Nivel de confianza',
                  '${((data['confidence'] ?? 0.0) * 100).round()}%'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _clearData(ref),
                child: const Text('Limpiar datos de aprendizaje'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _clearData(WidgetRef ref) async {
    final service = ref.read(adaptiveAIServiceProvider);
    await service.clearLearningData();
    ref.invalidate(adaptiveRecommendationsProvider);
  }
}
