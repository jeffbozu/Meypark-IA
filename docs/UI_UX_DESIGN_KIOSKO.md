# 🎨 MEYPARK IA - Diseño UI/UX Kiosko Flutter
**Roles: Frontend + DevOps + QA + Diseño UI/UX**

## 📋 **ÍNDICE**
1. [Accesibilidad Completa](#accesibilidad-completa)
2. [IA Adaptativa](#ia-adaptativa)
3. [Pantallas Detalladas](#pantallas-detalladas)
4. [Variables Supabase](#variables-supabase)
5. [Cumplimiento Legal](#cumplimiento-legal)
6. [Mejores Prácticas UI/UX](#mejores-prácticas-uiux)

---

## ♿ **ACCESIBILIDAD COMPLETA**

### **1. Modo Oscuro y Alto Contraste**

#### **✅ Modo Oscuro**
```dart
// Configuración desde Supabase
{
  "dark_mode": true,
  "colors": {
    "background": "#121212",
    "surface": "#1E1E1E", 
    "primary": "#E62144",
    "text": "#FFFFFF",
    "text_secondary": "#B3B3B3"
  }
}
```

#### **✅ Alto Contraste**
```dart
// Configuración desde Supabase
{
  "high_contrast": true,
  "contrast_ratio": 7.0, // WCAG AAA
  "colors": {
    "background": "#000000",
    "text": "#FFFFFF",
    "buttons": "#FFFFFF",
    "button_text": "#000000"
  }
}
```

**Botón de Info**: "El modo oscuro reduce la fatiga visual en entornos con poca luz. El alto contraste mejora la legibilidad para personas con discapacidades visuales."

### **2. Guía por Voz (TTS)**

#### **✅ Configuración Avanzada**
```dart
// Configuración desde Supabase
{
  "tts_enabled": true,
  "tts_settings": {
    "speed": 0.8,        // 0.5 - 2.0
    "pitch": 1.0,        // 0.5 - 2.0
    "volume": 0.9,       // 0.0 - 1.0
    "language": "es-ES",
    "voice_gender": "female"
  }
}
```

#### **✅ Funcionalidades TTS**
- **Navegación**: "Botón Pagar estacionamiento. Toque para continuar."
- **Instrucciones**: "Introduzca la matrícula del vehículo. Formato: cuatro números seguidos de tres letras."
- **Confirmaciones**: "Pago procesado correctamente. Su ticket ha sido generado."
- **Errores**: "Matrícula no válida. Por favor, verifique el formato."

**Botón de Info**: "La guía por voz proporciona instrucciones auditivas para navegar por la aplicación. Puede ajustar la velocidad, tono y volumen según sus preferencias."

### **3. IA Adaptativa**

#### **✅ Funcionalidades Inteligentes**
```dart
// Configuración desde Supabase
{
  "ai_adaptive": {
    "enabled": true,
    "features": {
      "presets_smart": true,           // Recomendar duraciones
      "pay_reco_last5": true,          // Recomendar método de pago
      "a11y_remember_last5": true,     // Recordar preferencias accesibilidad
      "layout_adaptive_tts": true,     // Ajustar layout según uso
      "queue_mode": true,              // Modo cola en horas pico
      "pay_promotion": true,           // Promocionar métodos de pago
      "maintenance_predictive": true   // Predicción de mantenimiento
    }
  }
}
```

#### **✅ Comportamientos Inteligentes**
- **Presets Inteligentes**: "Basado en sus últimas 5 transacciones, recomendamos 30 minutos"
- **Método de Pago**: "QR es más rápido. EMV falló en las últimas 3 veces"
- **Accesibilidad**: "Aplicando su configuración preferida: Alto contraste + TTS"
- **Modo Cola**: "Hora pico detectada. Interfaz simplificada activada"
- **Predicción**: "Papel bajo (15%). Solicite mantenimiento"

**Botón de Info**: "La IA aprende de su uso para personalizar la experiencia. Sugiere duraciones, métodos de pago y ajusta la interfaz automáticamente."

### **4. Modo Simplificado**

#### **✅ Interfaz Minimalista**
```dart
// Configuración desde Supabase
{
  "simplified_mode": {
    "enabled": true,
    "features": {
      "large_buttons": true,           // Botones 80dp
      "minimal_navigation": true,      // Solo funciones esenciales
      "reduced_animations": true,      // Animaciones mínimas
      "clear_typography": true,        // Tipografía grande y clara
      "single_action_flow": true       // Un solo flujo por pantalla
    }
  }
}
```

**Botón de Info**: "El modo simplificado ofrece una interfaz más sencilla con botones grandes y navegación reducida para facilitar el uso."

---

## 🤖 **IA ADAPTATIVA**

### **1. Sistema de Aprendizaje**

#### **✅ Análisis de Patrones**
```dart
class AIAdaptiveService {
  // Analiza patrones de uso
  Future<void> analyzeUserPatterns() async {
    final lastTransactions = await supabase
      .from('payments')
      .select('*, tickets(*)')
      .eq('device_id', currentDeviceId)
      .order('created_at', ascending: false)
      .limit(5);
    
    // Aprende preferencias
    final preferredDuration = _calculatePreferredDuration(lastTransactions);
    final preferredPaymentMethod = _calculatePreferredPayment(lastTransactions);
    final preferredAccessibility = _calculatePreferredA11y(lastTransactions);
    
    // Aplica recomendaciones
    await _applyRecommendations(
      preferredDuration,
      preferredPaymentMethod,
      preferredAccessibility,
    );
  }
}
```

#### **✅ Recomendaciones Inteligentes**
```dart
class AIRecommendations {
  // Recomendar duración basada en historial
  String recommendDuration(List<Payment> history) {
    final avgDuration = history.map((p) => p.duration).reduce((a, b) => a + b) / history.length;
    final timeOfDay = DateTime.now().hour;
    
    if (timeOfDay >= 8 && timeOfDay <= 10) return "30 min"; // Mañana
    if (timeOfDay >= 14 && timeOfDay <= 16) return "60 min"; // Tarde
    if (timeOfDay >= 18 && timeOfDay <= 20) return "120 min"; // Noche
    
    return "30 min"; // Default
  }
  
  // Recomendar método de pago
  String recommendPaymentMethod(List<Payment> history) {
    final recentFailures = history.where((p) => p.status == 'failed').length;
    final qrSuccess = history.where((p) => p.provider == 'qr' && p.status == 'succeeded').length;
    
    if (recentFailures > 2) return "qr"; // QR más confiable
    if (qrSuccess > 3) return "qr"; // QR funciona bien
    
    return "emv"; // EMV por defecto
  }
}
```

### **2. Personalización Automática**

#### **✅ Ajustes Dinámicos**
```dart
class AdaptiveUI {
  // Ajustar interfaz según uso
  Future<void> adaptInterface() async {
    final usageStats = await supabase
      .from('usage_stats')
      .select('*')
      .eq('device_id', currentDeviceId)
      .order('ts', ascending: false)
      .limit(10);
    
    // Detectar patrones
    final errorRate = _calculateErrorRate(usageStats);
    final avgSessionTime = _calculateAvgSessionTime(usageStats);
    final accessibilityUsage = _calculateA11yUsage(usageStats);
    
    // Aplicar ajustes
    if (errorRate > 0.3) {
      await _enableSimplifiedMode();
      await _enableTTS();
    }
    
    if (avgSessionTime > 300) { // 5 minutos
      await _enableQueueMode();
    }
    
    if (accessibilityUsage > 0.7) {
      await _enableAdaptiveLayout();
    }
  }
}
```

---

## 📱 **PANTALLAS DETALLADAS**

### **1. 🏠 Pantalla Principal (Home)**

#### **✅ Contenido**
```
┌─────────────────────────────────┐
│ [Logo] [Hora] [Idioma] [♿] [ℹ️] │
├─────────────────────────────────┤
│                                 │
│        [PAGAR]                  │
│      (Botón 80dp)               │
│                                 │
│     [ANULAR DENUNCIA]           │
│      (Botón 80dp)               │
│                                 │
│                                 │
└─────────────────────────────────┘
```

#### **✅ Variables Supabase**
```sql
-- Temas
UPDATE themes SET colors_json = '{
  "appbar_bg": "#E62144",
  "body_bg": "#FFFFFF",
  "button_pay_bg": "#4CAF50",
  "button_cancel_bg": "#F44336"
}' WHERE scope = 'initial_screen';

-- Visibilidad
UPDATE ui_overrides SET visibility_json = '{
  "show_pay": true,
  "show_cancel": true,
  "show_a11y": true
}' WHERE scope = 'initial_screen';

-- Textos
UPDATE ui_overrides SET text_overrides_json = '{
  "appbar_phrase": "Bienvenido a MEYPARK",
  "button_pay_text": "PAGAR ESTACIONAMIENTO",
  "button_cancel_text": "ANULAR DENUNCIA"
}' WHERE scope = 'initial_screen';
```

### **2. 💳 Flujo de Pago**

#### **2.1 Zona (Zone Picker)**
```
┌─────────────────────────────────┐
│ [←] Seleccione Zona    [♿] [ℹ️] │
├─────────────────────────────────┤
│                                 │
│  [ZONA AZUL] [ZONA VERDE]       │
│   Centro      Residencial       │
│   0.50€/min   0.30€/min         │
│                                 │
│  [ZONA AMARILLA]                │
│   Carga/Descarga                │
│   0.20€/min                     │
│                                 │
└─────────────────────────────────┘
```

#### **2.2 Matrícula (Plate Input)**
```
┌─────────────────────────────────┐
│ [←] Matrícula del Vehículo      │
├─────────────────────────────────┤
│                                 │
│  País: [ES ▼] [FR] [DE] [IT]    │
│                                 │
│  [1] [2] [3] [4] [5] [6] [7]    │
│  [8] [9] [0] [A] [B] [C] [D]    │
│  [E] [F] [G] [H] [I] [J] [K]    │
│  [L] [M] [N] [Ñ] [O] [P] [Q]    │
│  [R] [S] [T] [U] [V] [W] [X]    │
│  [Y] [Z] [←] [✓]                │
│                                 │
│  Matrícula: [1234ABC]           │
│                                 │
│        [CONTINUAR]              │
└─────────────────────────────────┘
```

#### **2.3 Duración (Duration)**
```
┌─────────────────────────────────┐
│ [←] Duración del Estacionamiento│
├─────────────────────────────────┤
│                                 │
│  [15min] [30min] [60min] [120min]│
│  2.50€   5.00€   10.00€  20.00€ │
│                                 │
│  [−] [30 min] [+]               │
│                                 │
│  Hora fin: 14:30                │
│  Importe: 5.00€                 │
│                                 │
│  🤖 Recomendado: 30 min         │
│                                 │
│        [CONTINUAR]              │
└─────────────────────────────────┘
```

#### **2.4 Pago (Payment)**
```
┌─────────────────────────────────┐
│ [←] Método de Pago              │
├─────────────────────────────────┤
│                                 │
│  [GOOGLE PAY] [APPLE PAY]       │
│   Rápido y seguro               │
│                                 │
│  [QR CODE] [EMV] [MONEDAS]      │
│   Escanee aquí   Tarjeta        │
│                                 │
│  Importe: 5.00€                 │
│  Duración: 30 min               │
│  Zona: Azul Centro              │
│                                 │
│  🤖 Recomendado: QR Code        │
│                                 │
│        [PAGAR]                  │
└─────────────────────────────────┘
```

#### **2.5 Resultado (Result)**
```
┌─────────────────────────────────┐
│ [✓] Pago Exitoso                │
├─────────────────────────────────┤
│                                 │
│  Matrícula: 1234ABC             │
│  Zona: Azul Centro              │
│  Duración: 30 min               │
│  Hora fin: 14:30                │
│                                 │
│  [QR CODE]                      │
│  Escanee para verificar         │
│                                 │
│  [IMPRIMIR] [ENVIAR EMAIL]      │
│                                 │
│        [INICIO]                 │
└─────────────────────────────────┘
```

### **3. ♿ Panel de Accesibilidad**

#### **✅ Contenido Completo**
```
┌─────────────────────────────────┐
│ [←] Configuración de Accesibilidad│
├─────────────────────────────────┤
│                                 │
│  👁️ VER                         │
│  [ ] Modo Oscuro    [ℹ️]        │
│  [✓] Alto Contraste [ℹ️]        │
│  Tamaño: [100%] [125%] [150%]   │
│                                 │
│  🔊 ESCUCHAR                     │
│  [✓] Guía por Voz   [ℹ️]        │
│  Velocidad: [●────] 0.8         │
│  Tono: [●────] 1.0              │
│  Volumen: [●●●●●] 0.9           │
│                                 │
│  ⌨️ INTRODUCIR                   │
│  [✓] Entrada por Voz [ℹ️]       │
│  [✓] Teclado XL     [ℹ️]        │
│  [✓] Lectura Fácil  [ℹ️]        │
│                                 │
│  ⏰ TIEMPO                       │
│  [✓] Ampliar Tiempo [ℹ️]        │
│  Pausas: [x2] [x4]              │
│                                 │
│  🌍 IDIOMA                       │
│  [ES ▼] [EN] [DE] [FR] [IT]     │
│  [ca-ES] [gl-ES] [eu-ES]        │
│                                 │
│  🤖 IA ADAPTATIVA               │
│  [✓] Presets Inteligentes [ℹ️]  │
│  [✓] Recordar Preferencias [ℹ️] │
│  [✓] Layout Adaptativo [ℹ️]     │
│  [✓] Modo Cola [ℹ️]             │
│  [✓] Predicción Mantenimiento [ℹ️]│
│                                 │
│        [APLICAR]                │
└─────────────────────────────────┘
```

#### **✅ Variables Supabase**
```sql
-- Configuración de accesibilidad
UPDATE ai_settings SET 
  a11y_remember_last5 = true,
  layout_adaptive_tts = true,
  presets_smart = true,
  queue_mode = true,
  maintenance_predictive = true
WHERE device_id = 'uuid-dispositivo';

-- Preferencias de usuario
INSERT INTO accessibility_prefs (device_id, combo_json) VALUES 
('uuid-dispositivo', '{
  "dark_mode": false,
  "high_contrast": true,
  "text_size": 125,
  "tts_enabled": true,
  "tts_speed": 0.8,
  "tts_pitch": 1.0,
  "tts_volume": 0.9,
  "voice_input": true,
  "large_keyboard": true,
  "extended_time": true,
  "time_multiplier": 2
}');
```

### **4. 🔧 Modo Técnico**

#### **✅ Contenido**
```
┌─────────────────────────────────┐
│ [←] Modo Técnico                │
├─────────────────────────────────┤
│                                 │
│  📊 ESTADO DEL SISTEMA          │
│  Versión: 1.0.0                 │
│  Uptime: 2d 14h 32m             │
│  Energía: 85%                   │
│  Señal: -45 dBm                 │
│  Temperatura: 42°C              │
│  Papel: 78%                     │
│  EMV: Conectado                 │
│  Monedero: 15€                  │
│                                 │
│  🧪 PRUEBAS                     │
│  [Imprimir Test] [Ping EMV]     │
│  [Leer Escáner] [Recargar Tarifas]│
│  [Captura Pantalla] [Reiniciar UI]│
│                                 │
│  📋 LOGS                        │
│  [Ver Logs] [Exportar]          │
│                                 │
│  🔧 MANTENIMIENTO               │
│  [Papel Repuesto] [Batería Cambiada]│
│  [Limpieza Realizada] [Calibración]│
│                                 │
│        [SALIR]                  │
└─────────────────────────────────┘
```

### **5. 🔐 Login Oculto**

#### **✅ Contenido**
```
┌─────────────────────────────────┐
│ [←] Acceso Técnico              │
├─────────────────────────────────┤
│                                 │
│  Empresa: [MOWIZ ▼] [EYPSA]     │
│                                 │
│  Email: [admin@mowiz.com]       │
│  Contraseña: [••••••••]         │
│                                 │
│  [ ] Recordar sesión            │
│                                 │
│        [ENTRAR]                 │
│                                 │
│  [Cambiar Empresa] [Configurar] │
│                                 │
└─────────────────────────────────┘
```

---

## ⚙️ **VARIABLES SUPABASE**

### **1. 🎨 Temas y Colores**
```sql
-- Cambiar colores de la app
UPDATE themes SET colors_json = '{
  "appbar_bg": "#E62144",
  "body_bg": "#FFFFFF",
  "button_pay_bg": "#4CAF50",
  "button_cancel_bg": "#F44336",
  "text_primary": "#000000",
  "text_secondary": "#666666",
  "icon_tint": "#7F7F7F",
  "success_color": "#4CAF50",
  "warning_color": "#FF9800",
  "error_color": "#F44336"
}' WHERE company_id = 'uuid-empresa' AND scope = 'default_ui';
```

### **2. 👁️ Visibilidad de Elementos**
```sql
-- Mostrar/ocultar botones
UPDATE ui_overrides SET visibility_json = '{
  "show_pay": true,
  "show_cancel": true,
  "show_extend": true,
  "show_qr": true,
  "show_a11y": true,
  "show_tech_mode": false,
  "show_hidden_login": true
}' WHERE company_id = 'uuid-empresa' AND scope = 'default_ui';
```

### **3. 📝 Textos y Mensajes**
```sql
-- Cambiar textos de la app
UPDATE ui_overrides SET text_overrides_json = '{
  "appbar_phrase": "Bienvenido a MEYPARK",
  "button_pay_text": "PAGAR ESTACIONAMIENTO",
  "button_cancel_text": "ANULAR DENUNCIA",
  "welcome_message": "Seleccione una opción",
  "error_invalid_plate": "Matrícula no válida",
  "success_payment": "Pago procesado correctamente"
}' WHERE company_id = 'uuid-empresa' AND scope = 'default_ui';
```

### **4. 🏢 Zonas y Tarifas**
```sql
-- Configurar zonas
UPDATE zones SET 
  name = 'Zona Azul Centro',
  color = '#2196F3',
  schedule_json = '{
    "monday": {"start": "09:00", "end": "20:00"},
    "tuesday": {"start": "09:00", "end": "20:00"},
    "wednesday": {"start": "09:00", "end": "20:00"},
    "thursday": {"start": "09:00", "end": "20:00"},
    "friday": {"start": "09:00", "end": "20:00"},
    "saturday": {"start": "09:00", "end": "14:00"},
    "sunday": {"start": "10:00", "end": "14:00"}
  }'
WHERE company_id = 'uuid-empresa';

-- Configurar tarifas
UPDATE tariffs SET 
  price_per_min_cents = 50,  -- 0.50€ por minuto
  min_minutes = 15,
  max_minutes = 120,
  step_minutes = 5,
  presets_json = '[15, 30, 60, 120]'
WHERE zone_id = 'uuid-zona';
```

### **5. 🎛️ Feature Flags**
```sql
-- Activar/desactivar funcionalidades
INSERT INTO feature_flags (company_id, key, value_json) VALUES 
('uuid-empresa', 'hidden_login_enabled', 'true'),
('uuid-empresa', 'tech_mode_enabled', 'true'),
('uuid-empresa', 'ai_adaptive_enabled', 'true'),
('uuid-empresa', 'voice_input_enabled', 'true'),
('uuid-empresa', 'simplified_mode_enabled', 'true'),
('uuid-empresa', 'offline_mode_enabled', 'true');
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

### **2. Accesibilidad (Ley 51/2003)**

#### **✅ Requisitos Mínimos**
- **WCAG 2.1 AA**: Cumplimiento completo
- **Ratio de contraste**: 4.5:1 mínimo
- **Tamaño de botones**: 44px mínimo
- **Navegación por teclado**: 100% funcional
- **Lectores de pantalla**: Compatibilidad total

---

## 🎨 **MEJORES PRÁCTICAS UI/UX**

### **1. Diseño Moderno y Elegante**

#### **✅ Principios de Diseño**
- **Material Design 3**: Componentes modernos
- **Espaciado consistente**: 8dp grid system
- **Tipografía clara**: Inter/Noto Sans
- **Colores accesibles**: Paleta contrastada
- **Animaciones suaves**: 200-300ms

#### **✅ Hover y Transiciones**
```dart
// Transiciones suaves
AnimatedContainer(
  duration: Duration(milliseconds: 200),
  curve: Curves.easeInOut,
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Text('PAGAR'),
  ),
)

// Hover effects (Web)
MouseRegion(
  onEnter: (_) => setState(() => isHovered = true),
  onExit: (_) => setState(() => isHovered = false),
  child: AnimatedScale(
    scale: isHovered ? 1.05 : 1.0,
    duration: Duration(milliseconds: 150),
    child: ElevatedButton(...),
  ),
)
```

### **2. Accesibilidad Avanzada**

#### **✅ Semántica Completa**
```dart
Semantics(
  label: 'Pagar estacionamiento',
  hint: 'Toque para iniciar el proceso de pago',
  button: true,
  child: ElevatedButton(
    onPressed: () {},
    child: Text('PAGAR'),
  ),
)
```

#### **✅ Navegación por Teclado**
```dart
Focus(
  autofocus: true,
  onKeyEvent: (node, event) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      // Procesar acción
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  },
  child: ElevatedButton(...),
)
```

---

## 🎯 **MÉTRICAS DE ÉXITO**

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

### **✅ IA Adaptativa**
- **Precisión recomendaciones**: > 80%
- **Tiempo de adaptación**: < 5 transacciones
- **Satisfacción personalización**: > 4.0/5

---

**🎉 ¡Diseño UI/UX completo y moderno para el kiosko MEYPARK IA!**

*Última actualización: 21 de Septiembre de 2025*
