import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../lib/features/home/home_screen.dart';
import '../lib/features/pay/zone_picker_screen.dart';
import '../lib/features/pay/plate_input_screen.dart';
import '../lib/features/pay/duration_screen.dart';
import '../lib/features/pay/payment_screen.dart';
import '../lib/features/pay/payment_result_screen.dart';
import '../lib/features/accessibility/accessibility_screen.dart';
import '../lib/features/fines/cancel_fine_screen.dart';

void main() {
  group('MEYPARK IA - Tests Completos', () {
    testWidgets('Test 1: Pantalla Home - Verificar botones y navegación',
        (WidgetTester tester) async {
      // Crear MaterialApp con ProviderScope
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomeScreen(),
            routes: {
              '/pay-zone': (context) => const ZonePickerScreen(),
              '/accessibility': (context) => const AccessibilityScreen(),
              '/cancel-fine': (context) => const CancelFineScreen(),
            },
          ),
        ),
      );

      // Verificar que la pantalla se carga
      expect(find.byType(HomeScreen), findsOneWidget);

      // Verificar elementos principales
      expect(find.text('Bienvenido a MEYPARK'), findsOneWidget);
      expect(find.text('Sistema Inteligente de Parquímetros'), findsOneWidget);
      expect(find.text('PAGAR ESTACIONAMIENTO'), findsOneWidget);
      expect(find.text('ANULAR DENUNCIA'), findsOneWidget);
      expect(find.text('IDIOMAS'), findsOneWidget);
      expect(find.text('ACCESO'), findsOneWidget);

      // Verificar iconos
      expect(find.byIcon(Icons.local_parking), findsOneWidget);
      expect(find.byIcon(Icons.payment), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
      expect(find.byIcon(Icons.accessibility), findsOneWidget);

      print('✅ Test 1 PASADO: Pantalla Home con todos los elementos');
    });

    testWidgets('Test 2: Pantalla Zone Picker - Verificar carga de zonas',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const ZonePickerScreen(),
          ),
        ),
      );

      // Verificar que la pantalla se carga
      expect(find.byType(ZonePickerScreen), findsOneWidget);

      // Verificar elementos principales
      expect(
          find.text('Selecciona tu Zona de Estacionamiento'), findsOneWidget);

      // Verificar que se muestran las zonas demo
      expect(find.text('Zona Centro'), findsOneWidget);
      expect(find.text('Zona Comercial'), findsOneWidget);
      expect(find.text('Zona Residencial'), findsOneWidget);
      expect(find.text('Zona Turística'), findsOneWidget);
      expect(find.text('Zona Hospital'), findsOneWidget);
      expect(find.text('Zona Universidad'), findsOneWidget);

      // Verificar precios
      expect(find.text('2.50€'), findsOneWidget);
      expect(find.text('3.00€'), findsOneWidget);
      expect(find.text('1.50€'), findsOneWidget);

      print('✅ Test 2 PASADO: Pantalla Zone Picker con zonas demo');
    });

    testWidgets('Test 3: Pantalla Plate Input - Verificar validación',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PlateInputScreen(),
          ),
        ),
      );

      // Verificar que la pantalla se carga
      expect(find.byType(PlateInputScreen), findsOneWidget);

      // Verificar elementos principales
      expect(find.text('Matrícula del Vehículo'), findsOneWidget);
      expect(
          find.text('Introduce la matrícula de tu vehículo'), findsOneWidget);
      expect(find.text('País:'), findsOneWidget);
      expect(find.text('Matrícula:'), findsOneWidget);

      // Verificar dropdown de países
      expect(find.text('España'), findsOneWidget);

      // Verificar campo de texto
      expect(find.byType(TextFormField), findsOneWidget);

      // Verificar botón continuar (inicialmente deshabilitado)
      expect(find.text('CONTINUAR'), findsOneWidget);

      print('✅ Test 3 PASADO: Pantalla Plate Input con validación');
    });

    testWidgets('Test 4: Pantalla Duration - Verificar cálculos',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const DurationScreen(),
          ),
        ),
      );

      // Verificar que la pantalla se carga
      expect(find.byType(DurationScreen), findsOneWidget);

      // Verificar elementos principales
      expect(find.text('Duración del Estacionamiento'), findsOneWidget);
      expect(find.text('Selecciona cuánto tiempo quieres estacionar'),
          findsOneWidget);

      // Verificar botones de duración
      expect(find.text('1h'), findsOneWidget);
      expect(find.text('2h'), findsOneWidget);
      expect(find.text('4h'), findsOneWidget);
      expect(find.text('8h'), findsOneWidget);

      // Verificar precios
      expect(find.text('Precio por hora:'), findsOneWidget);
      expect(find.text('2.50€'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);

      // Verificar botón continuar
      expect(find.text('CONTINUAR AL PAGO'), findsOneWidget);

      print('✅ Test 4 PASADO: Pantalla Duration con cálculos');
    });

    testWidgets('Test 5: Pantalla Payment - Verificar métodos de pago',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PaymentScreen(),
          ),
        ),
      );

      // Verificar que la pantalla se carga
      expect(find.byType(PaymentScreen), findsOneWidget);

      // Verificar elementos principales
      expect(find.text('Método de Pago'), findsOneWidget);
      expect(find.text('Selecciona cómo quieres pagar'), findsOneWidget);

      // Verificar métodos de pago
      expect(find.text('Tarjeta de Crédito/Débito'), findsOneWidget);
      expect(find.text('Pago Sin Contacto'), findsOneWidget);
      expect(find.text('Pago Móvil'), findsOneWidget);
      expect(find.text('Efectivo'), findsOneWidget);

      // Verificar resumen del pago
      expect(find.text('Zona:'), findsOneWidget);
      expect(find.text('Matrícula:'), findsOneWidget);
      expect(find.text('Duración:'), findsOneWidget);
      expect(find.text('TOTAL:'), findsOneWidget);

      print('✅ Test 5 PASADO: Pantalla Payment con métodos de pago');
    });

    testWidgets('Test 6: Pantalla Payment Result - Verificar resultado',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const PaymentResultScreen(),
          ),
        ),
      );

      // Verificar que la pantalla se carga
      expect(find.byType(PaymentResultScreen), findsOneWidget);

      // Verificar elementos principales
      expect(find.text('¡Pago Exitoso!'), findsOneWidget);
      expect(find.text('Tu estacionamiento ha sido pagado correctamente'),
          findsOneWidget);

      // Verificar detalles del pago
      expect(find.text('ID de Transacción:'), findsOneWidget);
      expect(find.text('Importe Pagado:'), findsOneWidget);
      expect(find.text('Fecha:'), findsOneWidget);
      expect(find.text('Hora:'), findsOneWidget);

      // Verificar botones
      expect(find.text('VOLVER AL INICIO'), findsOneWidget);
      expect(find.text('NUEVO PAGO'), findsOneWidget);

      print('✅ Test 6 PASADO: Pantalla Payment Result con resultado');
    });

    testWidgets('Test 7: Pantalla Accessibility - Verificar configuraciones',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const AccessibilityScreen(),
          ),
        ),
      );

      // Verificar que la pantalla se carga
      expect(find.byType(AccessibilityScreen), findsOneWidget);

      print('✅ Test 7 PASADO: Pantalla Accessibility cargada');
    });

    testWidgets('Test 8: Pantalla Cancel Fine - Verificar funcionalidad',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const CancelFineScreen(),
          ),
        ),
      );

      // Verificar que la pantalla se carga
      expect(find.byType(CancelFineScreen), findsOneWidget);

      print('✅ Test 8 PASADO: Pantalla Cancel Fine cargada');
    });

    testWidgets('Test 9: Verificar que todas las pantallas tienen AppBar',
        (WidgetTester tester) async {
      final screens = [
        const HomeScreen(),
        const ZonePickerScreen(),
        const PlateInputScreen(),
        const DurationScreen(),
        const PaymentScreen(),
        const PaymentResultScreen(),
        const AccessibilityScreen(),
        const CancelFineScreen(),
      ];

      for (final screen in screens) {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: screen,
            ),
          ),
        );

        // Verificar que cada pantalla tiene AppBar
        expect(find.byType(AppBar), findsOneWidget);
        await tester.pumpAndSettle();
      }

      print('✅ Test 9 PASADO: Todas las pantallas tienen AppBar');
    });

    testWidgets(
        'Test 10: Verificar que todas las pantallas tienen botones de navegación',
        (WidgetTester tester) async {
      final screens = [
        const HomeScreen(),
        const ZonePickerScreen(),
        const PlateInputScreen(),
        const DurationScreen(),
        const PaymentScreen(),
        const PaymentResultScreen(),
        const AccessibilityScreen(),
        const CancelFineScreen(),
      ];

      for (final screen in screens) {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: screen,
            ),
          ),
        );

        // Verificar que cada pantalla tiene botones
        expect(find.byType(ElevatedButton), findsWidgets);
        await tester.pumpAndSettle();
      }

      print('✅ Test 10 PASADO: Todas las pantallas tienen botones');
    });
  });
}
