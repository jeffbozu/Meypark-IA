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
      body: uiOverrides.when(
        data: (uiOverridesData) {
          return aiSettings.when(
            data: (aiSettingsData) {
              return Column(
                children: [
                  // Mensaje de bienvenida dinámico
                  if (_shouldShowWelcomeMessage(uiOverridesData))
                    _buildWelcomeMessage(uiOverridesData),

                  // Contenido principal
                  Expanded(
                    child: _buildMainContent(
                        context, ref, uiOverridesData, aiSettingsData),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildWelcomeMessage(Map<String, dynamic>? uiOverrides) {
    if (uiOverrides == null) return const SizedBox.shrink();

    final textOverrides =
        uiOverrides['text_overrides_json'] as Map<String, dynamic>?;
    final welcomeMessage = textOverrides?['welcome_message'] as String?;

    if (welcomeMessage == null || welcomeMessage.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        welcomeMessage,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic>? uiOverrides,
    Map<String, dynamic>? aiSettings,
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

  bool _shouldShowWelcomeMessage(Map<String, dynamic>? uiOverrides) {
    if (uiOverrides == null) return false;

    final visibilityJson =
        uiOverrides['visibility_json'] as Map<String, dynamic>?;
    return visibilityJson?['show_welcome_message'] as bool? ?? true;
  }

  bool _shouldShowMostUsedZone(Map<String, dynamic>? aiSettings) {
    if (aiSettings == null) return false;

    final adaptiveEnabled = aiSettings['ia_adaptive_enabled'] as bool? ?? false;
    final payRecoLast5 = aiSettings['ia_pay_reco_last5'] as bool? ?? false;

    return adaptiveEnabled && payRecoLast5;
  }

  Widget _buildMostUsedZoneCard(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic>? aiSettings,
  ) {
    final aiRecommendations = ref.watch(aiRecommendationsProvider);

    return aiRecommendations.when(
      data: (recommendations) {
        final mostUsedZoneId = recommendations?['most_used_zone_id'] as String?;
        if (mostUsedZoneId == null) return const SizedBox.shrink();

        final zones = ref.watch(zonesProvider);
        return zones.when(
          data: (zonesList) {
            final mostUsedZone = zonesList.firstWhere(
              (zone) => zone['id'] == mostUsedZoneId,
              orElse: () => <String, dynamic>{},
            );

            if (mostUsedZone.isEmpty) return const SizedBox.shrink();

            return _buildZoneCard(context, mostUsedZone, isRecommended: true);
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }

  Widget _buildZoneCard(
    BuildContext context,
    Map<String, dynamic> zone, {
    bool isRecommended = false,
  }) {
    final zoneName = zone['name'] as String? ?? 'Zona Desconocida';
    final zoneColorHex = zone['color'] as String? ?? '#000000';
    final zoneColor = Color(int.parse(zoneColorHex.replaceAll('#', '0xFF')));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isRecommended
              ? BorderSide(color: Colors.green.shade700, width: 3)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: () {
            context.goNamed('pay-plate', extra: {'zone': zone});
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [zoneColor, zoneColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                if (isRecommended)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'RECOMENDADO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  zoneName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Toca para pagar',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowPayButton(Map<String, dynamic>? uiOverrides) {
    if (uiOverrides == null) return true;

    final visibilityJson =
        uiOverrides['visibility_json'] as Map<String, dynamic>?;
    return visibilityJson?['show_pay_button'] as bool? ?? true;
  }

  Widget _buildPayButton(
      BuildContext context, Map<String, dynamic>? uiOverrides) {
    final buttonColor = _getPayButtonColor(uiOverrides);
    final buttonText = _getPayButtonText(uiOverrides);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          context.goNamed('pay-zone');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 12,
          shadowColor: buttonColor.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.payment, size: 40),
            const SizedBox(width: 16),
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPayButtonColor(Map<String, dynamic>? uiOverrides) {
    if (uiOverrides == null) return Colors.green;

    final colorsJson = uiOverrides['colors_json'] as Map<String, dynamic>?;
    final colorHex = colorsJson?['button_pay_bg'] as String?;
    if (colorHex != null) {
      return Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    }
    return Colors.green;
  }

  String _getPayButtonText(Map<String, dynamic>? uiOverrides) {
    if (uiOverrides == null) return 'PAGAR ESTACIONAMIENTO';

    final textOverrides =
        uiOverrides['text_overrides_json'] as Map<String, dynamic>?;
    return textOverrides?['pay_button_text'] as String? ??
        'PAGAR ESTACIONAMIENTO';
  }

  bool _shouldShowCancelButton(Map<String, dynamic>? uiOverrides) {
    if (uiOverrides == null) return true;

    final visibilityJson =
        uiOverrides['visibility_json'] as Map<String, dynamic>?;
    return visibilityJson?['show_cancel_button'] as bool? ?? true;
  }

  Widget _buildCancelButton(
      BuildContext context, Map<String, dynamic>? uiOverrides) {
    final buttonColor = _getCancelButtonColor(uiOverrides);
    final buttonText = _getCancelButtonText(uiOverrides);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          context.goNamed('cancel-fine');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 12,
          shadowColor: buttonColor.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cancel_outlined, size: 40),
            const SizedBox(width: 16),
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCancelButtonColor(Map<String, dynamic>? uiOverrides) {
    if (uiOverrides == null) return Colors.red;

    final colorsJson = uiOverrides['colors_json'] as Map<String, dynamic>?;
    final colorHex = colorsJson?['button_cancel_bg'] as String?;
    if (colorHex != null) {
      return Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    }
    return Colors.red;
  }

  String _getCancelButtonText(Map<String, dynamic>? uiOverrides) {
    if (uiOverrides == null) return 'ANULAR DENUNCIA';

    final textOverrides =
        uiOverrides['text_overrides_json'] as Map<String, dynamic>?;
    return textOverrides?['cancel_button_text'] as String? ?? 'ANULAR DENUNCIA';
  }
}
