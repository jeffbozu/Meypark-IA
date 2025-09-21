import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'core/env.dart';
import 'core/supabase/supabase_client.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar window manager para Linux
  if (Env.isLinux) {
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow();

    // Configurar ventana para kiosko
    await windowManager.setTitle('MEYPARK IA - Kiosko');
    await windowManager.setSize(const Size(1024, 1366)); // 10" vertical
    await windowManager.setResizable(false);
    await windowManager.setFullScreen(true);
    await windowManager.setSkipTaskbar(true);
    await windowManager.setAlwaysOnTop(true);

    // Mostrar ventana
    await windowManager.show();
    await windowManager.focus();
  }

  // Inicializar Supabase
  await SupabaseService.initialize();

  runApp(
    const ProviderScope(
      child: MeyparkKioskApp(),
    ),
  );
}

class MeyparkKioskApp extends ConsumerWidget {
  const MeyparkKioskApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'MEYPARK IA - Kiosko',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: AppRouter.router,
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
        Locale('de', 'DE'),
        Locale('fr', 'FR'),
        Locale('it', 'IT'),
        Locale('ca', 'ES'),
        Locale('gl', 'ES'),
        Locale('eu', 'ES'),
      ],
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE62144),
        brightness: Brightness.light,
      ),
      // fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 2,
        backgroundColor: Color(0xFFE62144),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
