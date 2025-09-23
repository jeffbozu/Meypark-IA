import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/env.dart';
import 'core/supabase/supabase_client.dart';
import 'core/router/app_router.dart';
import 'core/services/window_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar gestor de ventanas para Linux
  if (Env.isLinux) {
    await WindowService.initialize();
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
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
      // Tema optimizado para pantalla de 10" vertical
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 4,
        backgroundColor: Color(0xFFE62144),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          minimumSize: const Size(200, 80), // Botones más grandes
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        labelStyle: const TextStyle(fontSize: 18),
        hintStyle: const TextStyle(fontSize: 18),
      ),
      // Iconos más grandes
      iconTheme: const IconThemeData(
        size: 32,
        color: Color(0xFFE62144),
      ),
      // Botones de texto más grandes
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      // Botones outlined más grandes
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(200, 60),
        ),
      ),
    );
  }
}
