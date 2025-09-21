import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/supabase_providers.dart';
import '../../widgets/dynamic_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiOverrides = ref.watch(uiOverridesProvider);
    final aiSettings = ref.watch(aiSettingsProvider);

    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Column(
        children: [
          // Mensaje de bienvenida dinámico
          if (_shouldShowWelcomeMessage(uiOverrides))
            _buildWelcomeMessage(uiOverrides),

          // Contenido principal
          Expanded(
            child: _buildMainContent(context, ref, uiOverrides, aiSettings),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage(AsyncValue<Map<String, dynamic>?> uiOverrides) {
    if (uiOverrides.value == null) return const SizedBox.shrink();

    final textOverrides =
        uiOverrides.value!['text_overrides_json'] as Map<String, dynamic>?;
    final welcomeMessage = textOverrides?['welcome_message'] as String?;

    if (welcomeMessage == null || welcomeMessage.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Text(
        welcomeMessage,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Map<String, dynamic>?> uiOverrides,
    AsyncValue<Map<String, dynamic>?> aiSettings,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Zona más usada (IA) - si está habilitada
          if (_shouldShowMostUsedZone(aiSettings))
            _buildMostUsedZoneCard(context, ref, aiSettings),

          const SizedBox(height: 32),

          // Botón principal de pago
          if (_shouldShowPayButton(uiOverrides))
            _buildPayButton(context, uiOverrides),

          const SizedBox(height: 24),

          // Botón de anular denuncia
          if (_shouldShowCancelButton(uiOverrides))
            _buildCancelButton(context, uiOverrides),
        ],
      ),
    );
  }

  Widget _buildMostUsedZoneCard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Map<String, dynamic>?> aiSettings,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Card(
        color: Colors.amber.shade50,
        child: InkWell(
          onTap: () => _navigateToPayment(context),
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

  Widget _buildPayButton(
    BuildContext context,
    AsyncValue<Map<String, dynamic>?> uiOverrides,
  ) {
    final buttonColor = _getPayButtonColor(uiOverrides);
    final buttonText = _getPayButtonText(uiOverrides);

    return SizedBox(
      width: 280,
      height: 80,
      child: ElevatedButton(
        onPressed: () => _navigateToPayment(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(
    BuildContext context,
    AsyncValue<Map<String, dynamic>?> uiOverrides,
  ) {
    final buttonColor = _getCancelButtonColor(uiOverrides);
    final buttonText = _getCancelButtonText(uiOverrides);

    return SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _navigateToCancelFine(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  bool _shouldShowWelcomeMessage(
      AsyncValue<Map<String, dynamic>?> uiOverrides) {
    if (uiOverrides.value == null) return false;

    final textOverrides =
        uiOverrides.value!['text_overrides_json'] as Map<String, dynamic>?;
    final welcomeMessage = textOverrides?['welcome_message'] as String?;
    return welcomeMessage != null && welcomeMessage.isNotEmpty;
  }

  bool _shouldShowMostUsedZone(AsyncValue<Map<String, dynamic>?> aiSettings) {
    if (aiSettings.value == null) return false;

    return aiSettings.value!['presets_smart'] == true;
  }

  bool _shouldShowPayButton(AsyncValue<Map<String, dynamic>?> uiOverrides) {
    if (uiOverrides.value == null) return true;

    final visibility =
        uiOverrides.value!['visibility_json'] as Map<String, dynamic>?;
    return visibility?['show_pay'] ?? true;
  }

  bool _shouldShowCancelButton(AsyncValue<Map<String, dynamic>?> uiOverrides) {
    if (uiOverrides.value == null) return true;

    final visibility =
        uiOverrides.value!['visibility_json'] as Map<String, dynamic>?;
    return visibility?['show_cancel'] ?? true;
  }

  Color _getPayButtonColor(AsyncValue<Map<String, dynamic>?> uiOverrides) {
    if (uiOverrides.value == null) return const Color(0xFF4CAF50);

    final colors = uiOverrides.value!['colors_json'] as Map<String, dynamic>?;
    final colorHex = colors?['button_pay_bg'] ?? '#4CAF50';
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  Color _getCancelButtonColor(AsyncValue<Map<String, dynamic>?> uiOverrides) {
    if (uiOverrides.value == null) return const Color(0xFFF44336);

    final colors = uiOverrides.value!['colors_json'] as Map<String, dynamic>?;
    final colorHex = colors?['button_cancel_bg'] ?? '#F44336';
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  String _getPayButtonText(AsyncValue<Map<String, dynamic>?> uiOverrides) {
    if (uiOverrides.value == null) return 'PAGAR ESTACIONAMIENTO';

    final textOverrides =
        uiOverrides.value!['text_overrides_json'] as Map<String, dynamic>?;
    return textOverrides?['button_pay_text'] ?? 'PAGAR ESTACIONAMIENTO';
  }

  String _getCancelButtonText(AsyncValue<Map<String, dynamic>?> uiOverrides) {
    if (uiOverrides.value == null) return 'ANULAR DENUNCIA';

    final textOverrides =
        uiOverrides.value!['text_overrides_json'] as Map<String, dynamic>?;
    return textOverrides?['button_cancel_text'] ?? 'ANULAR DENUNCIA';
  }

  void _navigateToPayment(BuildContext context) {
    context.go('/pay');
  }

  void _navigateToCancelFine(BuildContext context) {
    context.go('/cancel-fine');
  }
}
