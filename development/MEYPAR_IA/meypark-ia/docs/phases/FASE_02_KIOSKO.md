# 🏪 FASE 2 - KIOSKO FLUTTER (Linux + Web)
**Roles: Frontend + DevOps + QA + Diseño UI/UX**

## 📋 **ÍNDICE**
1. [Análisis de la Fase 2](#análisis-de-la-fase-2)
2. [Investigación y Mejores Prácticas](#investigación-y-mejores-prácticas)
3. [Arquitectura de la Aplicación](#arquitectura-de-la-aplicación)
4. [Diseño UI/UX](#diseño-uiux)
5. [Desarrollo Frontend](#desarrollo-frontend)
6. [Testing y QA](#testing-y-qa)
7. [DevOps y Despliegue](#devops-y-despliegue)
8. [Cumplimiento Legal](#cumplimiento-legal)
9. [Plan de Implementación](#plan-de-implementación)

---

## 🎯 **ANÁLISIS DE LA FASE 2**

### **Objetivo Principal**
Crear una **app de kiosko Flutter** para pantallas táctiles de 10" vertical (como los parquímetros de Barcelona), que funcione en Linux y esté preparada para Web, con integración total a Supabase.

### **Funcionalidades Clave Identificadas**
1. **💳 Pago de estacionamiento** (zonas azul/verde como Barcelona)
2. **⏰ Extensión de sesiones** existentes
3. **🚫 Anulación de denuncias/multas**
4. **♿ Accesibilidad completa** (TTS, alto contraste, tamaños, etc.)
5. **🔧 Modo técnico** para mantenimiento
6. **🤖 IA adaptativa** (recomendaciones inteligentes)
7. **📡 Comandos remotos** desde el panel de administración
8. **🌍 Multi-idioma** (ES, EN, DE, FR, IT + regionales)

### **Requisitos Técnicos**
- **Plataforma**: Flutter 3.22+ (Linux + Web)
- **Pantalla**: 10" vertical, táctil, fullscreen
- **Integración**: Supabase (Auth, Realtime, Storage)
- **Estado**: Riverpod + go_router
- **Accesibilidad**: WCAG 2.1 AA compliance
- **Idiomas**: ES, EN, DE, FR, IT + ca-ES, gl-ES, eu-ES

---

## 🔍 **INVESTIGACIÓN Y MEJORES PRÁCTICAS**

### **1. Mejores Prácticas para Kioskos de Parquímetro**

#### **✅ Diseño UI/UX**
- **Botones grandes**: Mínimo 64-72dp para fácil toque
- **Alto contraste**: Por defecto para visibilidad
- **Tipografías grandes**: Títulos ≥ 22-28sp
- **Área segura**: Evitar bordes de pantalla
- **Feedback visual**: Animaciones 200-300ms
- **Navegación simple**: Máximo 3 niveles de profundidad

#### **✅ Accesibilidad (WCAG 2.1 AA)**
- **TTS (Text-to-Speech)**: Guía por voz completa
- **Alto contraste**: Modo oscuro/claro
- **Escalado de texto**: 100%, 125%, 150%, 175%
- **Entrada por voz**: Comandos de voz
- **Tiempo ampliado**: Pausas x2/x4
- **Lectores de pantalla**: Compatibilidad total

#### **✅ Experiencia de Usuario**
- **Flujo intuitivo**: Pagar → Matrícula → Zona → Duración → Pago
- **Feedback inmediato**: Confirmaciones visuales/auditivas
- **Manejo de errores**: Mensajes claros y accionables
- **Modo offline**: Funcionalidad básica sin red
- **Idiomas locales**: Soporte completo regional

### **2. Cumplimiento Legal Español**

#### **✅ Normativas de Estacionamiento**
- **Ley de Tráfico**: Cumplimiento de normativas de estacionamiento
- **Zonas reguladas**: Azul (pago), Verde (residencial), Amarilla (carga/descarga)
- **Tarifas**: Configurables por zona y horario
- **Multas**: Sistema de denuncias integrado
- **Facturación**: Cumplimiento fiscal español

#### **✅ Protección de Datos (GDPR)**
- **Consentimiento**: Información clara sobre uso de datos
- **Minimización**: Solo datos necesarios
- **Seguridad**: Encriptación de datos sensibles
- **Retención**: Políticas de retención de datos
- **Derechos**: Acceso, rectificación, supresión

### **3. Integración con Supabase**

#### **✅ Arquitectura Optimizada**
- **Single Source of Truth**: Supabase como única fuente
- **Realtime**: Actualizaciones instantáneas
- **RLS**: Seguridad multi-tenant
- **Edge Functions**: Lógica de negocio
- **Storage**: Imágenes y documentos

---

## 🏗️ **ARQUITECTURA DE LA APLICACIÓN**

### **Patrón Arquitectónico: Clean Architecture + MVVM**

```
┌─────────────────────────────────────────────────────────────┐
│                    KIOSKO FLUTTER APP                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   PRESENTATION LAYER          │  │   WIDGETS   │        │
│  │  (Screens, Controllers)       │  │  (Reusable) │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│           │              │              │                  │
│  ┌─────────────────────────────────────────────────────────┤
│  │              BUSINESS LOGIC LAYER                       │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │
│  │  │  USE CASES  │  │  SERVICES   │  │  PROVIDERS  │    │
│  │  │  (Payment,  │  │  (Supabase, │  │  (Riverpod) │    │
│  │  │  Auth, etc) │  │  TTS, etc)  │  │             │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘    │
│  └─────────────────────────────────────────────────────────┤
│           │              │              │                  │
│  ┌─────────────────────────────────────────────────────────┤
│  │              DATA LAYER                                 │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │
│  │  │  REPOSITORIES│  │  DATA SOURCES│  │   MODELS   │    │
│  │  │  (Local,    │  │  (Supabase, │  │  (Entities) │    │
│  │  │  Remote)    │  │  Storage)   │  │             │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘    │
│  └─────────────────────────────────────────────────────────┤
└─────────────────────────────────────────────────────────────┘
```

### **Estructura del Proyecto**

```
apps/kiosk_flutter/
├── 📁 lib/
│   ├── 📄 main.dart                    # Entry point
│   ├── 📄 app.dart                     # MaterialApp config
│   ├── 📁 core/                        # Core functionality
│   │   ├── 📁 supabase/               # Supabase client
│   │   ├── 📁 theme/                  # Theming system
│   │   ├── 📁 i18n/                   # Internationalization
│   │   ├── 📁 utils/                  # Utilities
│   │   └── 📁 constants/              # App constants
│   ├── 📁 features/                   # Feature modules
│   │   ├── 📁 boot/                   # Startup & splash
│   │   ├── 📁 auth/                   # Authentication
│   │   ├── 📁 home/                   # Home screen
│   │   ├── 📁 pay/                    # Payment flow
│   │   ├── 📁 extend/                 # Extend session
│   │   ├── 📁 fines/                  # Fines management
│   │   ├── 📁 accessibility/          # A11y features
│   │   ├── 📁 tech_mode/              # Technical mode
│   │   ├── 📁 commands/               # Remote commands
│   │   └── 📁 telemetry/              # Device telemetry
│   ├── 📁 widgets/                    # Reusable widgets
│   └── 📁 generated/                  # Generated code
├── 📁 assets/                         # Static assets
├── 📁 test/                          # Unit tests
├── 📁 integration_test/              # Integration tests
├── 📁 web/                           # Web configuration
├── 📁 linux/                         # Linux configuration
└── 📄 pubspec.yaml                   # Dependencies
```

---

## 🎨 **DISEÑO UI/UX**

### **1. Principios de Diseño**

#### **✅ Usabilidad**
- **Simplicidad**: Máximo 3 pasos para completar una acción
- **Consistencia**: Mismos patrones en toda la app
- **Feedback**: Confirmación visual/auditiva inmediata
- **Error Prevention**: Validación en tiempo real
- **Recovery**: Fácil corrección de errores

#### **✅ Accesibilidad**
- **Perceptible**: Alto contraste, texto grande
- **Operable**: Botones grandes, navegación por teclado
- **Comprensible**: Lenguaje claro y simple
- **Robusto**: Compatible con tecnologías asistivas

### **2. Pantallas Principales**

#### **🏠 Home Screen**
```
┌─────────────────────────────────┐
│ [Logo] [Hora] [Idioma] [♿]     │
├─────────────────────────────────┤
│                                 │
│        [PAGAR]                  │
│      (Botón grande)             │
│                                 │
│     [ANULAR DENUNCIA]           │
│      (Botón grande)             │
│                                 │
│                                 │
└─────────────────────────────────┘
```

#### **💳 Payment Flow**
```
1. Zona → 2. Matrícula → 3. Duración → 4. Pago → 5. Resultado
```

#### **♿ Accessibility Panel**
```
┌─────────────────────────────────┐
│ [Ver] [Escuchar] [Introducir]   │
│ [Tiempo] [Idioma] [IA]          │
├─────────────────────────────────┤
│ Alto contraste: [ON/OFF]        │
│ Tamaño texto: [100%] [125%]     │
│ TTS: [ON/OFF] [Velocidad]       │
│ Entrada voz: [ON/OFF]           │
│ Tiempo ampliado: [x2] [x4]      │
└─────────────────────────────────┘
```

### **3. Sistema de Colores**

#### **✅ Paleta Principal**
- **Primary**: #E62144 (Rojo MEYPARK)
- **Secondary**: #000000 (Negro)
- **Accent**: #7F7F7F (Gris)
- **Success**: #4CAF50 (Verde)
- **Warning**: #FF9800 (Naranja)
- **Error**: #F44336 (Rojo)

#### **✅ Modo Alto Contraste**
- **Background**: #000000
- **Text**: #FFFFFF
- **Buttons**: #FFFFFF con borde #FFFFFF
- **Focus**: #FFFF00 (Amarillo)

---

## 💻 **DESARROLLO FRONTEND**

### **1. Stack Tecnológico**

#### **✅ Dependencias Principales**
```yaml
dependencies:
  flutter: ^3.22.0
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  go_router: ^12.1.3
  supabase_flutter: ^2.0.0
  intl: ^0.19.0
  flutter_tts: ^3.8.5
  universal_io: ^2.2.2
  qr_flutter: ^4.1.0
  window_manager: ^0.3.7
  file_selector: ^6.0.1
  equatable: ^2.0.5
  freezed: ^2.4.6
  logging: ^1.2.0
```

#### **✅ Dependencias de Desarrollo**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  riverpod_generator: ^2.3.9
  build_runner: ^2.4.7
  golden_toolkit: ^0.15.0
  mockito: ^5.4.4
  flutter_lints: ^3.0.1
```

### **2. Arquitectura de Estado**

#### **✅ Riverpod Providers**
```dart
// Theme provider
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeData build() => loadThemeFromSupabase();
  
  void updateTheme(ThemeData theme) {
    state = theme;
  }
}

// Payment provider
@riverpod
class PaymentNotifier extends _$PaymentNotifier {
  @override
  PaymentState build() => const PaymentState.initial();
  
  Future<void> processPayment(PaymentRequest request) async {
    state = const PaymentState.loading();
    try {
      final result = await paymentService.processPayment(request);
      state = PaymentState.success(result);
    } catch (e) {
      state = PaymentState.error(e.toString());
    }
  }
}
```

### **3. Navegación**

#### **✅ GoRouter Configuration**
```dart
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/pay',
      builder: (context, state) => const PaymentFlowScreen(),
      routes: [
        GoRoute(
          path: '/zone',
          builder: (context, state) => const ZonePickerScreen(),
        ),
        GoRoute(
          path: '/plate',
          builder: (context, state) => const PlateInputScreen(),
        ),
        GoRoute(
          path: '/duration',
          builder: (context, state) => const DurationScreen(),
        ),
        GoRoute(
          path: '/payment',
          builder: (context, state) => const PaymentScreen(),
        ),
        GoRoute(
          path: '/result',
          builder: (context, state) => const ResultScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/accessibility',
      builder: (context, state) => const AccessibilityScreen(),
    ),
    GoRoute(
      path: '/tech-mode',
      builder: (context, state) => const TechModeScreen(),
    ),
  ],
);
```

---

## 🧪 **TESTING Y QA**

### **1. Estrategia de Testing**

#### **✅ Pirámide de Testing**
```
        /\
       /  \
      / E2E \     # Flows completos
     /______\
    /        \
   /Integration\  # Features + Supabase
  /____________\
 /              \
/   Unit Tests   \  # Widgets + Logic
/________________\
```

### **2. Tipos de Tests**

#### **✅ Unit Tests**
```dart
// Plate validator test
void main() {
  group('PlateValidator', () {
    test('validates Spanish plates correctly', () {
      expect(PlateValidator.validate('1234ABC', 'ES'), isTrue);
      expect(PlateValidator.validate('ABC1234', 'ES'), isTrue);
      expect(PlateValidator.validate('123ABC', 'ES'), isFalse);
    });
    
    test('validates French plates correctly', () {
      expect(PlateValidator.validate('AA-123-AA', 'FR'), isTrue);
      expect(PlateValidator.validate('123-AA-123', 'FR'), isFalse);
    });
  });
}
```

#### **✅ Widget Tests**
```dart
// Home screen test
void main() {
  testWidgets('HomeScreen displays correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    
    expect(find.text('PAGAR'), findsOneWidget);
    expect(find.text('ANULAR DENUNCIA'), findsOneWidget);
    expect(find.byIcon(Icons.accessibility), findsOneWidget);
  });
}
```

#### **✅ Integration Tests**
```dart
// Payment flow test
void main() {
  group('Payment Flow Integration', () {
    testWidgets('complete payment flow', (tester) async {
      // 1. Navigate to payment
      await tester.tap(find.text('PAGAR'));
      await tester.pumpAndSettle();
      
      // 2. Select zone
      await tester.tap(find.text('Zona Azul'));
      await tester.pumpAndSettle();
      
      // 3. Enter plate
      await tester.enterText(find.byType(TextField), '1234ABC');
      await tester.tap(find.text('CONTINUAR'));
      await tester.pumpAndSettle();
      
      // 4. Select duration
      await tester.tap(find.text('30 min'));
      await tester.tap(find.text('CONTINUAR'));
      await tester.pumpAndSettle();
      
      // 5. Process payment
      await tester.tap(find.text('PAGAR CON QR'));
      await tester.pumpAndSettle();
      
      // 6. Verify result
      expect(find.text('PAGO EXITOSO'), findsOneWidget);
    });
  });
}
```

#### **✅ Golden Tests**
```dart
// Visual regression tests
void main() {
  group('Golden Tests', () {
    testWidgets('HomeScreen golden test', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      
      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('home_screen.png'),
      );
    });
  });
}
```

### **3. Testing de Accesibilidad**

#### **✅ Accessibility Tests**
```dart
// Accessibility compliance test
void main() {
  testWidgets('meets accessibility requirements', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    
    // Check semantic labels
    expect(find.bySemanticsLabel('Pagar estacionamiento'), findsOneWidget);
    expect(find.bySemanticsLabel('Anular denuncia'), findsOneWidget);
    
    // Check button sizes (minimum 48dp)
    final payButton = find.text('PAGAR');
    final buttonSize = tester.getSize(payButton);
    expect(buttonSize.height, greaterThanOrEqualTo(48));
    expect(buttonSize.width, greaterThanOrEqualTo(48));
  });
}
```

---

## 🚀 **DEVOPS Y DESPLIEGUE**

### **1. CI/CD Pipeline**

#### **✅ GitHub Actions Workflow**
```yaml
name: Kiosk App CI/CD

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
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.0'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter test integration_test/
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3

  build-linux:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build linux
      - run: tar -czf kiosk-app.tar.gz build/linux/x64/release/bundle/
      - uses: actions/upload-artifact@v3
        with:
          name: kiosk-app-linux
          path: kiosk-app.tar.gz

  build-web:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build web
      - uses: actions/upload-artifact@v3
        with:
          name: kiosk-app-web
          path: build/web/
```

### **2. Scripts de Despliegue**

#### **✅ Linux Deployment**
```bash
#!/bin/bash
# deploy_linux.sh

echo "🚀 Desplegando Kiosko Flutter para Linux..."

# Build
flutter build linux --release

# Create AppImage
cd build/linux/x64/release/bundle/
appimagetool . kiosk-app.AppImage

# Deploy to kiosks
scp kiosk-app.AppImage user@kiosk-ip:/opt/kiosk/
ssh user@kiosk-ip "systemctl restart kiosk-app"

echo "✅ Despliegue completado"
```

#### **✅ Web Deployment**
```bash
#!/bin/bash
# deploy_web.sh

echo "🌐 Desplegando Kiosko Flutter para Web..."

# Build
flutter build web --release

# Deploy to CDN
aws s3 sync build/web/ s3://kiosk-app-bucket/
aws cloudfront create-invalidation --distribution-id DISTRIBUTION_ID --paths "/*"

echo "✅ Despliegue web completado"
```

---

## ⚖️ **CUMPLIMIENTO LEGAL**

### **1. Normativas Españolas**

#### **✅ Ley de Tráfico**
- **Artículo 90**: Estacionamiento en vías públicas
- **Artículo 91**: Zonas de estacionamiento regulado
- **Artículo 92**: Tarifas y horarios
- **Artículo 93**: Sistema de denuncias

#### **✅ Protección de Datos (GDPR)**
- **Artículo 6**: Base legal para el tratamiento
- **Artículo 7**: Condiciones para el consentimiento
- **Artículo 13**: Información que debe facilitarse
- **Artículo 32**: Seguridad del tratamiento

### **2. Implementación de Cumplimiento**

#### **✅ Consentimiento de Datos**
```dart
class DataConsentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Protección de Datos'),
          Text('Al usar este kiosko, acepta el tratamiento de sus datos...'),
          CheckboxListTile(
            title: Text('Acepto el tratamiento de datos'),
            value: consentGiven,
            onChanged: (value) => setState(() => consentGiven = value),
          ),
          ElevatedButton(
            onPressed: consentGiven ? () => Navigator.pop() : null,
            child: Text('CONTINUAR'),
          ),
        ],
      ),
    );
  }
}
```

#### **✅ Información Legal**
```dart
class LegalInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Información Legal')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Responsable: MEYPARK IA'),
            Text('Finalidad: Gestión de estacionamiento'),
            Text('Legitimación: Interés legítimo'),
            Text('Derechos: Acceso, rectificación, supresión'),
            Text('Contacto: legal@meypark-ia.com'),
          ],
        ),
      ),
    );
  }
}
```

---

## 📋 **PLAN DE IMPLEMENTACIÓN**

### **Fase 2.1: Configuración Inicial (Semana 1)**
- [ ] Crear proyecto Flutter
- [ ] Configurar dependencias
- [ ] Establecer arquitectura
- [ ] Configurar Supabase
- [ ] Setup CI/CD

### **Fase 2.2: Core Features (Semana 2-3)**
- [ ] Home screen
- [ ] Payment flow
- [ ] Extend session
- [ ] Fines management
- [ ] Basic accessibility

### **Fase 2.3: Advanced Features (Semana 4-5)**
- [ ] Full accessibility
- [ ] Tech mode
- [ ] Remote commands
- [ ] Telemetry
- [ ] Multi-language

### **Fase 2.4: Testing & Polish (Semana 6)**
- [ ] Unit tests
- [ ] Widget tests
- [ ] Integration tests
- [ ] Accessibility tests
- [ ] Performance optimization

### **Fase 2.5: Deployment (Semana 7)**
- [ ] Linux packaging
- [ ] Web build
- [ ] Production deployment
- [ ] Monitoring setup
- [ ] Documentation

---

## 🎯 **MÉTRICAS DE ÉXITO**

### **✅ Funcionalidad**
- **Flujo de pago**: < 30 segundos
- **Tiempo de respuesta**: < 200ms
- **Disponibilidad**: > 99.9%
- **Tasa de error**: < 0.1%

### **✅ Accesibilidad**
- **WCAG 2.1 AA**: 100% compliance
- **TTS coverage**: 100% de textos
- **Keyboard navigation**: 100% funcional
- **Screen reader**: 100% compatible

### **✅ Usabilidad**
- **Tiempo de aprendizaje**: < 2 minutos
- **Tasa de abandono**: < 5%
- **Satisfacción**: > 4.5/5
- **Accesibilidad**: > 4.8/5

---

**🎉 ¡Fase 2 lista para implementar!**

*Última actualización: 21 de Septiembre de 2025*
