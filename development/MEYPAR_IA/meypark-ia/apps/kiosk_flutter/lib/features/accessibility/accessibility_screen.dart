import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/supabase_providers.dart';
import '../../widgets/dynamic_app_bar.dart';

class AccessibilityScreen extends ConsumerStatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  ConsumerState<AccessibilityScreen> createState() =>
      _AccessibilityScreenState();
}

class _AccessibilityScreenState extends ConsumerState<AccessibilityScreen> {
  // Configuración de accesibilidad
  bool _darkMode = false;
  bool _highContrast = false;
  double _textSize = 100.0; // Porcentaje
  bool _ttsEnabled = false;
  double _ttsSpeed = 0.8;
  double _ttsPitch = 1.0;
  double _ttsVolume = 0.9;
  bool _voiceInput = false;
  bool _largeKeyboard = false;
  bool _simplifiedMode = false;
  bool _aiAdaptive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DynamicAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),

            const SizedBox(height: 24),

            // Sección Ver
            _buildVisionSection(),

            const SizedBox(height: 24),

            // Sección Escuchar
            _buildHearingSection(),

            const SizedBox(height: 24),

            // Sección Introducir
            _buildInputSection(),

            const SizedBox(height: 24),

            // Sección Tiempo
            _buildTimeSection(),

            const SizedBox(height: 24),

            // Sección Idioma
            _buildLanguageSection(),

            const SizedBox(height: 24),

            // Sección IA Adaptativa
            _buildAISection(),

            const SizedBox(height: 32),

            // Botones de acción
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.accessibility,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Configuración de Accesibilidad',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Personalice la aplicación según sus necesidades',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVisionSection() {
    return _buildSection(
      title: '👁️ VER',
      icon: Icons.visibility,
      children: [
        _buildAccessibilityCard(
          title: 'Modo Oscuro',
          description: 'Reduce la fatiga visual en entornos con poca luz',
          isEnabled: _darkMode,
          onToggle: (value) => setState(() => _darkMode = value),
          infoText: '''
🌙 MODO OSCURO

¿Qué hace?
• Cambia el fondo de la pantalla a colores oscuros
• Reduce la fatiga visual en entornos con poca luz
• Mejora la legibilidad en pantallas brillantes
• Ahorra batería en dispositivos OLED

¿Cuándo usarlo?
• En interiores con poca iluminación
• Durante la noche o al amanecer
• Si tiene sensibilidad a la luz brillante
• Para reducir el deslumbramiento

¿Cómo funciona?
• Aplica colores oscuros automáticamente
• Mantiene el contraste adecuado para la lectura
• Se activa/desactiva instantáneamente
• Se guarda su preferencia automáticamente
''',
        ),
        const SizedBox(height: 12),
        _buildAccessibilityCard(
          title: 'Alto Contraste',
          description:
              'Aumenta la diferencia entre colores para mejor legibilidad',
          isEnabled: _highContrast,
          onToggle: (value) => setState(() => _highContrast = value),
          infoText: '''
🔍 ALTO CONTRASTE

¿Qué hace?
• Aumenta la diferencia entre colores de texto y fondo
• Mejora la legibilidad para personas con discapacidades visuales
• Cumple con estándares WCAG 2.1 AAA
• Hace más visible cada elemento de la pantalla

¿Cuándo usarlo?
• Si tiene dificultades para leer texto normal
• En pantallas con poca calidad
• Con poca iluminación ambiental
• Si tiene problemas de visión

¿Cómo funciona?
• Aplica colores de máximo contraste
• Texto blanco sobre fondo negro
• Botones con bordes bien definidos
• Iconos con mayor definición
''',
        ),
        const SizedBox(height: 12),
        _buildSliderCard(
          title: 'Tamaño del Texto',
          description: 'Ajuste el tamaño de la fuente',
          value: _textSize,
          min: 100,
          max: 200,
          divisions: 10,
          onChanged: (value) => setState(() => _textSize = value),
          formatValue: (value) => '${value.toInt()}%',
        ),
      ],
    );
  }

  Widget _buildHearingSection() {
    return _buildSection(
      title: '🔊 ESCUCHAR',
      icon: Icons.hearing,
      children: [
        _buildAccessibilityCard(
          title: 'Guía por Voz (TTS)',
          description: 'Proporciona instrucciones auditivas',
          isEnabled: _ttsEnabled,
          onToggle: (value) => setState(() => _ttsEnabled = value),
          hasSettings: true,
          onSettings: () => _showTTSSettings(),
          infoText: '''
🔊 GUÍA POR VOZ

¿Qué hace?
• Lee en voz alta todo el contenido de la pantalla
• Proporciona instrucciones paso a paso
• Describe botones y opciones disponibles
• Ayuda a navegar sin necesidad de ver la pantalla

¿Cuándo usarlo?
• Si tiene discapacidad visual
• Para aprender a usar la aplicación
• Cuando no puede ver bien la pantalla
• Para confirmar acciones importantes

¿Cómo funciona?
• Activa el Text-to-Speech (TTS)
• Lee automáticamente cada pantalla
• Puede ajustar velocidad, tono y volumen
• Funciona con lectores de pantalla externos

Configuración:
• Velocidad: 0.5x a 2.0x (recomendado 0.8x)
• Tono: 0.5 a 2.0 (recomendado 1.0)
• Volumen: 0.0 a 1.0 (recomendado 0.9)
• Idioma: Se adapta al idioma seleccionado
''',
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return _buildSection(
      title: '⌨️ INTRODUCIR',
      icon: Icons.keyboard,
      children: [
        _buildAccessibilityCard(
          title: 'Entrada por Voz',
          description: 'Permite introducir texto hablando',
          isEnabled: _voiceInput,
          onToggle: (value) => setState(() => _voiceInput = value),
          infoText: '''
🎤 ENTRADA POR VOZ

¿Qué hace?
• Permite introducir texto hablando
• Convierte su voz en texto automáticamente
• Funciona con comandos de voz
• Reduce la necesidad de usar el teclado

¿Cuándo usarlo?
• Si tiene dificultades para escribir
• Para introducir matrículas rápidamente
• Si prefiere hablar en lugar de tocar
• Para personas con movilidad reducida

¿Cómo funciona?
• Presiona el botón del micrófono
• Habla claramente la matrícula
• El sistema reconoce y convierte a texto
• Confirma antes de continuar

Comandos disponibles:
• "Matrícula 1234 ABC"
• "Zona azul"
• "Treinta minutos"
• "Pagar con QR"
''',
        ),
        const SizedBox(height: 12),
        _buildAccessibilityCard(
          title: 'Teclado Grande',
          description: 'Teclado virtual con botones más grandes',
          isEnabled: _largeKeyboard,
          onToggle: (value) => setState(() => _largeKeyboard = value),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return _buildSection(
      title: '⏰ TIEMPO',
      icon: Icons.timer,
      children: [
        _buildAccessibilityCard(
          title: 'Ampliar Tiempo',
          description: 'Extiende los tiempos de respuesta',
          isEnabled: false, // Placeholder
          onToggle: (value) {}, // Placeholder
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return _buildSection(
      title: '🌍 IDIOMA',
      icon: Icons.language,
      children: [
        _buildLanguageSelector(),
      ],
    );
  }

  Widget _buildAISection() {
    return _buildSection(
      title: '🤖 IA ADAPTATIVA',
      icon: Icons.psychology,
      children: [
        _buildAccessibilityCard(
          title: 'IA Adaptativa',
          description: 'Personaliza la experiencia según su uso',
          isEnabled: _aiAdaptive,
          onToggle: (value) => setState(() => _aiAdaptive = value),
          infoText: '''
🤖 IA ADAPTATIVA

¿Qué hace?
• Aprende de cómo usa la aplicación
• Sugiere opciones basadas en su historial
• Adapta la interfaz a sus preferencias
• Hace la experiencia más personal

¿Cuándo usarlo?
• Para obtener recomendaciones inteligentes
• Si quiere una experiencia personalizada
• Para ahorrar tiempo en transacciones
• Si usa la aplicación frecuentemente

¿Cómo funciona?
• Analiza sus últimas 5 transacciones
• Sugiere la zona que más usa
• Recomienda el método de pago más confiable
• Ajusta la interfaz según sus patrones

Funciones inteligentes:
• Zona más usada (acceso directo)
• Método de pago recomendado
• Duración sugerida según hora
• Configuración de accesibilidad automática
• Predicción de mantenimiento del kiosko
''',
        ),
        const SizedBox(height: 12),
        _buildAccessibilityCard(
          title: 'Modo Simplificado',
          description: 'Interfaz más simple con menos elementos',
          isEnabled: _simplifiedMode,
          onToggle: (value) => setState(() => _simplifiedMode = value),
          infoText: '''
🎯 MODO SIMPLIFICADO

¿Qué hace?
• Muestra solo las funciones esenciales
• Botones más grandes y fáciles de tocar
• Navegación más simple
• Menos opciones para evitar confusión

¿Cuándo usarlo?
• Si es la primera vez que usa la aplicación
• Si prefiere una interfaz más simple
• Para personas mayores
• Si tiene dificultades cognitivas

¿Cómo funciona?
• Oculta funciones avanzadas
• Muestra solo "Pagar" y "Anular denuncia"
• Botones de 80dp (más grandes)
• Animaciones reducidas
• Texto más grande y claro
''',
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24, color: Colors.purple.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildAccessibilityCard({
    required String title,
    required String description,
    required bool isEnabled,
    required ValueChanged<bool> onToggle,
    String? infoText,
    bool hasSettings = false,
    VoidCallback? onSettings,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasSettings)
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: onSettings,
                  ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _showInfoDialog(title, infoText ?? ''),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: onToggle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required String description,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String Function(double) formatValue,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatValue(value),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
              activeColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final languages = [
      {'code': 'es', 'name': 'Español'},
      {'code': 'en', 'name': 'English'},
      {'code': 'de', 'name': 'Deutsch'},
      {'code': 'fr', 'name': 'Français'},
      {'code': 'it', 'name': 'Italiano'},
      {'code': 'ca-ES', 'name': 'Català'},
      {'code': 'gl-ES', 'name': 'Galego'},
      {'code': 'eu-ES', 'name': 'Euskera'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Idioma de la Aplicación',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: languages.map((lang) {
                return ChoiceChip(
                  label: Text(lang['name']!),
                  selected: lang['code'] == 'es', // Default to Spanish
                  onSelected: (selected) {
                    if (selected) {
                      // TODO: Implement language change
                      print('Selected language: ${lang['code']}');
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _resetToDefaults,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              minimumSize: const Size(0, 50),
            ),
            child: const Text(
              'Restaurar Predeterminados',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              minimumSize: const Size(0, 50),
            ),
            child: const Text(
              'Aplicar Configuración',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(String title, String infoText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(infoText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showTTSSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración de Voz'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSliderSetting(
              'Velocidad',
              _ttsSpeed,
              0.5,
              2.0,
              15,
              (value) => setState(() => _ttsSpeed = value),
              (value) => '${(value * 10).round() / 10}x',
            ),
            _buildSliderSetting(
              'Tono',
              _ttsPitch,
              0.5,
              2.0,
              15,
              (value) => setState(() => _ttsPitch = value),
              (value) => '${(value * 10).round() / 10}',
            ),
            _buildSliderSetting(
              'Volumen',
              _ttsVolume,
              0.0,
              1.0,
              10,
              (value) => setState(() => _ttsVolume = value),
              (value) => '${(value * 100).round()}%',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    double value,
    double min,
    double max,
    int divisions,
    ValueChanged<double> onChanged,
    String Function(double) formatValue,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(formatValue(value)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _darkMode = false;
      _highContrast = false;
      _textSize = 100.0;
      _ttsEnabled = false;
      _ttsSpeed = 0.8;
      _ttsPitch = 1.0;
      _ttsVolume = 0.9;
      _voiceInput = false;
      _largeKeyboard = false;
      _simplifiedMode = false;
      _aiAdaptive = false;
    });
  }

  void _saveSettings() {
    // TODO: Guardar configuración en Supabase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración guardada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
