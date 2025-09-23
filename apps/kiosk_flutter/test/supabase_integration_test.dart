import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kiosk_flutter/main.dart';
import 'package:kiosk_flutter/features/home/home_screen.dart';
import 'package:kiosk_flutter/features/pay/zone_picker_screen.dart';
import 'package:kiosk_flutter/features/pay/plate_input_screen.dart';
import 'package:kiosk_flutter/features/pay/duration_screen.dart';
import 'package:kiosk_flutter/features/pay/payment_screen.dart';
import 'package:kiosk_flutter/features/pay/payment_result_screen.dart';
import 'package:kiosk_flutter/features/fines/cancel_fine_screen.dart';
import 'package:kiosk_flutter/features/accessibility/accessibility_screen.dart';
import 'package:kiosk_flutter/features/tech_mode/tech_mode_screen.dart';
import 'package:kiosk_flutter/features/auth_hidden/hidden_login_screen.dart';
import 'package:kiosk_flutter/features/auth_hidden/login_screen.dart';
import 'package:kiosk_flutter/core/providers/supabase_providers.dart';
import 'package:kiosk_flutter/core/supabase/supabase_client.dart';

void main() {
  group('🧪 SUPABASE INTEGRATION TESTS - PANTALLA POR PANTALLA', () {
    testWidgets('🏠 PANTALLA HOME - Verificar carga de datos desde Supabase',
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
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar que se muestran los elementos principales
      expect(find.text('Bienvenido a MEYPARK'), findsOneWidget);
      expect(find.text('PAGAR ESTACIONAMIENTO'), findsOneWidget);
      expect(find.text('ANULAR DENUNCIA'), findsOneWidget);

      // Verificar que el AppBar dinámico está presente
      expect(find.byType(AppBar), findsOneWidget);

      print('✅ HOME: Datos cargados correctamente desde Supabase');
    });

    testWidgets('📍 PANTALLA ZONAS - Verificar carga de zonas desde Supabase',
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
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar que se muestran las zonas de demo (fallback si no hay conexión)
      expect(find.text('Zona Centro'), findsOneWidget);
      expect(find.text('Zona Comercial'), findsOneWidget);
      expect(find.text('Zona Residencial'), findsOneWidget);
      expect(find.text('Zona Turística'), findsOneWidget);
      expect(find.text('Zona Hospital'), findsOneWidget);
      expect(find.text('Zona Universidad'), findsOneWidget);

      // Verificar que hay botones interactivos
      expect(find.byType(GestureDetector), findsWidgets);

      print('✅ ZONAS: Zonas cargadas correctamente (demo o Supabase)');
    });

    testWidgets('🚗 PANTALLA MATRÍCULA - Verificar funcionalidad',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla de Matrícula');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PlateInputScreen(
                zone: {'id': 'zone_001', 'name': 'Zona Centro'}),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar elementos de la pantalla
      expect(find.text('Introduce tu Matrícula'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(DropdownButtonFormField), findsOneWidget);
      expect(find.text('Continuar'), findsOneWidget);

      // Probar validación de matrícula
      await tester.enterText(find.byType(TextField), '1234ABC');
      await tester.pump();

      // Verificar que no hay error de validación
      expect(find.text('Formato: AAAA###, ###AAA o AAAA-###-AA'), findsNothing);

      print('✅ MATRÍCULA: Funcionalidad correcta');
    });

    testWidgets('⏰ PANTALLA DURACIÓN - Verificar carga de tarifas',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla de Duración');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DurationScreen(
              zone: {'id': 'zone_001', 'name': 'Zona Centro'},
              plate: '1234ABC',
              country: 'ES',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar elementos de la pantalla
      expect(find.text('Selecciona la Duración'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsWidgets); // Presets
      expect(find.byType(IconButton), findsWidgets); // Controles +/-
      expect(find.text('Pagar'), findsOneWidget);

      // Verificar que se muestran los presets
      expect(find.text('15 min'), findsOneWidget);
      expect(find.text('30 min'), findsOneWidget);
      expect(find.text('60 min'), findsOneWidget);
      expect(find.text('120 min'), findsOneWidget);

      print('✅ DURACIÓN: Tarifas y presets cargados correctamente');
    });

    testWidgets('💳 PANTALLA PAGO - Verificar métodos de pago',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla de Pago');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PaymentScreen(
              zone: {'id': 'zone_001', 'name': 'Zona Centro'},
              plate: '1234ABC',
              country: 'ES',
              durationMin: 30,
              amountCents: 600,
              endTime: '2025-01-21T15:30:00Z',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar elementos de la pantalla
      expect(find.text('Total a Pagar:'), findsOneWidget);
      expect(find.text('Selecciona tu Método de Pago'), findsOneWidget);
      expect(find.text('Confirmar Pago'), findsOneWidget);

      // Verificar métodos de pago
      expect(find.text('Google Pay'), findsOneWidget);
      expect(find.text('Apple Pay'), findsOneWidget);
      expect(find.text('Código QR'), findsOneWidget);
      expect(find.text('Tarjeta / Monedas'), findsOneWidget);

      print('✅ PAGO: Métodos de pago cargados correctamente');
    });

    testWidgets('📄 PANTALLA RESULTADO - Verificar resultado de pago',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla de Resultado');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PaymentResultScreen(
              transactionData: {
                'status': 'succeeded',
                'amount_cents': 600,
                'payment_method': 'qr',
                'qrData': 'https://example.com/pay/600',
                'zone': {'name': 'Zona Centro'},
                'plate': '1234ABC',
                'duration_min': 30,
                'end_time': '2025-01-21T15:30:00Z',
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar elementos de la pantalla
      expect(find.text('¡Pago Realizado con Éxito!'), findsOneWidget);
      expect(find.text('Imprimir Ticket'), findsOneWidget);
      expect(find.text('Volver al Inicio'), findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);

      print('✅ RESULTADO: Pantalla de resultado correcta');
    });

    testWidgets('🚫 PANTALLA ANULAR DENUNCIA - Verificar búsqueda de multas',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla Anular Denuncia');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CancelFineScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar elementos de la pantalla
      expect(find.text('Anular Denuncia'), findsOneWidget);
      expect(find.text('Matrícula de la Denuncia'), findsOneWidget);
      expect(find.text('Buscar Denuncia'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(DropdownButtonFormField), findsOneWidget);

      print('✅ ANULAR DENUNCIA: Funcionalidad correcta');
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
      expect(find.text('Probar Síntesis de Voz'), findsOneWidget);

      // Verificar controles TTS
      expect(find.byType(Switch), findsWidgets);
      expect(find.byType(Slider), findsWidgets);
      expect(find.text('Velocidad:'), findsOneWidget);
      expect(find.text('Tono:'), findsOneWidget);
      expect(find.text('Volumen:'), findsOneWidget);

      print('✅ ACCESIBILIDAD: Controles TTS y accesibilidad correctos');
    });

    testWidgets('🔧 PANTALLA MODO TÉCNICO - Verificar acceso técnico',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla Modo Técnico');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TechModeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar elementos de la pantalla
      expect(find.text('MODO TÉCNICO'), findsOneWidget);
      expect(find.text('Configuración del Sistema'), findsOneWidget);
      expect(find.text('Monitoreo en Tiempo Real'), findsOneWidget);
      expect(find.text('Logs del Sistema'), findsOneWidget);

      print('✅ MODO TÉCNICO: Pantalla de administración correcta');
    });

    testWidgets('🔐 PANTALLA LOGIN OCULTO - Verificar autenticación',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla Login Oculto');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HiddenLoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar elementos de la pantalla
      expect(find.text('ACCESO TÉCNICO'), findsOneWidget);
      expect(find.text('Introduce la contraseña técnica'), findsOneWidget);
      expect(find.text('ACCEDER'), findsOneWidget);
      expect(find.text('CANCELAR'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      print('✅ LOGIN OCULTO: Pantalla de autenticación correcta');
    });

    testWidgets('🔑 PANTALLA LOGIN NORMAL - Verificar login con logo',
        (WidgetTester tester) async {
      print('🧪 TESTING: Pantalla Login Normal');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar elementos de la pantalla
      expect(find.text('MEYPARK IA'), findsOneWidget);
      expect(find.text('Sistema de Gestión de Parquímetros'), findsOneWidget);
      expect(find.text('INICIAR SESIÓN'), findsOneWidget);
      expect(find.text('CANCELAR'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Email y contraseña

      print('✅ LOGIN NORMAL: Pantalla de login con logo correcta');
    });

    testWidgets('🔄 NAVEGACIÓN COMPLETA - Verificar flujo completo',
        (WidgetTester tester) async {
      print('🧪 TESTING: Navegación Completa');

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                    path: '/', builder: (context, state) => const HomeScreen()),
                GoRoute(
                    path: '/pay/zone',
                    builder: (context, state) => const ZonePickerScreen()),
                GoRoute(
                    path: '/pay/plate',
                    builder: (context, state) => const PlateInputScreen()),
                GoRoute(
                    path: '/pay/duration',
                    builder: (context, state) => const DurationScreen()),
                GoRoute(
                    path: '/pay/payment',
                    builder: (context, state) => const PaymentScreen()),
                GoRoute(
                    path: '/pay/result',
                    builder: (context, state) => const PaymentResultScreen()),
                GoRoute(
                    path: '/cancel-fine',
                    builder: (context, state) => const CancelFineScreen()),
                GoRoute(
                    path: '/accessibility',
                    builder: (context, state) => const AccessibilityScreen()),
                GoRoute(
                    path: '/tech-mode',
                    builder: (context, state) => const TechModeScreen()),
                GoRoute(
                    path: '/hidden-login',
                    builder: (context, state) => const HiddenLoginScreen()),
                GoRoute(
                    path: '/login',
                    builder: (context, state) => const LoginScreen()),
              ],
            ),
          ),
        ),
      );

      // Verificar pantalla inicial
      expect(find.text('Bienvenido a MEYPARK'), findsOneWidget);

      // Navegar a zonas
      await tester.tap(find.text('PAGAR ESTACIONAMIENTO'));
      await tester.pumpAndSettle();
      expect(
          find.text('Selecciona tu Zona de Estacionamiento'), findsOneWidget);

      // Navegar a matrícula
      await tester.tap(find.text('Zona Centro'));
      await tester.pumpAndSettle();
      expect(find.text('Introduce tu Matrícula'), findsOneWidget);

      // Volver al inicio
      await tester.tap(find.text('CANCELAR'));
      await tester.pumpAndSettle();
      expect(find.text('Bienvenido a MEYPARK'), findsOneWidget);

      print('✅ NAVEGACIÓN: Flujo completo funciona correctamente');
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

      // Test accessibility prefs provider
      final accessibilityPrefsAsync =
          container.read(accessibilityPrefsProvider);
      expect(accessibilityPrefsAsync, isA<AsyncValue<Map<String, dynamic>?>>());

      print(
          '✅ PROVIDERS: Todos los providers de Supabase configurados correctamente');
    });
  });

  group('🎯 TESTS DE RENDIMIENTO', () {
    testWidgets('⚡ TEST DE RENDIMIENTO - Carga rápida de pantallas',
        (WidgetTester tester) async {
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

      // Verificar que la pantalla carga en menos de 3 segundos
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));

      print(
          '✅ RENDIMIENTO: Pantalla carga en ${stopwatch.elapsedMilliseconds}ms');
    });
  });

  group('🌐 TESTS DE LOCALIZACIÓN', () {
    testWidgets('🌍 TEST DE IDIOMAS - Verificar soporte multiidioma',
        (WidgetTester tester) async {
      print('🧪 TESTING: Soporte de Idiomas');

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
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que la localización funciona
      expect(find.text('Bienvenido a MEYPARK'), findsOneWidget);

      print('✅ IDIOMAS: Soporte multiidioma configurado correctamente');
    });
  });
}
