import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('🔍 Auditoría de datos hardcodeados en lib/', () {
    test('No debe haber mocks ni datos de negocio hardcodeados prohibidos',
        () async {
      final libDir = Directory('lib');
      expect(await libDir.exists(), isTrue,
          reason: 'Directorio lib/ no encontrado');

      // Archivos/carpetas a excluir
      final excludedPathsPatterns = <RegExp>[
        RegExp(r'/generated/'),
        RegExp(r'\.g\.dart$'),
        RegExp(r'\.freezed\.dart$'),
        RegExp(r'/models/.*\.dart$'),
      ];

      // Patrones sospechosos (strings o claves típicas de mocks/hardcode)
      final suspiciousPatterns = <RegExp>[
        RegExp(r'\bmock(s)?\b', caseSensitive: false),
        RegExp(r'fixture', caseSensitive: false),
        RegExp(r'fake', caseSensitive: false),
        RegExp(r'dummy', caseSensitive: false),
        RegExp(r'TODO:\s*Implementar\s*(.*)\bSupabase\b', caseSensitive: false),
        RegExp(r'\bHARDCODED\b|\bHARDCODEADO\b', caseSensitive: false),
        // Listas/mapas grandes inline (heurística: 4+ elementos separados por comas en una misma declaración)
        RegExp(r'\{[^\n}]*,[^\n}]*,[^\n}]*,[^\n}]*\}'),
        RegExp(r'\[[^\n\]]*,[^\n\]]*,[^\n\]]*,[^\n\]]*\]'),
      ];

      // Permitir ciertos hardcodes locales (catálogos estáticos/UI): patrones de whitelist
      final allowlistFileScoped = <RegExp, List<RegExp>>{
        // Países en CancelFineScreen
        RegExp(r'lib/features/fines/cancel_fine_screen\.dart'): [
          RegExp(r"_countries\s*=\s*\{[\s\S]*'ES':[\s\S]*'GB':[\s\S]*\}")
        ],
        // Colores o estilos de tema locales son aceptables
        RegExp(r'lib/main\.dart'): [
          RegExp(r'ColorScheme\.fromSeed\('),
        ],
        // Env puede contener defaults, pero NO claves reales sensibles. Validamos aparte.
        RegExp(r'lib/core/env\.dart'): [
          RegExp(r'String\.fromEnvironment'),
        ],
      };

      // Validación específica para env.dart: las claves por defecto no deben ser productivas reales
      String? envViolation;

      final violations = <String>[];

      await for (final entity
          in libDir.list(recursive: true, followLinks: false)) {
        if (entity is! File) continue;
        if (!entity.path.endsWith('.dart')) continue;

        final normalizedPath = entity.path.replaceAll('\\', '/');
        // Excluir rutas por patrón
        if (excludedPathsPatterns.any((p) => p.hasMatch(normalizedPath))) {
          continue;
        }

        final content = await entity.readAsString();

        // Allowlist por archivo
        final fileAllow = allowlistFileScoped.entries
            .where((e) => e.key.hasMatch(normalizedPath))
            .expand((e) => e.value)
            .toList();

        // Comprobar patrones sospechosos
        for (final pattern in suspiciousPatterns) {
          for (final match in pattern.allMatches(content)) {
            final snippet = _extractLine(content, match.start);
            final allowed = fileAllow.any((allow) => allow.hasMatch(content));
            if (!allowed) {
              violations.add('$normalizedPath: "$snippet"');
            }
          }
        }

        // Chequeo especial de mocks típicos (variables con nombre mock*)
        final variableMockName = RegExp(
            r'final\s+mock\w*\s*=|const\s+mock\w*\s*=',
            caseSensitive: false);
        for (final match in variableMockName.allMatches(content)) {
          final snippet = _extractLine(content, match.start);
          final allowed = fileAllow.any((allow) => allow.hasMatch(content));
          if (!allowed) {
            violations.add('$normalizedPath: "$snippet"');
          }
        }

        // Validación env.dart
        if (normalizedPath.endsWith('lib/core/env.dart')) {
          // No permitir un anon key real en defaultValue (parece JWT largo)
          final anonDefault = RegExp(
              r"supabaseAnonKey\s*=\s*String\.fromEnvironment\([\s\S]*defaultValue:\s*'([A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+)'",
              multiLine: true);
          final urlDefault = RegExp(
              r"supabaseUrl\s*=\s*String\.fromEnvironment\([\s\S]*defaultValue:\s*'https?://[a-z0-9-]+\\.supabase\\.co'",
              caseSensitive: false,
              multiLine: true);

          if (anonDefault.hasMatch(content)) {
            envViolation =
                'env.dart contiene un SUPABASE_ANON_KEY por defecto con formato de JWT. Debe moverse a variables de entorno y dejar default vacío.';
          }
          if (urlDefault.hasMatch(content)) {
            // Permitimos URL demo si es necesario, pero idealmente debe venir por entorno.
            // No marcamos como violación dura, solo recomendación.
          }
        }
      }

      if (envViolation != null) {
        violations.add('lib/core/env.dart: $envViolation');
      }

      if (violations.isNotEmpty) {
        final message = StringBuffer()
          ..writeln(
              'Se detectaron posibles datos hardcodeados o mocks prohibidos:')
          ..writeln(violations.map((v) => '- $v').join('\n'))
          ..writeln('\nSoluciones sugeridas:')
          ..writeln(
              '- Mover catálogos y datos de negocio a Supabase (tablas/config).')
          ..writeln(
              '- Reemplazar mocks por llamadas a providers/servicios de Supabase.')
          ..writeln(
              '- Si el dato debe ser local por diseño, añadir una regla de allowlist específica y documentar la razón.');
        fail(message.toString());
      }
    });
  });
}

String _extractLine(String content, int index) {
  final start = content.lastIndexOf('\n', index) + 1;
  final end = content.indexOf('\n', index);
  final line =
      content.substring(start, end == -1 ? content.length : end).trim();
  return line.length > 160 ? '${line.substring(0, 160)}…' : line;
}
