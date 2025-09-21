import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/supabase_providers.dart';
import '../../widgets/dynamic_app_bar.dart';
import '../../core/utils/currency_formatter.dart';

class DurationScreen extends ConsumerStatefulWidget {
  const DurationScreen({super.key});

  @override
  ConsumerState<DurationScreen> createState() => _DurationScreenState();
}

class _DurationScreenState extends ConsumerState<DurationScreen> {
  int _selectedDuration = 30; // Default duration in minutes
  Map<String, dynamic>? _selectedZone;
  Map<String, dynamic>? _selectedTariff;

  @override
  void initState() {
    super.initState();
    _loadZoneAndTariff();
  }

  void _loadZoneAndTariff() {
    // TODO: Load selected zone and tariff from state
    _selectedZone = {
      'id': 'zone-1',
      'name': 'Zona Azul Centro',
      'color': '#2196F3',
    };

    _selectedTariff = {
      'id': 'tariff-1',
      'price_per_min_cents': 50, // 0.50€ per minute
      'min_minutes': 15,
      'max_minutes': 120,
      'step_minutes': 5,
      'presets': [15, 30, 60, 120],
    };
  }

  @override
  Widget build(BuildContext context) {
    final aiRecommendations = ref.watch(aiRecommendationsProvider);

    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Column(
        children: [
          // Zone info header
          if (_selectedZone != null) _buildZoneHeader(),

          // Duration presets
          _buildDurationPresets(),

          // Manual duration controls
          _buildManualControls(),

          // Payment info
          _buildPaymentInfo(),

          // AI recommendation
          if (_shouldShowAIRecommendation(aiRecommendations))
            _buildAIRecommendation(aiRecommendations),

          const Spacer(),

          // Continue button
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildZoneHeader() {
    final color = Color(int.parse(
        _selectedZone!['color'].toString().replaceFirst('#', '0xFF')));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: color, width: 2),
        ),
      ),
      child: Column(
        children: [
          Text(
            _selectedZone!['name'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(_selectedTariff!['price_per_min_cents'] / 100).toStringAsFixed(2)}€ por minuto',
            style: TextStyle(
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationPresets() {
    final presets =
        _selectedTariff?['presets'] as List<int>? ?? [15, 30, 60, 120];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Duración',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: presets.map((preset) {
              final isSelected = _selectedDuration == preset;
              final price = _calculatePrice(preset);

              return GestureDetector(
                onTap: () => _selectDuration(preset),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.shade100
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${preset} min',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.blue.shade700
                              : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(price),
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected
                              ? Colors.blue.shade600
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildManualControls() {
    final minMinutes = _selectedTariff?['min_minutes'] as int? ?? 15;
    final maxMinutes = _selectedTariff?['max_minutes'] as int? ?? 120;
    final stepMinutes = _selectedTariff?['step_minutes'] as int? ?? 5;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Decrease button
          IconButton(
            onPressed:
                _selectedDuration > minMinutes ? _decreaseDuration : null,
            icon: Icon(
              Icons.remove_circle_outline,
              size: 48,
              color: _selectedDuration > minMinutes ? Colors.red : Colors.grey,
            ),
          ),

          // Duration display
          Container(
            width: 120,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Text(
                '$_selectedDuration min',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Increase button
          IconButton(
            onPressed:
                _selectedDuration < maxMinutes ? _increaseDuration : null,
            icon: Icon(
              Icons.add_circle_outline,
              size: 48,
              color:
                  _selectedDuration < maxMinutes ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    final endTime = _calculateEndTime();
    final totalPrice = _calculatePrice(_selectedDuration);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hora fin:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                endTime,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Importe total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                CurrencyFormatter.format(totalPrice),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecommendation(
      AsyncValue<Map<String, dynamic>?> aiRecommendations) {
    if (aiRecommendations.value == null) return const SizedBox.shrink();

    final recommendedDuration =
        aiRecommendations.value!['recommended_duration'] as int? ?? 30;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.psychology, color: Colors.amber.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '🤖 Recomendado: $recommendedDuration minutos (basado en su historial)',
              style: TextStyle(
                fontSize: 16,
                color: Colors.amber.shade800,
              ),
            ),
          ),
          if (recommendedDuration != _selectedDuration)
            TextButton(
              onPressed: () => _selectDuration(recommendedDuration),
              child: const Text('Aplicar'),
            ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _continue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size(0, 60),
        ),
        child: const Text(
          'CONTINUAR',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  bool _shouldShowAIRecommendation(
      AsyncValue<Map<String, dynamic>?> aiRecommendations) {
    if (aiRecommendations.value == null) return false;

    final recommendedDuration =
        aiRecommendations.value!['recommended_duration'] as int?;
    return recommendedDuration != null &&
        recommendedDuration != _selectedDuration;
  }

  void _selectDuration(int duration) {
    setState(() {
      _selectedDuration = duration;
    });
  }

  void _decreaseDuration() {
    final stepMinutes = _selectedTariff?['step_minutes'] as int? ?? 5;
    final minMinutes = _selectedTariff?['min_minutes'] as int? ?? 15;

    if (_selectedDuration - stepMinutes >= minMinutes) {
      setState(() {
        _selectedDuration -= stepMinutes;
      });
    }
  }

  void _increaseDuration() {
    final stepMinutes = _selectedTariff?['step_minutes'] as int? ?? 5;
    final maxMinutes = _selectedTariff?['max_minutes'] as int? ?? 120;

    if (_selectedDuration + stepMinutes <= maxMinutes) {
      setState(() {
        _selectedDuration += stepMinutes;
      });
    }
  }

  double _calculatePrice(int duration) {
    final pricePerMinCents =
        _selectedTariff?['price_per_min_cents'] as int? ?? 50;
    return (duration * pricePerMinCents) / 100.0;
  }

  String _calculateEndTime() {
    final now = DateTime.now();
    final endTime = now.add(Duration(minutes: _selectedDuration));
    return '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  void _continue() {
    // TODO: Guardar duración seleccionada y navegar a pantalla de pago
    print('Selected duration: $_selectedDuration minutes');
    context.go('/pay/payment');
  }
}
