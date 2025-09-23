# 🔄 MEYPARK IA - Flujo de Desarrollo Profesional

## 📋 **ÍNDICE**
1. [Configuración Inicial](#configuración-inicial)
2. [Flujo de Desarrollo Diario](#flujo-de-desarrollo-diario)
3. [Gestión de Código](#gestión-de-código)
4. [Testing y QA](#testing-y-qa)
5. [Despliegue](#despliegue)
6. [Monitoreo](#monitoreo)
7. [Troubleshooting](#troubleshooting)

---

## ⚙️ **CONFIGURACIÓN INICIAL**

### **1. Prerrequisitos del Sistema**

#### **Software Requerido**
```bash
# Node.js 18+ (LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Flutter SDK 3.0+
sudo snap install flutter --classic
flutter doctor

# Supabase CLI
npm install -g supabase

# Python 3.12+ (para MCP)
sudo apt install python3.12 python3.12-venv python3.12-pip

# Git
sudo apt install git
```

#### **Verificación de Instalación**
```bash
# Verificar versiones
node --version    # v18.x.x
npm --version     # 9.x.x
flutter --version # 3.x.x
supabase --version # 2.x.x
python3 --version # 3.12.x
git --version     # 2.x.x
```

### **2. Configuración del Proyecto**

#### **Clonar Repositorio**
```bash
git clone <repository-url>
cd meypark-ia
```

#### **Configurar Variables de Entorno**
```bash
# Copiar archivo de ejemplo
cp .env.example .env

# Editar con tus credenciales
nano .env
```

#### **Configurar Supabase**
```bash
# Autenticarse
supabase login

# Vincular proyecto
supabase link --project-ref edkwlmauywdxbencaucj

# Verificar conexión
supabase status
```

### **3. Instalación de Dependencias**

#### **Backend (Supabase)**
```bash
# Aplicar migraciones
supabase db push

# Generar tipos
supabase gen types typescript --project-id edkwlmauywdxbencaucj > packages/shared_core/src/supabase.types.ts
supabase gen types dart --project-id edkwlmauywdxbencaucj > packages/shared_core/lib/supabase_types.dart

# Desplegar Edge Functions
supabase functions deploy
```

#### **Frontend (Next.js)**
```bash
cd apps/dashboard_web
npm install
npm run dev
```

#### **Mobile (Flutter)**
```bash
cd apps/kiosk_flutter
flutter pub get
flutter run
```

---

## 🔄 **FLUJO DE DESARROLLO DIARIO**

### **1. Inicio del Día**

#### **Sincronizar Código**
```bash
# Actualizar rama principal
git checkout main
git pull origin main

# Crear rama de feature
git checkout -b feature/nueva-funcionalidad
```

#### **Verificar Estado del Sistema**
```bash
# Verificar Supabase
supabase status

# Verificar Edge Functions
supabase functions list

# Verificar base de datos
supabase db diff
```

### **2. Desarrollo de Features**

#### **Backend (Supabase)**
```bash
# Crear nueva migración
supabase migration new nombre_migracion

# Editar migración
nano supabase/migrations/YYYYMMDDHHMMSS_nombre_migracion.sql

# Aplicar migración
supabase db push

# Crear Edge Function
supabase functions new nombre_funcion

# Desplegar función
supabase functions deploy nombre_funcion
```

#### **Frontend (Next.js)**
```bash
cd apps/dashboard_web

# Instalar dependencias
npm install

# Ejecutar en desarrollo
npm run dev

# Ejecutar tests
npm run test

# Linting
npm run lint
```

#### **Mobile (Flutter)**
```bash
cd apps/kiosk_flutter

# Obtener dependencias
flutter pub get

# Ejecutar en dispositivo
flutter run

# Ejecutar tests
flutter test

# Análisis de código
flutter analyze
```

### **3. Testing**

#### **Tests de Base de Datos**
```bash
# Ejecutar tests pgTAP
supabase test db

# Verificar políticas RLS
supabase test db --file tests/test_rls_policies.sql

# Verificar constraints
supabase test db --file tests/test_constraints.sql
```

#### **Tests de Edge Functions**
```bash
# Test local
supabase functions serve

# Test con curl
curl -X POST http://localhost:54321/functions/v1/commands \
  -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"device_id": "test", "action": "PING"}'
```

#### **Tests de Frontend**
```bash
# Next.js
cd apps/dashboard_web
npm run test
npm run test:e2e

# Flutter
cd apps/kiosk_flutter
flutter test
flutter test integration_test/
```

### **4. Commit y Push**

#### **Preparar Commit**
```bash
# Verificar cambios
git status
git diff

# Agregar archivos
git add .

# Commit con mensaje descriptivo
git commit -m "feat: agregar funcionalidad de captura de pantalla

- Implementar Edge Function screenshot
- Agregar tabla device_screenshots
- Configurar Supabase Storage
- Actualizar tipos TypeScript/Dart"
```

#### **Push a Repositorio**
```bash
# Push de la rama
git push origin feature/nueva-funcionalidad

# Crear Pull Request
# (Usar interfaz web de GitHub)
```

---

## 📝 **GESTIÓN DE CÓDIGO**

### **1. Convenciones de Naming**

#### **Commits (Conventional Commits)**
```bash
# Tipos de commit
feat:     # Nueva funcionalidad
fix:      # Corrección de bug
docs:     # Documentación
style:    # Formato, espacios
refactor: # Refactorización
test:     # Tests
chore:    # Tareas de mantenimiento

# Ejemplos
git commit -m "feat: agregar sistema de alertas en tiempo real"
git commit -m "fix: corregir validación de matrículas"
git commit -m "docs: actualizar guía de despliegue"
```

#### **Ramas (Git Flow)**
```bash
# Ramas principales
main                    # Producción
develop                 # Desarrollo
feature/nombre          # Nuevas funcionalidades
bugfix/nombre           # Correcciones
hotfix/nombre           # Correcciones urgentes

# Ejemplos
feature/screenshot-system
bugfix/payment-validation
hotfix/critical-security-patch
```

#### **Archivos y Carpetas**
```bash
# Convenciones
snake_case              # Archivos, carpetas
PascalCase              # Componentes React
camelCase               # Variables JavaScript
UPPER_CASE              # Constantes
kebab-case              # URLs, nombres de paquetes

# Ejemplos
device_screenshots.sql
DeviceStatusComponent.tsx
userPreferences
API_BASE_URL
meypark-ia-package
```

### **2. Estructura de Documentación**

#### **README Principal**
```markdown
# MEYPARK IA

## Descripción
Sistema completo de gestión de estacionamiento...

## Instalación
```bash
git clone <repo>
cd meypark-ia
./scripts/setup.sh
```

## Uso
Ver documentación en `/docs`
```

#### **Documentación por Fase**
```
docs/
├── FASE_01_BACKEND.md          # Fase 1 completada
├── FASE_02_PANEL.md            # Fase 2 en progreso
├── FASE_03_KIOSKO.md           # Fase 3 pendiente
├── FASE_04_FACTURACION.md      # Fase 4 pendiente
└── FASE_05_INSPECTOR.md        # Fase 5 pendiente
```

#### **Documentación Técnica**
```
docs/
├── ARCHITECTURE_GUIDE.md       # Guía de arquitectura
├── DEVELOPMENT_WORKFLOW.md     # Flujo de desarrollo
├── DEPLOYMENT_GUIDE.md         # Guía de despliegue
├── API_REFERENCE.md            # Referencia de API
└── TROUBLESHOOTING.md          # Solución de problemas
```

### **3. Versionado**

#### **Semantic Versioning**
```bash
# Formato: MAJOR.MINOR.PATCH
1.0.0    # Primera versión estable
1.1.0    # Nueva funcionalidad
1.1.1    # Corrección de bug
2.0.0    # Cambio incompatible

# Tags
git tag -a v1.0.0 -m "Primera versión estable"
git push origin v1.0.0
```

#### **Changelog**
```markdown
# Changelog

## [1.1.0] - 2025-09-21
### Added
- Sistema de captura de pantalla en tiempo real
- Vistas de monitoreo live
- Edge Function screenshot

### Changed
- Optimización de consultas de telemetría
- Mejora en políticas RLS

### Fixed
- Corrección en validación de matrículas
- Fix en Edge Function commands
```

---

## 🧪 **TESTING Y QA**

### **1. Estrategia de Testing**

#### **Pirámide de Testing**
```
        /\
       /  \
      / E2E \     # Tests end-to-end (Playwright)
     /______\
    /        \
   /Integration\  # Tests de integración
  /____________\
 /              \
/   Unit Tests   \  # Tests unitarios
/________________\
```

#### **Cobertura de Tests**
- **Unit Tests**: 80%+ cobertura
- **Integration Tests**: APIs y DB
- **E2E Tests**: Flujos críticos
- **Performance Tests**: Carga y estrés

### **2. Tests de Base de Datos**

#### **pgTAP Tests**
```sql
-- tests/test_rls_policies.sql
BEGIN;
SELECT plan(10);

-- Test 1: Admin puede ver todo
SELECT ok(
  auth.uid() = 'admin-uuid' AND 
  (SELECT COUNT(*) FROM companies) > 0,
  'Admin puede ver todas las empresas'
);

-- Test 2: Operator solo ve su empresa
SELECT ok(
  auth.uid() = 'operator-uuid' AND 
  (SELECT COUNT(*) FROM companies WHERE id = 'company-uuid') = 1,
  'Operator solo ve su empresa'
);

SELECT * FROM finish();
ROLLBACK;
```

#### **Tests de Constraints**
```sql
-- tests/test_constraints.sql
BEGIN;
SELECT plan(5);

-- Test 1: amount_cents debe ser positivo
SELECT throws_ok(
  'INSERT INTO tickets (amount_cents) VALUES (-100)',
  'amount_cents debe ser positivo'
);

-- Test 2: email debe ser válido
SELECT throws_ok(
  'INSERT INTO profiles (email) VALUES (''invalid-email'')',
  'email debe ser válido'
);

SELECT * FROM finish();
ROLLBACK;
```

### **3. Tests de Frontend**

#### **Unit Tests (Jest)**
```javascript
// tests/components/DeviceStatus.test.tsx
import { render, screen } from '@testing-library/react';
import { DeviceStatus } from '../DeviceStatus';

describe('DeviceStatus', () => {
  test('muestra estado online correctamente', () => {
    render(<DeviceStatus status="online" />);
    expect(screen.getByText('Online')).toBeInTheDocument();
  });

  test('muestra estado offline correctamente', () => {
    render(<DeviceStatus status="offline" />);
    expect(screen.getByText('Offline')).toBeInTheDocument();
  });
});
```

#### **Integration Tests (Cypress)**
```javascript
// cypress/integration/dashboard.spec.js
describe('Dashboard', () => {
  beforeEach(() => {
    cy.login('admin@meypark.com', 'password');
  });

  it('muestra dispositivos correctamente', () => {
    cy.visit('/dashboard');
    cy.get('[data-testid="device-list"]').should('be.visible');
    cy.get('[data-testid="device-item"]').should('have.length.greaterThan', 0);
  });
});
```

### **4. Tests de Flutter**

#### **Unit Tests**
```dart
// test/widgets/device_card_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:meypark_ia/widgets/device_card.dart';

void main() {
  group('DeviceCard', () {
    testWidgets('muestra información del dispositivo', (WidgetTester tester) async {
      final device = Device(
        id: '1',
        alias: 'Kiosko Madrid',
        status: 'online',
      );

      await tester.pumpWidget(DeviceCard(device: device));

      expect(find.text('Kiosko Madrid'), findsOneWidget);
      expect(find.text('Online'), findsOneWidget);
    });
  });
}
```

#### **Integration Tests**
```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meypark_ia/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('login flow completo', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test login
      await tester.enterText(find.byKey(Key('email_field')), 'test@test.com');
      await tester.enterText(find.byKey(Key('password_field')), 'password');
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // Verificar que llegamos al dashboard
      expect(find.byKey(Key('dashboard')), findsOneWidget);
    });
  });
}
```

---

## 🚀 **DESPLIEGUE**

### **1. Ambientes**

#### **Desarrollo (Local)**
```bash
# Configuración
NODE_ENV=development
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=local_key

# Comandos
npm run dev
supabase start
```

#### **Staging**
```bash
# Configuración
NODE_ENV=staging
SUPABASE_URL=https://staging-project.supabase.co
SUPABASE_ANON_KEY=staging_key

# Despliegue
npm run build:staging
supabase db push --project-ref staging-ref
```

#### **Producción**
```bash
# Configuración
NODE_ENV=production
SUPABASE_URL=https://edkwlmauywdxbencaucj.supabase.co
SUPABASE_ANON_KEY=production_key

# Despliegue
npm run build:production
supabase db push --project-ref edkwlmauywdxbencaucj
```

### **2. Pipeline CI/CD**

#### **GitHub Actions**
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run test
      - run: npm run lint

  deploy-staging:
    if: github.ref == 'refs/heads/develop'
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Staging
        run: |
          supabase functions deploy --project-ref staging-ref
          supabase db push --project-ref staging-ref

  deploy-production:
    if: github.ref == 'refs/heads/main'
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Production
        run: |
          supabase functions deploy --project-ref edkwlmauywdxbencaucj
          supabase db push --project-ref edkwlmauywdxbencaucj
```

### **3. Rollback Strategy**

#### **Base de Datos**
```bash
# Rollback de migración
supabase migration list
supabase migration rollback --target 20240101000001

# Rollback de Edge Functions
supabase functions list
supabase functions deploy previous-version
```

#### **Aplicación**
```bash
# Rollback de versión
git checkout previous-tag
npm run build
npm run deploy
```

---

## 📊 **MONITOREO**

### **1. Métricas Clave**

#### **Sistema**
- **CPU Usage**: < 70%
- **Memory Usage**: < 80%
- **Disk Usage**: < 85%
- **Network Latency**: < 100ms

#### **Aplicación**
- **Response Time**: < 500ms
- **Error Rate**: < 1%
- **Uptime**: > 99.9%
- **Active Users**: Real-time

#### **Base de Datos**
- **Query Time**: < 100ms
- **Connection Pool**: < 80%
- **Replication Lag**: < 1s
- **Storage Usage**: < 80%

### **2. Alertas**

#### **Críticas (P0)**
- Sistema caído
- Base de datos desconectada
- Error rate > 5%
- Response time > 2s

#### **Advertencias (P1)**
- CPU > 80%
- Memory > 90%
- Error rate > 1%
- Response time > 1s

#### **Informativas (P2)**
- Nuevos dispositivos
- Actualizaciones de software
- Cambios de configuración

### **3. Dashboards**

#### **Supabase Dashboard**
- Métricas de base de datos
- Edge Functions logs
- Auth metrics
- Storage usage

#### **Custom Dashboard**
- Métricas de negocio
- Dispositivos online/offline
- Sesiones activas
- Alertas del sistema

---

## 🔧 **TROUBLESHOOTING**

### **1. Problemas Comunes**

#### **Supabase Connection**
```bash
# Verificar estado
supabase status

# Verificar logs
supabase logs

# Reiniciar servicios
supabase stop
supabase start
```

#### **Edge Functions**
```bash
# Ver logs de función
supabase functions logs function-name

# Test local
supabase functions serve

# Debug
supabase functions serve --debug
```

#### **Base de Datos**
```bash
# Verificar migraciones
supabase migration list

# Aplicar migración específica
supabase db push --target migration-id

# Reset completo
supabase db reset
```

### **2. Debugging**

#### **Frontend (Next.js)**
```bash
# Modo debug
NODE_ENV=development DEBUG=* npm run dev

# Verificar variables de entorno
console.log(process.env.NEXT_PUBLIC_SUPABASE_URL)

# Network tab en DevTools
```

#### **Mobile (Flutter)**
```bash
# Debug mode
flutter run --debug

# Verbose logging
flutter run -v

# Flutter Inspector
flutter run --debug --enable-software-rendering
```

### **3. Performance Issues**

#### **Base de Datos**
```sql
-- Verificar queries lentas
SELECT query, mean_time, calls 
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;

-- Verificar índices
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

#### **Frontend**
```bash
# Bundle analyzer
npm run analyze

# Lighthouse audit
npm run lighthouse

# Performance profiling
npm run profile
```

---

## 📚 **RECURSOS ADICIONALES**

### **Documentación**
- [Supabase Docs](https://supabase.com/docs)
- [Next.js Docs](https://nextjs.org/docs)
- [Flutter Docs](https://flutter.dev/docs)
- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)

### **Herramientas**
- [Supabase CLI](https://supabase.com/docs/reference/cli)
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools)
- [Next.js DevTools](https://nextjs.org/docs/advanced-features/debugging)

### **Comunidad**
- [Supabase Discord](https://discord.supabase.com)
- [Flutter Community](https://flutter.dev/community)
- [Next.js Community](https://nextjs.org/community)

---

**🎉 ¡Flujo de desarrollo profesional implementado!**

*Última actualización: 21 de Septiembre de 2025*
