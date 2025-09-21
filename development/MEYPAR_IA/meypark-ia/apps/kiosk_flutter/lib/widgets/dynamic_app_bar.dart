import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/providers/supabase_providers.dart';

class DynamicAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DynamicAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiOverrides = ref.watch(uiOverridesProvider);
    final deviceConfig = ref.watch(deviceConfigProvider);

    return AppBar(
      backgroundColor: _getAppBarColor(uiOverrides),
      elevation: 2,
      title: Row(
        children: [
          // Logo
          Image.asset(
            'assets/icons/logo.png',
            height: 32,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.local_parking,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),

          // Nombre de empresa
          Text(
            _getCompanyName(uiOverrides),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // Hora y fecha
          if (_shouldShowTime(deviceConfig)) _buildTimeDate(deviceConfig),

          const SizedBox(width: 16),

          // Selector de idioma
          _buildLanguageSelector(),

          const SizedBox(width: 8),

          // Botón de accesibilidad
          IconButton(
            onPressed: () => _showAccessibilityPanel(context),
            icon: const Icon(Icons.accessibility, color: Colors.white),
            tooltip: 'Accesibilidad',
          ),

          // Botón de información
          IconButton(
            onPressed: () => _showInfoDialog(context),
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'Información',
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDate(AsyncValue<Map<String, dynamic>?> deviceConfig) {
    if (deviceConfig.value == null) return const SizedBox.shrink();

    final config = deviceConfig.value!;
    final showTime = config['flags_json']?['show_time'] ?? true;
    final showDate = config['flags_json']?['show_date'] ?? true;
    final timeFormat = config['flags_json']?['time_format'] ?? '24h';
    final dateFormat = config['flags_json']?['date_format'] ?? 'dd/MM/yyyy';

    if (!showTime && !showDate) return const SizedBox.shrink();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showTime)
          Text(
            _formatTime(timeFormat),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (showDate)
          Text(
            _formatDate(dateFormat),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language, color: Colors.white),
      tooltip: 'Idioma',
      onSelected: (language) {
        // TODO: Implementar cambio de idioma
        print('Selected language: $language');
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'es', child: Text('Español')),
        const PopupMenuItem(value: 'en', child: Text('English')),
        const PopupMenuItem(value: 'de', child: Text('Deutsch')),
        const PopupMenuItem(value: 'fr', child: Text('Français')),
        const PopupMenuItem(value: 'it', child: Text('Italiano')),
        const PopupMenuItem(value: 'ca-ES', child: Text('Català')),
        const PopupMenuItem(value: 'gl-ES', child: Text('Galego')),
        const PopupMenuItem(value: 'eu-ES', child: Text('Euskera')),
      ],
    );
  }

  String _getCompanyName(AsyncValue<Map<String, dynamic>?> uiOverrides) {
    if (uiOverrides.value == null) return 'MEYPARK';

    final textOverrides =
        uiOverrides.value!['text_overrides_json'] as Map<String, dynamic>?;
    return textOverrides?['appbar_company_name'] ?? 'MEYPARK';
  }

  Color _getAppBarColor(AsyncValue<Map<String, dynamic>?> uiOverrides) {
    if (uiOverrides.value == null) return const Color(0xFFE62144);

    final colors = uiOverrides.value!['colors_json'] as Map<String, dynamic>?;
    final colorHex = colors?['appbar_bg'] ?? '#E62144';
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  bool _shouldShowTime(AsyncValue<Map<String, dynamic>?> deviceConfig) {
    if (deviceConfig.value == null) return true;

    final config = deviceConfig.value!;
    final showTime = config['flags_json']?['show_time'] ?? true;
    final showDate = config['flags_json']?['show_date'] ?? true;
    return showTime || showDate;
  }

  String _formatTime(String format) {
    final now = DateTime.now();
    if (format == '24h') {
      return DateFormat('HH:mm').format(now);
    } else {
      return DateFormat('h:mm a').format(now);
    }
  }

  String _formatDate(String format) {
    final now = DateTime.now();
    switch (format) {
      case 'dd/MM/yyyy':
        return DateFormat('dd/MM/yyyy').format(now);
      case 'MM/dd/yyyy':
        return DateFormat('MM/dd/yyyy').format(now);
      case 'yyyy-MM-dd':
        return DateFormat('yyyy-MM-dd').format(now);
      default:
        return DateFormat('dd/MM/yyyy').format(now);
    }
  }

  void _showAccessibilityPanel(BuildContext context) {
    // TODO: Navegar a pantalla de accesibilidad
    print('Show accessibility panel');
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información del Kiosko'),
        content: const Text(
          'MEYPARK IA - Kiosko Inteligente\n\n'
          'Versión: 1.0.0\n'
          'Plataforma: Linux/Web\n'
          'Conectado a Supabase\n\n'
          'Para soporte técnico, contacte con el administrador.',
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
