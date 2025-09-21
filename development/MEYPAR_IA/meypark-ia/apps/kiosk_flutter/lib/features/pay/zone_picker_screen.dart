import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/supabase_providers.dart';
import '../../widgets/dynamic_app_bar.dart';

class ZonePickerScreen extends ConsumerWidget {
  const ZonePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zones = ref.watch(zonesProvider);
    final aiRecommendations = ref.watch(aiRecommendationsProvider);

    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Column(
        children: [
          // Zona más usada (IA) - si está habilitada
          if (_shouldShowMostUsedZone(aiRecommendations))
            _buildMostUsedZoneCard(context, ref, aiRecommendations),

          // Lista de zonas
          Expanded(
            child: zones.when(
              data: (zonesList) =>
                  _buildZonesList(context, zonesList, aiRecommendations),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar zonas',
                      style:
                          TextStyle(fontSize: 18, color: Colors.red.shade700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style:
                          TextStyle(fontSize: 14, color: Colors.red.shade500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(zonesProvider),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMostUsedZoneCard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Map<String, dynamic>?> aiRecommendations,
  ) {
    if (aiRecommendations.value == null) return const SizedBox.shrink();

    final mostUsedZoneId =
        aiRecommendations.value!['most_used_zone_id'] as String?;
    if (mostUsedZoneId == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        color: Colors.amber.shade50,
        child: InkWell(
          onTap: () => _selectZone(context, mostUsedZoneId),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber.shade700),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Zona más usada',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Text(
                  'Zona Azul Centro',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZonesList(
    BuildContext context,
    List<Map<String, dynamic>> zones,
    AsyncValue<Map<String, dynamic>?> aiRecommendations,
  ) {
    if (zones.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay zonas disponibles',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: zones.length,
      itemBuilder: (context, index) {
        final zone = zones[index];
        final isMostUsed =
            aiRecommendations.value?['most_used_zone_id'] == zone['id'];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ZoneCard(
            zone: zone,
            isMostUsed: isMostUsed,
            onTap: () => _selectZone(context, zone['id']),
          ),
        );
      },
    );
  }

  bool _shouldShowMostUsedZone(
      AsyncValue<Map<String, dynamic>?> aiRecommendations) {
    if (aiRecommendations.value == null) return false;

    final mostUsedZoneId =
        aiRecommendations.value!['most_used_zone_id'] as String?;
    return mostUsedZoneId != null;
  }

  void _selectZone(BuildContext context, String zoneId) {
    // TODO: Guardar zona seleccionada y navegar a siguiente pantalla
    print('Selected zone: $zoneId');
    context.go('/pay/plate');
  }
}

class ZoneCard extends StatelessWidget {
  final Map<String, dynamic> zone;
  final bool isMostUsed;
  final VoidCallback onTap;

  const ZoneCard({
    super.key,
    required this.zone,
    required this.isMostUsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        Color(int.parse(zone['color'].toString().replaceFirst('#', '0xFF')));
    final name = zone['name'] as String;
    final code = zone['code'] as String;

    return Card(
      elevation: isMostUsed ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isMostUsed
            ? BorderSide(color: Colors.amber, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),

              // Zone info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isMostUsed) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.star,
                            color: Colors.amber.shade700,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Código: $code',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
