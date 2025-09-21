import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kiosk_flutter/main.dart';
import 'package:kiosk_flutter/features/home/home_screen.dart';
import 'package:kiosk_flutter/features/pay/zone_picker_screen.dart';
import 'package:kiosk_flutter/features/accessibility/accessibility_screen.dart';

void main() {
  group('MEYPARK Kiosko Tests', () {
    testWidgets('Home screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verificar que se muestran los elementos principales
      expect(find.text('Bienvenido a MEYPARK'), findsOneWidget);
      expect(find.text('PAGAR ESTACIONAMIENTO'), findsOneWidget);
      expect(find.text('ANULAR DENUNCIA'), findsOneWidget);
    });

    testWidgets('Zone picker screen displays zones',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ZonePickerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que se muestran las zonas de demo
      expect(find.text('Zona Centro'), findsOneWidget);
      expect(find.text('Zona Comercial'), findsOneWidget);
      expect(find.text('Zona Residencial'), findsOneWidget);
    });

    testWidgets('Accessibility screen displays controls',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AccessibilityScreen(),
          ),
        ),
      );

      // Verificar que se muestran los controles de accesibilidad
      expect(find.text('Configuración de Accesibilidad'), findsOneWidget);
      expect(find.text('Síntesis de Voz (TTS)'), findsOneWidget);
      expect(find.text('Accesibilidad Visual'), findsOneWidget);
      expect(find.text('IA Adaptativa'), findsOneWidget);
    });

    testWidgets('TTS controls work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AccessibilityScreen(),
          ),
        ),
      );

      // Verificar que los controles de TTS están presentes
      expect(find.byType(Switch), findsWidgets);
      expect(find.byType(Slider), findsWidgets);
      expect(find.text('Probar Síntesis de Voz'), findsOneWidget);
    });

    testWidgets('Navigation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const HomeScreen(),
                ),
                GoRoute(
                  path: '/pay/zone',
                  builder: (context, state) => const ZonePickerScreen(),
                ),
                GoRoute(
                  path: '/accessibility',
                  builder: (context, state) => const AccessibilityScreen(),
                ),
              ],
            ),
          ),
        ),
      );

      // Verificar navegación inicial
      expect(find.text('Bienvenido a MEYPARK'), findsOneWidget);

      // Navegar a zona picker
      await tester.tap(find.text('PAGAR ESTACIONAMIENTO'));
      await tester.pumpAndSettle();

      // Verificar que estamos en la pantalla de zonas
      expect(
          find.text('Selecciona tu Zona de Estacionamiento'), findsOneWidget);
    });
  });

  group('UI/UX Tests for 10" Screen', () {
    testWidgets('Buttons are large enough for touch',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verificar que los botones tienen el tamaño mínimo requerido
      final payButton = find.text('PAGAR ESTACIONAMIENTO');
      expect(payButton, findsOneWidget);

      final buttonWidget = tester.widget<ElevatedButton>(payButton);
      expect(buttonWidget.style?.minimumSize?.resolve({})?.height,
          greaterThanOrEqualTo(80.0));
    });

    testWidgets('Text is readable on 10" screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verificar que el texto tiene el tamaño adecuado
      final welcomeText = find.text('Bienvenido a MEYPARK');
      expect(welcomeText, findsOneWidget);

      final textWidget = tester.widget<Text>(welcomeText);
      expect(textWidget.style?.fontSize, greaterThanOrEqualTo(28.0));
    });
  });

  group('Supabase Integration Tests', () {
    testWidgets('Zones load from Supabase with fallback',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ZonePickerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que se cargan las zonas (demo o de Supabase)
      expect(find.text('Zona Centro'), findsOneWidget);
      expect(find.text('Zona Comercial'), findsOneWidget);
      expect(find.text('Zona Residencial'), findsOneWidget);
      expect(find.text('Zona Turística'), findsOneWidget);
      expect(find.text('Zona Hospital'), findsOneWidget);
      expect(find.text('Zona Universidad'), findsOneWidget);
    });
  });
}
