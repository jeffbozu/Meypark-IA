import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dynamic_app_bar.dart';

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

            // Lista de zonas
            Expanded(
              child: _buildZonesList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZonesList(BuildContext context) {
    // Datos de zonas demo
    final zones = [
      {
        'id': 'zone_001',
        'name': 'Zona Centro',
        'color': '#FF6B6B',
        'price': '2.50',
        'description': 'Zona céntrica con alta demanda',
      },
      {
        'id': 'zone_002',
        'name': 'Zona Comercial',
        'color': '#4ECDC4',
        'price': '3.00',
        'description': 'Área comercial y de oficinas',
      },
      {
        'id': 'zone_003',
        'name': 'Zona Residencial',
        'color': '#45B7D1',
        'price': '1.50',
        'description': 'Zona residencial con descuentos',
      },
      {
        'id': 'zone_004',
        'name': 'Zona Turística',
        'color': '#96CEB4',
        'price': '4.00',
        'description': 'Zona turística premium',
      },
      {
        'id': 'zone_005',
        'name': 'Zona Hospital',
        'color': '#FECA57',
        'price': '1.00',
        'description': 'Zona especial con tarifas reducidas',
      },
      {
        'id': 'zone_006',
        'name': 'Zona Universidad',
        'color': '#FF9FF3',
        'price': '2.00',
        'description': 'Zona universitaria con descuentos',
      },
    ];

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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _selectZone(context, zone['id']),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
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
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_parking,
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
                        zone['name'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        zone['description'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),

                // Precio
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${zone['price']}€',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                    ),
                    Text(
                      'por hora',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),

                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
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
