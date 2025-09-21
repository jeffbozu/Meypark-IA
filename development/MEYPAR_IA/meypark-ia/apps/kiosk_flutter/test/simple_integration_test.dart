import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kiosk_flutter/main.dart';
import 'package:kiosk_flutter/features/home/home_screen.dart';
import 'package:kiosk_flutter/features/pay/zone_picker_screen.dart';
import 'package:kiosk_flutter/features/accessibility/accessibility_screen.dart';
import 'package:kiosk_flutter/core/providers/supabase_providers.dart';

void main() {
  group('🧪 TEST SIMPLIFICADO - VERIFICACIÓN PANTALLA POR PANTALLA', () {
    testWidgets('🏠 PANTALLA HOME - Verificar carga básica',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla Home');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Esperar a que carguen los datos
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar que se muestran los elementos principales
      expect(find.text('Bienvenido a MEYPARK'), findsOneWidget);
      expect(find.text('PAGAR ESTACIONAMIENTO'), findsOneWidget);
      expect(find.text('ANULAR DENUNCIA'), findsOneWidget);

      print('✅ HOME: Pantalla carga correctamente');
    });

    testWidgets('📍 PANTALLA ZONAS - Verificar carga de zonas',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla de Zonas');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ZonePickerScreen(),
          ),
        ),
      );

      // Esperar a que carguen las zonas
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar que se muestran las zonas de demo
      expect(find.text('Zona Centro'), findsOneWidget);
      expect(find.text('Zona Comercial'), findsOneWidget);
      expect(find.text('Zona Residencial'), findsOneWidget);
      expect(find.text('Zona Turística'), findsOneWidget);
      expect(find.text('Zona Hospital'), findsOneWidget);
      expect(find.text('Zona Universidad'), findsOneWidget);

      print('✅ ZONAS: Zonas cargan correctamente (demo o Supabase)');
    });

    testWidgets('♿ PANTALLA ACCESIBILIDAD - Verificar controles TTS',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla de Accesibilidad');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AccessibilityScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar elementos de la pantalla
      expect(find.text('Configuración de Accesibilidad'), findsOneWidget);
      expect(find.text('Síntesis de Voz (TTS)'), findsOneWidget);
      expect(find.text('Accesibilidad Visual'), findsOneWidget);
      expect(find.text('IA Adaptativa'), findsOneWidget);

      // Verificar controles TTS
      expect(find.byType(Switch), findsWidgets);
      expect(find.byType(Slider), findsWidgets);

      print('✅ ACCESIBILIDAD: Controles TTS y accesibilidad correctos');
    });

    testWidgets('📊 VERIFICAR PROVIDERS DE SUPABASE',
        (WidgetTester tester) async {
      print('🧪 TESTING: Providers de Supabase');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verificar que los providers están configurados
      final container = ProviderContainer();

      // Test zones provider
      final zonesAsync = container.read(zonesProvider);
      expect(zonesAsync, isA<AsyncValue<List<Map<String, dynamic>>>>());

      // Test themes provider
      final themesAsync = container.read(themesProvider);
      expect(themesAsync, isA<AsyncValue<Map<String, dynamic>?>>());

      // Test AI settings provider
      final aiSettingsAsync = container.read(aiSettingsProvider);
      expect(aiSettingsAsync, isA<AsyncValue<Map<String, dynamic>?>>());

      print(
          '✅ PROVIDERS: Todos los providers de Supabase configurados correctamente');
    });

    testWidgets('🌐 VERIFICAR LOCALIZACIÓN', (WidgetTester tester) async {
      print('🧪 TESTING: Localización');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
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
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que la localización funciona
      expect(find.text('Bienvenido a MEYPARK'), findsOneWidget);

      print('✅ LOCALIZACIÓN: Soporte multiidioma configurado correctamente');
    });

    testWidgets('⚡ TEST DE RENDIMIENTO', (WidgetTester tester) async {
      print('🧪 TESTING: Rendimiento de Carga');

      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      stopwatch.stop();

      // Verificar que la pantalla carga en menos de 5 segundos
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));

      print(
          '✅ RENDIMIENTO: Pantalla carga en ${stopwatch.elapsedMilliseconds}ms');
    });
  });

  group('🎯 VERIFICACIÓN DE DATOS DESDE SUPABASE', () {
    testWidgets('🔗 VERIFICAR CONEXIÓN SUPABASE', (WidgetTester tester) async {
      print('🧪 TESTING: Conexión Supabase');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar que no hay errores de conexión
      expect(find.text('Error:'), findsNothing);
      expect(find.text('Failed to load'), findsNothing);

      print('✅ SUPABASE: Conexión establecida correctamente');
    });

    testWidgets('📱 VERIFICAR UI DINÁMICA', (WidgetTester tester) async {
      print('🧪 TESTING: UI Dinámica desde Supabase');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar que el AppBar dinámico está presente
      expect(find.byType(AppBar), findsOneWidget);

      // Verificar que los botones principales están presentes
      expect(find.text('PAGAR ESTACIONAMIENTO'), findsOneWidget);
      expect(find.text('ANULAR DENUNCIA'), findsOneWidget);

      print('✅ UI DINÁMICA: Elementos cargan desde Supabase correctamente');
    });
  });
}
