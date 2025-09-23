import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dynamic_app_bar.dart';
import '../../core/providers/supabase_providers.dart';

class ZonePickerScreen extends ConsumerWidget {
  const ZonePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE62144),
              const Color(0xFF8B1538),
            ],
          ),
        ),
        child: Column(
          children: [
            // Título
            Text(
              'Selecciona tu Zona de Estacionamiento',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Lista de zonas desde Supabase
            Expanded(
              child: _buildZonesListFromSupabase(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZonesListFromSupabase(BuildContext context, WidgetRef ref) {
    final zonesAsync = ref.watch(zonesProvider);

    return zonesAsync.when(
      data: (zones) => _buildZonesGrid(context, zones),
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.white, size: 64),
            const SizedBox(height: 16),
            Text(
              'Error cargando zonas',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
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
    );
  }

  Widget _buildZonesGrid(
      BuildContext context, List<Map<String, dynamic>> zones) {
    return ListView.builder(
      itemCount: zones.length,
      itemBuilder: (context, index) {
        final zone = zones[index];
        return _buildZoneCard(context, zone);
      },
    );
  }

  Widget _buildZoneCard(BuildContext context, Map<String, dynamic> zone) {
    final color = Color(int.parse(zone['color'].replaceFirst('#', '0xFF')));
    final name = zone['name'] ?? 'Zona sin nombre';
    final schedule = zone['schedule_json'] ?? {};
    final isActive = zone['is_active'] ?? true;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: isActive ? () => _selectZone(context, zone['id']) : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(isActive ? 0.1 : 0.05),
                  color.withOpacity(isActive ? 0.05 : 0.02)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // Icono de zona
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isActive ? color : color.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isActive ? Icons.local_parking : Icons.block,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),

                // Información de la zona
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isActive ? color : Colors.grey,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isActive ? 'Zona activa' : 'Zona inactiva',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  isActive ? Colors.grey.shade600 : Colors.red,
                            ),
                      ),
                    ],
                  ),
                ),

                // Estado
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      isActive ? Icons.check_circle : Icons.cancel,
                      color: isActive ? Colors.green : Colors.red,
                      size: 24,
                    ),
                    Text(
                      isActive ? 'Disponible' : 'No disponible',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isActive ? Colors.green : Colors.red,
                          ),
                    ),
                  ],
                ),

                const SizedBox(width: 12),
                Icon(
                  isActive ? Icons.arrow_forward_ios : Icons.block,
                  color: isActive ? color : Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectZone(BuildContext context, String zoneId) {
    // Navegar a la siguiente pantalla (placa)
    context.goNamed('pay-plate', extra: {'zoneId': zoneId});
  }
}
