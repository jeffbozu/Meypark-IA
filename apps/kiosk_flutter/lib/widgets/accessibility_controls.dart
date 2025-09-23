import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/supabase_providers.dart';

class AccessibilityControls extends ConsumerStatefulWidget {
  const AccessibilityControls({super.key});

  @override
  ConsumerState<AccessibilityControls> createState() =>
      _AccessibilityControlsState();
}

class _AccessibilityControlsState extends ConsumerState<AccessibilityControls> {
  @override
  Widget build(BuildContext context) {
    final accessibilitySettings = ref.watch(accessibilityProvider);
    final languageSettings = ref.watch(languageProvider);

    return accessibilitySettings.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (settings) => languageSettings.when(
        loading: () => _buildAccessibilityControls(settings, null),
        error: (error, stack) => _buildAccessibilityControls(settings, null),
        data: (languages) => _buildAccessibilityControls(settings, languages),
      ),
    );
  }

  Widget _buildAccessibilityControls(Map<String, dynamic> accessibilitySettings,
      Map<String, dynamic>? languageSettings) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Botones de accesibilidad
          if (accessibilitySettings['high_contrast'] != null)
            _buildAccessibilityButton(
              icon: Icons.contrast,
              label: 'Alto contraste',
              onTap: () => _toggleHighContrast(),
            ),
          const SizedBox(width: 8),

          if (accessibilitySettings['large_text'] != null)
            _buildAccessibilityButton(
              icon: Icons.text_fields,
              label: 'Texto grande',
              onTap: () => _toggleLargeText(),
            ),
          const SizedBox(width: 8),

          if (accessibilitySettings['voice_guidance'] != null)
            _buildAccessibilityButton(
              icon: Icons.record_voice_over,
              label: 'Guía de voz',
              onTap: () => _toggleVoiceGuidance(),
            ),
          const SizedBox(width: 8),

          if (accessibilitySettings['dark_mode'] != null)
            _buildAccessibilityButton(
              icon: Icons.dark_mode,
              label: 'Modo oscuro',
              onTap: () => _toggleDarkMode(),
            ),
          const SizedBox(width: 8),

          if (accessibilitySettings['simplified_mode'] != null)
            _buildAccessibilityButton(
              icon: Icons.accessibility,
              label: 'Modo simple',
              onTap: () => _toggleSimplifiedMode(),
            ),

          const Spacer(),

          // Selector de idiomas
          if (languageSettings != null && languageSettings['available'] != null)
            _buildLanguageSelector(languageSettings),
        ],
      ),
    );
  }

  Widget _buildAccessibilityButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(Map<String, dynamic> languageSettings) {
    final availableLanguages =
        List<Map<String, dynamic>>.from(languageSettings['available'] ?? []);
    final currentLanguage =
        languageSettings['default'] ?? availableLanguages.first;

    return PopupMenuButton<Map<String, dynamic>>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              currentLanguage['code']?.toUpperCase() ?? 'ES',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => availableLanguages.map((language) {
        return PopupMenuItem<Map<String, dynamic>>(
          value: language,
          child: Row(
            children: [
              Text(language['name'] ?? ''),
              if (language['is_default'] == true) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check, size: 16, color: Colors.green),
              ],
            ],
          ),
        );
      }).toList(),
      onSelected: (language) => _changeLanguage(language),
    );
  }

  void _toggleHighContrast() {
    // TODO: Implementar toggle de alto contraste
    _showFeatureComingSoon('Alto contraste');
  }

  void _toggleLargeText() {
    // TODO: Implementar toggle de texto grande
    _showFeatureComingSoon('Texto grande');
  }

  void _toggleVoiceGuidance() {
    // TODO: Implementar toggle de guía de voz
    _showFeatureComingSoon('Guía de voz');
  }

  void _toggleDarkMode() {
    // TODO: Implementar toggle de modo oscuro
    _showFeatureComingSoon('Modo oscuro');
  }

  void _toggleSimplifiedMode() {
    // TODO: Implementar toggle de modo simple
    _showFeatureComingSoon('Modo simple');
  }

  void _changeLanguage(Map<String, dynamic> language) {
    // TODO: Implementar cambio de idioma
    _showFeatureComingSoon('Cambio de idioma a ${language['name']}');
  }

  void _showFeatureComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature: Funcionalidad en desarrollo'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
