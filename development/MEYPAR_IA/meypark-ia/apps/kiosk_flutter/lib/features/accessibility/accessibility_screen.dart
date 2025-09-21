import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/tts_service.dart';
import '../../core/providers/supabase_providers.dart';
import '../../widgets/dynamic_app_bar.dart';

class AccessibilityScreen extends ConsumerStatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  ConsumerState<AccessibilityScreen> createState() =>
      _AccessibilityScreenState();
}

class _AccessibilityScreenState extends ConsumerState<AccessibilityScreen> {
  @override
  void initState() {
    super.initState();
    TTSService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final ttsConfig = ref.watch(ttsConfigProvider);

    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Configuración de Accesibilidad',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // TTS Configuration
            _buildTTSSection(ttsConfig),
            const SizedBox(height: 32),

            // Visual Accessibility
            _buildVisualSection(),
            const SizedBox(height: 32),

            // AI Adaptive Features
            _buildAISection(),
            const SizedBox(height: 32),

            // Test TTS Button
            _buildTestButton(),
            const SizedBox(height: 32),

            // Back Button
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTTSSection(TTSConfig config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.volume_up, size: 32),
                const SizedBox(width: 12),
                const Text(
                  'Síntesis de Voz (TTS)',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Switch(
                  value: config.enabled,
                  onChanged: (value) {
                    ref.read(ttsConfigProvider.notifier).setEnabled(value);
                    if (value) {
                      TTSService.speak('Síntesis de voz activada');
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rate Control
            Row(
              children: [
                const Text('Velocidad:', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: config.rate,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: '${(config.rate * 100).round()}%',
                    onChanged: (value) {
                      ref.read(ttsConfigProvider.notifier).setRate(value);
                    },
                  ),
                ),
                Text('${(config.rate * 100).round()}%',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),

            // Pitch Control
            Row(
              children: [
                const Text('Tono:', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: config.pitch,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    label: '${config.pitch.toStringAsFixed(1)}',
                    onChanged: (value) {
                      ref.read(ttsConfigProvider.notifier).setPitch(value);
                    },
                  ),
                ),
                Text(config.pitch.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 16)),
              ],
            ),

            // Volume Control
            Row(
              children: [
                const Text('Volumen:', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: config.volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(config.volume * 100).round()}%',
                    onChanged: (value) {
                      ref.read(ttsConfigProvider.notifier).setVolume(value);
                    },
                  ),
                ),
                Text('${(config.volume * 100).round()}%',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.visibility, size: 32),
                const SizedBox(width: 12),
                const Text(
                  'Accesibilidad Visual',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // High Contrast Toggle
            ListTile(
              leading: const Icon(Icons.contrast),
              title:
                  const Text('Alto Contraste', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Mejora la visibilidad de los elementos'),
              trailing: Switch(
                value: false, // TODO: Implementar estado
                onChanged: (value) {
                  // TODO: Implementar alto contraste
                },
              ),
            ),

            // Large Text Toggle
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Texto Grande', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Aumenta el tamaño de la fuente'),
              trailing: Switch(
                value: false, // TODO: Implementar estado
                onChanged: (value) {
                  // TODO: Implementar texto grande
                },
              ),
            ),

            // Dark Mode Toggle
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Modo Oscuro', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Reduce la fatiga visual'),
              trailing: Switch(
                value: false, // TODO: Implementar estado
                onChanged: (value) {
                  // TODO: Implementar modo oscuro
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAISection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, size: 32),
                const SizedBox(width: 12),
                const Text(
                  'IA Adaptativa',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // AI Adaptive Toggle
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title:
                  const Text('IA Adaptativa', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Aprende de tus preferencias'),
              trailing: Switch(
                value: true, // TODO: Implementar estado
                onChanged: (value) {
                  // TODO: Implementar IA adaptativa
                },
              ),
            ),

            // Smart Presets Toggle
            ListTile(
              leading: const Icon(Icons.smart_toy),
              title: const Text('Presets Inteligentes',
                  style: TextStyle(fontSize: 18)),
              subtitle:
                  const Text('Sugiere duraciones basadas en el historial'),
              trailing: Switch(
                value: true, // TODO: Implementar estado
                onChanged: (value) {
                  // TODO: Implementar presets inteligentes
                },
              ),
            ),

            // Zone Recommendations Toggle
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Recomendaciones de Zona',
                  style: TextStyle(fontSize: 18)),
              subtitle: const Text('Muestra zonas más usadas'),
              trailing: Switch(
                value: true, // TODO: Implementar estado
                onChanged: (value) {
                  // TODO: Implementar recomendaciones
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton() {
    return ElevatedButton.icon(
      onPressed: () {
        TTSService.speak(
            'Esta es una prueba de síntesis de voz. La configuración actual es: velocidad al ${(TTSService.rate * 100).round()} por ciento, tono ${TTSService.pitch.toStringAsFixed(1)}, y volumen al ${(TTSService.volume * 100).round()} por ciento.');
      },
      icon: const Icon(Icons.play_arrow, size: 32),
      label: const Text(
        'Probar Síntesis de Voz',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return OutlinedButton.icon(
      onPressed: () {
        context.goNamed('home');
      },
      icon: const Icon(Icons.arrow_back, size: 32),
      label: const Text(
        'Volver al Inicio',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
