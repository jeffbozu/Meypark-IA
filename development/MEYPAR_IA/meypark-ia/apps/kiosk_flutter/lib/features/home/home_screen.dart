import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/dynamic_app_bar.dart';
import '../../widgets/accessibility_controls.dart';
import '../../widgets/adaptive_ai_button.dart';
import '../../core/providers/supabase_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inicializar el sistema
    final systemInit = ref.watch(systemInitProvider);
    final uiConfig = ref.watch(uiConfigProvider);
    
    return systemInit.when(
      loading: () => _buildLoadingScreen(),
      error: (error, stack) => _buildErrorScreen(error),
      data: (initialized) => uiConfig.when(
        loading: () => _buildLoadingScreen(),
        error: (error, stack) => _buildMainScreen(context, ref, null),
        data: (config) => _buildMainScreen(context, ref, config),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE62144), Color(0xFF8B1538)],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Iniciando sistema...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(Object error) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE62144), Color(0xFF8B1538)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.white, size: 64),
              const SizedBox(height: 20),
              const Text(
                'Error de sistema',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Trabajando en modo offline',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainScreen(BuildContext context, WidgetRef ref, Map<String, dynamic>? config) {
    return Scaffold(
      appBar: const DynamicAppBar(),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(int.parse((config?['primary_color'] ?? '#E62144').replaceFirst('#', '0xFF'))),
              Color(int.parse((config?['secondary_color'] ?? '#8B1538').replaceFirst('#', '0xFF'))),
            ],
          ),
        ),
        child: Column(
          children: [
            // Controles de accesibilidad e idiomas
            const AccessibilityControls(),

            const SizedBox(height: 20),

            // Mensaje de bienvenida
            _buildWelcomeMessage(context, config),

            const SizedBox(height: 40),

            // Botón de IA adaptativa (recomendación inteligente)
            const AdaptiveAIButton(),

            // Botón principal de pagar
            _buildPayButton(context),

            const SizedBox(height: 20),

            // Botón de anular denuncia
            _buildCancelButton(context),

            const Spacer(),

            // Botones de configuración
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón de idiomas
                _buildLanguageButton(context),

                // Botón de accesibilidad
                _buildAccessibilityButton(context),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(BuildContext context, Map<String, dynamic>? config) {
    final companyName = config?['company_name'] ?? 'MEYPARK';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_parking,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            'Bienvenido a $companyName',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Sistema Inteligente de Parquímetros',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: () => context.goNamed('pay-zone'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFE62144),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, size: 32),
            const SizedBox(width: 16),
            Text(
              'PAGAR ESTACIONAMIENTO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: () => context.goNamed('cancel-fine'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, size: 24),
            const SizedBox(width: 12),
            Text(
              'ANULAR DENUNCIA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Implementar selector de idiomas
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selector de idiomas - Próximamente')),
          );
        },
        icon: Icon(Icons.language, size: 20),
        label: Text('IDIOMAS'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildAccessibilityButton(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () => context.goNamed('accessibility'),
        icon: Icon(Icons.accessibility, size: 20),
        label: Text('ACCESO'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
