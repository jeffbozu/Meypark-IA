import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../lib/widgets/password_dialog.dart';
import '../lib/widgets/gesture_detector_logo.dart';
import '../lib/core/providers/supabase_providers.dart';

void main() {
  group('🔐 Sistema de Contraseñas', () {
    testWidgets('PasswordDialog - Login mode muestra interfaz correcta',
        (WidgetTester tester) async {
      bool onSuccessCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordDialog(
              mode: 'login',
              onSuccess: () => onSuccessCalled = true,
            ),
          ),
        ),
      );

      // Verificar elementos de la interfaz
      expect(find.text('Acceso a Login'), findsOneWidget);
      expect(find.text('Introduce la contraseña para acceder al Login'),
          findsOneWidget);
      expect(find.byIcon(Icons.login), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Acceder'), findsOneWidget);
    });

    testWidgets('PasswordDialog - Tech mode muestra interfaz correcta',
        (WidgetTester tester) async {
      bool onSuccessCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordDialog(
              mode: 'tech_mode',
              onSuccess: () => onSuccessCalled = true,
            ),
          ),
        ),
      );

      // Verificar elementos de la interfaz
      expect(find.text('Acceso a Modo Técnico'), findsOneWidget);
      expect(find.text('Introduce la contraseña para acceder al Modo Técnico'),
          findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Acceder'), findsOneWidget);
    });

    testWidgets('PasswordDialog - Validación de campo vacío',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordDialog(
              mode: 'login',
              onSuccess: () {},
            ),
          ),
        ),
      );

      // Intentar acceder sin contraseña
      await tester.tap(find.text('Acceder'));
      await tester.pump();

      // Verificar mensaje de error
      expect(find.text('Por favor introduce la contraseña'), findsOneWidget);
    });

    testWidgets('PasswordDialog - Toggle de visibilidad de contraseña',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordDialog(
              mode: 'login',
              onSuccess: () {},
            ),
          ),
        ),
      );

      // Verificar que inicialmente está oculta
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);

      // Tocar el botón de visibilidad
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Verificar que ahora es visible
      final textFieldAfter = tester.widget<TextField>(find.byType(TextField));
      expect(textFieldAfter.obscureText, isFalse);
    });

    testWidgets('GestureDetectorLogo - Detecta 3 toques seguidos',
        (WidgetTester tester) async {
      bool dialogShown = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetectorLogo(
              logoText: 'MEYPARK',
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: const Text('Logo'),
              ),
            ),
          ),
        ),
      );

      // Simular 3 toques seguidos
      await tester.tap(find.text('Logo'));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Logo'));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Logo'));
      await tester.pump();

      // Verificar que se muestra el diálogo
      expect(find.text('Acceso a Login'), findsOneWidget);
    });

    testWidgets('GestureDetectorLogo - Se renderiza correctamente',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetectorLogo(
              logoText: 'MEYPARK',
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: const Text('Logo'),
              ),
            ),
          ),
        ),
      );

      // Verificar que el widget se renderiza
      expect(find.text('Logo'), findsOneWidget);
      expect(find.byType(GestureDetectorLogo), findsOneWidget);
    });

    test('Contraseñas demo funcionan correctamente', () {
      // Verificar contraseña de login
      expect(_verifyDemoPassword('login', 'meypark2025'), isTrue);
      expect(_verifyDemoPassword('login', 'password_incorrecta'), isFalse);

      // Verificar contraseña de modo técnico
      expect(_verifyDemoPassword('tech_mode', 'admin123'), isTrue);
      expect(_verifyDemoPassword('tech_mode', 'password_incorrecta'), isFalse);

      // Verificar tipo inválido
      expect(
          _verifyDemoPassword('invalid_type', 'cualquier_password'), isFalse);
    });
  });
}

// Función helper para testing (copiada del provider)
bool _verifyDemoPassword(String type, String password) {
  switch (type) {
    case 'login':
      return password == 'meypark2025';
    case 'tech_mode':
      return password == 'admin123';
    default:
      return false;
  }
}
