import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dynamic_app_bar.dart';

class DurationScreen extends ConsumerStatefulWidget {
  const DurationScreen({super.key});

  @override
  ConsumerState<DurationScreen> createState() => _DurationScreenState();
}

class _DurationScreenState extends ConsumerState<DurationScreen> {
  int _selectedDuration = 1; // horas
  double _pricePerHour = 2.50;

  @override
  Widget build(BuildContext context) {
    final totalPrice = _selectedDuration * _pricePerHour;

    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Container(
        padding: const EdgeInsets.all(24),
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
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Duración del Estacionamiento',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecciona cuánto tiempo quieres estacionar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Selector de duración
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  // Botones de duración
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDurationButton(1, '1h'),
                      _buildDurationButton(2, '2h'),
                      _buildDurationButton(4, '4h'),
                      _buildDurationButton(8, '8h'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Selector manual
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed:
                            _selectedDuration > 1 ? _decreaseDuration : null,
                        icon: Icon(Icons.remove_circle,
                            color: Colors.white, size: 32),
                      ),
                      Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '$_selectedDuration h',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE62144),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:
                            _selectedDuration < 24 ? _increaseDuration : null,
                        icon: Icon(Icons.add_circle,
                            color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Resumen de precio
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Precio por hora:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        '$_pricePerHour€',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)}€',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Botón continuar
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _continue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFE62144),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'CONTINUAR AL PAGO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationButton(int hours, String label) {
    final isSelected = _selectedDuration == hours;

    return GestureDetector(
      onTap: () => setState(() => _selectedDuration = hours),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE62144)
                : Colors.white.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFFE62144) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _decreaseDuration() {
    if (_selectedDuration > 1) {
      setState(() => _selectedDuration--);
    }
  }

  void _increaseDuration() {
    if (_selectedDuration < 24) {
      setState(() => _selectedDuration++);
    }
  }

  void _continue() {
    // Navegar a la pantalla de pago
    context.goNamed('pay-payment', extra: {
      'zoneId': 'zone_001',
      'plate': 'ES-1234ABC',
      'duration': _selectedDuration,
      'totalPrice': _selectedDuration * _pricePerHour,
    });
  }
}
