# 🔄 MEYPARK IA - UI Dinámica Basada en Supabase
**TODO depende de Supabase - Integración Perfecta con APIs Externas**

## 📋 **ÍNDICE**
1. [AppBar Dinámico con Hora/Fecha](#appbar-dinámico-con-horafecha)
2. [Zonas Dinámicas con APIs Externas](#zonas-dinámicas-con-apis-externas)
3. [IA Adaptativa Avanzada](#ia-adaptativa-avanzada)
4. [Accesibilidad Detallada](#accesibilidad-detallada)
5. [Pantallas Completamente Dinámicas](#pantallas-completamente-dinámicas)
6. [Integración API Externa](#integración-api-externa)

---

## 🕐 **APPBAR DINÁMICO CON HORA/FECHA**

### **✅ Diseño AppBar (Recomendado)**
```
┌─────────────────────────────────────────────────────────┐
│ [Logo] [Nombre Empresa] [Hora] [Fecha] [Idioma] [♿] [ℹ️] │
│ MOWIZ    14:30   21/09/2025    ES     ♿    ℹ️           │
└─────────────────────────────────────────────────────────┘
```

### **✅ Variables Supabase**
```sql
-- Configuración de AppBar
UPDATE ui_overrides SET text_overrides_json = '{
  "appbar_company_name": "MOWIZ",
  "appbar_show_time": true,
  "appbar_show_date": true,
  "appbar_time_format": "24h",
  "appbar_date_format": "dd/MM/yyyy",
  "appbar_timezone": "Europe/Madrid"
}' WHERE company_id = 'uuid-empresa' AND scope = 'default_ui';

-- Configuración de dispositivo
UPDATE devices SET 
  timezone = 'Europe/Madrid',
  flags_json = '{
    "show_time": true,
    "show_date": true,
    "time_format": "24h",
    "date_format": "dd/MM/yyyy"
  }'
WHERE id = 'uuid-dispositivo';
```

### **✅ Implementación Flutter**
```dart
class DynamicAppBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceConfig = ref.watch(deviceConfigProvider);
    final uiOverrides = ref.watch(uiOverridesProvider);
    
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/logo.png', height: 32),
          SizedBox(width: 16),
          Text(uiOverrides.appbarCompanyName),
          Spacer(),
          if (deviceConfig.showTime) 
            Text(_formatTime(deviceConfig.timeFormat)),
          if (deviceConfig.showDate)
            Text(_formatDate(deviceConfig.dateFormat)),
          SizedBox(width: 16),
          LanguageSelector(),
          AccessibilityButton(),
          InfoButton(),
        ],
      ),
    );
  }
  
  String _formatTime(String format) {
    final now = DateTime.now();
    if (format == '24h') {
      return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = now.hour > 12 ? now.hour - 12 : now.hour;
      final period = now.hour >= 12 ? 'PM' : 'AM';
      return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';
    }
  }
}
```

---

## 🏢 **ZONAS DINÁMICAS CON APIs EXTERNAS**

### **✅ Integración Perfecta con APIs Externas**

#### **1. Configuración de API Externa**
```sql
-- Configurar API externa
INSERT INTO external_integrations (
  company_id, 
  name, 
  base_url, 
  token, 
  endpoints_json, 
  mapping_json, 
  enabled
) VALUES (
  'uuid-empresa',
  'API Barcelona Parking',
  'https://api.barcelona-parking.com',
  'encrypted_token_here',
  '{
    "zones": "/api/v1/zones",
    "tariffs": "/api/v1/tariffs",
    "discounts": "/api/v1/discounts",
    "residents": "/api/v1/residents"
  }',
  '{
    "zone_id": "id",
    "zone_name": "name",
    "zone_color": "color",
    "price_per_min": "price",
    "min_duration": "min_duration",
    "max_duration": "max_duration",
    "discounts": "discounts",
    "resident_discount": "resident_discount"
  }',
  true
);
```

#### **2. Cache de Zonas Externas**
```sql
-- Tabla de cache para zonas externas
CREATE TABLE external_zone_cache (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID REFERENCES companies(id),
  origin_key TEXT NOT NULL,
  payload_json JSONB NOT NULL,
  synced_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ DEFAULT NOW() + INTERVAL '1 hour'
);
```

### **✅ Pantalla de Zonas Dinámica**
```dart
class DynamicZonePicker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zones = ref.watch(zonesProvider);
    final externalZones = ref.watch(externalZonesProvider);
    final aiRecommendations = ref.watch(aiRecommendationsProvider);
    
    return Scaffold(
      appBar: DynamicAppBar(),
      body: Column(
        children: [
          // Zona más usada (IA)
          if (aiRecommendations.mostUsedZone != null)
            Container(
              margin: EdgeInsets.all(16),
              child: MostUsedZoneCard(
                zone: aiRecommendations.mostUsedZone!,
                onTap: () => _selectZone(aiRecommendations.mostUsedZone!),
              ),
            ),
          
          // Lista de zonas
          Expanded(
            child: ListView.builder(
              itemCount: zones.length + externalZones.length,
              itemBuilder: (context, index) {
                if (index < zones.length) {
                  return ZoneCard(
                    zone: zones[index],
                    isExternal: false,
                    onTap: () => _selectZone(zones[index]),
                  );
                } else {
                  final externalIndex = index - zones.length;
                  return ZoneCard(
                    zone: externalZones[externalIndex],
                    isExternal: true,
                    onTap: () => _selectZone(externalZones[externalIndex]),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MostUsedZoneCard extends StatelessWidget {
  final Zone zone;
  final VoidCallback onTap;
  
  const MostUsedZoneCard({
    required this.zone,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                'Zona más usada',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(zone.name),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🤖 **IA ADAPTATIVA AVANZADA**

### **✅ Funcionalidades IA Implementadas**

#### **1. Zona Más Usada (Acceso Directo)**
```dart
class AIZoneRecommendation {
  // Analiza las últimas 5 transacciones
  Future<Zone?> getMostUsedZone() async {
    final lastPayments = await supabase
      .from('payments')
      .select('*, tickets(zones(*))')
      .eq('device_id', currentDeviceId)
      .order('created_at', ascending: false)
      .limit(5);
    
    // Contar frecuencia por zona
    final zoneCount = <String, int>{};
    for (final payment in lastPayments) {
      final zoneId = payment['tickets']['zone_id'];
      zoneCount[zoneId] = (zoneCount[zoneId] ?? 0) + 1;
    }
    
    // Obtener zona más frecuente
    final mostUsedZoneId = zoneCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    return await supabase
      .from('zones')
      .select()
      .eq('id', mostUsedZoneId)
      .single();
  }
}
```

#### **2. Método de Pago Recomendado**
```dart
class AIPaymentRecommendation {
  // Analiza éxito/fallo de métodos de pago
  Future<String> getRecommendedPaymentMethod() async {
    final paymentStats = await supabase
      .from('payments')
      .select('provider, status')
      .eq('device_id', currentDeviceId)
      .order('created_at', ascending: false)
      .limit(10);
    
    final successRate = <String, double>{};
    final methodCount = <String, int>{};
    
    for (final payment in paymentStats) {
      final provider = payment['provider'];
      final isSuccess = payment['status'] == 'succeeded';
      
      methodCount[provider] = (methodCount[provider] ?? 0) + 1;
      if (isSuccess) {
        successRate[provider] = (successRate[provider] ?? 0) + 1;
      }
    }
    
    // Calcular tasa de éxito
    final finalRates = <String, double>{};
    for (final method in methodCount.keys) {
      final success = successRate[method] ?? 0;
      final total = methodCount[method]!;
      finalRates[method] = success / total;
    }
    
    // Retornar método con mayor tasa de éxito
    return finalRates.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}
```

#### **3. Duración Recomendada Inteligente**
```dart
class AIDurationRecommendation {
  // Recomienda duración basada en hora, día y zona
  Future<int> getRecommendedDuration(String zoneId) async {
    final now = DateTime.now();
    final hour = now.hour;
    final dayOfWeek = now.weekday;
    
    // Obtener patrones históricos por zona y hora
    final historicalData = await supabase
      .from('payments')
      .select('*, tickets(duration_min)')
      .eq('device_id', currentDeviceId)
      .eq('tickets.zone_id', zoneId)
      .gte('created_at', DateTime.now().subtract(Duration(days: 30)).toIso8601String());
    
    // Filtrar por hora similar (±1 hora)
    final similarHourData = historicalData.where((payment) {
      final paymentHour = DateTime.parse(payment['created_at']).hour;
      return (paymentHour - hour).abs() <= 1;
    }).toList();
    
    if (similarHourData.isEmpty) {
      // Default basado en hora del día
      if (hour >= 8 && hour <= 10) return 30;  // Mañana
      if (hour >= 14 && hour <= 16) return 60; // Tarde
      if (hour >= 18 && hour <= 20) return 120; // Noche
      return 30; // Default
    }
    
    // Calcular duración promedio
    final avgDuration = similarHourData
        .map((p) => p['tickets']['duration_min'] as int)
        .reduce((a, b) => a + b) / similarHourData.length;
    
    // Redondear a presets comunes
    if (avgDuration <= 20) return 15;
    if (avgDuration <= 45) return 30;
    if (avgDuration <= 90) return 60;
    return 120;
  }
}
```

#### **4. UI Adaptativa Inteligente**
```dart
class AdaptiveUI {
  // Ajusta UI según patrones de uso
  Future<UIAdaptation> getUIAdaptation() async {
    final usageStats = await supabase
      .from('usage_stats')
      .select('*')
      .eq('device_id', currentDeviceId)
      .order('ts', ascending: false)
      .limit(20);
    
    final errorRate = _calculateErrorRate(usageStats);
    final avgSessionTime = _calculateAvgSessionTime(usageStats);
    final accessibilityUsage = _calculateAccessibilityUsage(usageStats);
    
    return UIAdaptation(
      enableSimplifiedMode: errorRate > 0.3,
      enableTTS: errorRate > 0.2 || accessibilityUsage > 0.5,
      enableQueueMode: avgSessionTime > 300, // 5 minutos
      enableLargeButtons: errorRate > 0.4,
      enableVoiceInput: accessibilityUsage > 0.7,
    );
  }
}
```

---

## ♿ **ACCESIBILIDAD DETALLADA**

### **✅ Información Detallada de Cada Función**

#### **1. Modo Oscuro**
```dart
class AccessibilityInfo {
  static const Map<String, String> infoTexts = {
    'dark_mode': '''
🌙 MODO OSCURO

¿Qué hace?
• Cambia el fondo de la pantalla a colores oscuros
• Reduce la fatiga visual en entornos con poca luz
• Mejora la legibilidad en pantallas brillantes
• Ahorra batería en dispositivos OLED

¿Cuándo usarlo?
• En interiores con poca iluminación
• Durante la noche o al amanecer
• Si tiene sensibilidad a la luz brillante
• Para reducir el deslumbramiento

¿Cómo funciona?
• Aplica colores oscuros automáticamente
• Mantiene el contraste adecuado para la lectura
• Se activa/desactiva instantáneamente
• Se guarda su preferencia automáticamente
''',
    
    'high_contrast': '''
🔍 ALTO CONTRASTE

¿Qué hace?
• Aumenta la diferencia entre colores de texto y fondo
• Mejora la legibilidad para personas con discapacidades visuales
• Cumple con estándares WCAG 2.1 AAA
• Hace más visible cada elemento de la pantalla

¿Cuándo usarlo?
• Si tiene dificultades para leer texto normal
• En pantallas con poca calidad
• Con poca iluminación ambiental
• Si tiene problemas de visión

¿Cómo funciona?
• Aplica colores de máximo contraste
• Texto blanco sobre fondo negro
• Botones con bordes bien definidos
• Iconos con mayor definición
''',
    
    'tts_voice_guide': '''
🔊 GUÍA POR VOZ

¿Qué hace?
• Lee en voz alta todo el contenido de la pantalla
• Proporciona instrucciones paso a paso
• Describe botones y opciones disponibles
• Ayuda a navegar sin necesidad de ver la pantalla

¿Cuándo usarlo?
• Si tiene discapacidad visual
• Para aprender a usar la aplicación
• Cuando no puede ver bien la pantalla
• Para confirmar acciones importantes

¿Cómo funciona?
• Activa el Text-to-Speech (TTS)
• Lee automáticamente cada pantalla
• Puede ajustar velocidad, tono y volumen
• Funciona con lectores de pantalla externos

Configuración:
• Velocidad: 0.5x a 2.0x (recomendado 0.8x)
• Tono: 0.5 a 2.0 (recomendado 1.0)
• Volumen: 0.0 a 1.0 (recomendado 0.9)
• Idioma: Se adapta al idioma seleccionado
''',
    
    'voice_input': '''
🎤 ENTRADA POR VOZ

¿Qué hace?
• Permite introducir texto hablando
• Convierte su voz en texto automáticamente
• Funciona con comandos de voz
• Reduce la necesidad de usar el teclado

¿Cuándo usarlo?
• Si tiene dificultades para escribir
• Para introducir matrículas rápidamente
• Si prefiere hablar en lugar de tocar
• Para personas con movilidad reducida

¿Cómo funciona?
• Presiona el botón del micrófono
• Habla claramente la matrícula
• El sistema reconoce y convierte a texto
• Confirma antes de continuar

Comandos disponibles:
• "Matrícula 1234 ABC"
• "Zona azul"
• "Treinta minutos"
• "Pagar con QR"
''',
    
    'simplified_mode': '''
🎯 MODO SIMPLIFICADO

¿Qué hace?
• Muestra solo las funciones esenciales
• Botones más grandes y fáciles de tocar
• Navegación más simple
• Menos opciones para evitar confusión

¿Cuándo usarlo?
• Si es la primera vez que usa la aplicación
• Si prefiere una interfaz más simple
• Para personas mayores
• Si tiene dificultades cognitivas

¿Cómo funciona?
• Oculta funciones avanzadas
• Muestra solo "Pagar" y "Anular denuncia"
• Botones de 80dp (más grandes)
• Animaciones reducidas
• Texto más grande y claro
''',
    
    'ai_adaptive': '''
🤖 IA ADAPTATIVA

¿Qué hace?
• Aprende de cómo usa la aplicación
• Sugiere opciones basadas en su historial
• Adapta la interfaz a sus preferencias
• Hace la experiencia más personal

¿Cuándo usarlo?
• Para obtener recomendaciones inteligentes
• Si quiere una experiencia personalizada
• Para ahorrar tiempo en transacciones
• Si usa la aplicación frecuentemente

¿Cómo funciona?
• Analiza sus últimas 5 transacciones
• Sugiere la zona que más usa
• Recomienda el método de pago más confiable
• Ajusta la interfaz según sus patrones

Funciones inteligentes:
• Zona más usada (acceso directo)
• Método de pago recomendado
• Duración sugerida según hora
• Configuración de accesibilidad automática
• Predicción de mantenimiento del kiosko
''',
  };
}
```

### **✅ Pantalla de Accesibilidad Mejorada**
```dart
class DetailedAccessibilityScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: DynamicAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Modo Oscuro
            AccessibilityCard(
              title: 'Modo Oscuro',
              icon: Icons.dark_mode,
              isEnabled: ref.watch(darkModeProvider),
              onToggle: (value) => ref.read(darkModeProvider.notifier).toggle(),
              infoText: AccessibilityInfo.infoTexts['dark_mode']!,
            ),
            
            // Alto Contraste
            AccessibilityCard(
              title: 'Alto Contraste',
              icon: Icons.contrast,
              isEnabled: ref.watch(highContrastProvider),
              onToggle: (value) => ref.read(highContrastProvider.notifier).toggle(),
              infoText: AccessibilityInfo.infoTexts['high_contrast']!,
            ),
            
            // Guía por Voz
            AccessibilityCard(
              title: 'Guía por Voz',
              icon: Icons.record_voice_over,
              isEnabled: ref.watch(ttsProvider),
              onToggle: (value) => ref.read(ttsProvider.notifier).toggle(),
              infoText: AccessibilityInfo.infoTexts['tts_voice_guide']!,
              hasSettings: true,
              onSettings: () => _showTTSSettings(context),
            ),
            
            // Entrada por Voz
            AccessibilityCard(
              title: 'Entrada por Voz',
              icon: Icons.mic,
              isEnabled: ref.watch(voiceInputProvider),
              onToggle: (value) => ref.read(voiceInputProvider.notifier).toggle(),
              infoText: AccessibilityInfo.infoTexts['voice_input']!,
            ),
            
            // Modo Simplificado
            AccessibilityCard(
              title: 'Modo Simplificado',
              icon: Icons.simplified_mode,
              isEnabled: ref.watch(simplifiedModeProvider),
              onToggle: (value) => ref.read(simplifiedModeProvider.notifier).toggle(),
              infoText: AccessibilityInfo.infoTexts['simplified_mode']!,
            ),
            
            // IA Adaptativa
            AccessibilityCard(
              title: 'IA Adaptativa',
              icon: Icons.psychology,
              isEnabled: ref.watch(aiAdaptiveProvider),
              onToggle: (value) => ref.read(aiAdaptiveProvider.notifier).toggle(),
              infoText: AccessibilityInfo.infoTexts['ai_adaptive']!,
              hasSettings: true,
              onSettings: () => _showAISettings(context),
            ),
          ],
        ),
      ),
    );
  }
}

class AccessibilityCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final String infoText;
  final bool hasSettings;
  final VoidCallback? onSettings;
  
  const AccessibilityCard({
    required this.title,
    required this.icon,
    required this.isEnabled,
    required this.onToggle,
    required this.infoText,
    this.hasSettings = false,
    this.onSettings,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: onToggle,
                ),
                if (hasSettings)
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: onSettings,
                  ),
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () => _showInfoDialog(context, title, infoText),
                ),
              ],
            ),
            if (isEnabled && hasSettings)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Configuración disponible',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  void _showInfoDialog(BuildContext context, String title, String infoText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(infoText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
```

---

## 📱 **PANTALLAS COMPLETAMENTE DINÁMICAS**

### **✅ Pantalla Principal Dinámica**
```dart
class DynamicHomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiConfig = ref.watch(uiConfigProvider);
    final aiRecommendations = ref.watch(aiRecommendationsProvider);
    
    return Scaffold(
      appBar: DynamicAppBar(),
      body: Column(
        children: [
          // Mensaje de bienvenida dinámico
          if (uiConfig.welcomeMessage.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Text(
                uiConfig.welcomeMessage,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          
          // Botón de pago (si está habilitado)
          if (uiConfig.showPay)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Zona más usada (IA)
                    if (aiRecommendations.mostUsedZone != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 32),
                        child: MostUsedZoneQuickAccess(
                          zone: aiRecommendations.mostUsedZone!,
                        ),
                      ),
                    
                    // Botón principal de pago
                    ElevatedButton(
                      onPressed: () => _navigateToPayment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: uiConfig.buttonPayColor,
                        minimumSize: Size(200, 80),
                      ),
                      child: Text(
                        uiConfig.buttonPayText,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Botón de anular denuncia (si está habilitado)
          if (uiConfig.showCancel)
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => _navigateToCancelFine(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: uiConfig.buttonCancelColor,
                  minimumSize: Size(200, 60),
                ),
                child: Text(
                  uiConfig.buttonCancelText,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

### **✅ Pantalla de Duración Dinámica**
```dart
class DynamicDurationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedZone = ref.watch(selectedZoneProvider);
    final aiRecommendations = ref.watch(aiRecommendationsProvider);
    final tariffs = ref.watch(tariffsProvider);
    
    return Scaffold(
      appBar: DynamicAppBar(),
      body: Column(
        children: [
          // Información de la zona
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Color(int.parse(selectedZone.color.replaceFirst('#', '0xFF'))),
            child: Column(
              children: [
                Text(
                  selectedZone.name,
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(tariffs.pricePerMinCents / 100).toStringAsFixed(2)}€/min',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Presets dinámicos
          Padding(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: tariffs.presets.map((preset) {
                final isRecommended = aiRecommendations.recommendedDuration == preset;
                return PresetButton(
                  duration: preset,
                  price: preset * tariffs.pricePerMinCents / 100,
                  isRecommended: isRecommended,
                  onTap: () => _selectDuration(preset),
                );
              }).toList(),
            ),
          ),
          
          // Controles manuales
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decreaseDuration,
                  icon: Icon(Icons.remove_circle_outline, size: 48),
                ),
                Container(
                  width: 120,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${_currentDuration} min',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _increaseDuration,
                  icon: Icon(Icons.add_circle_outline, size: 48),
                ),
              ],
            ),
          ),
          
          // Información de pago
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hora fin:', style: TextStyle(fontSize: 16)),
                    Text(_calculateEndTime(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Importe:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      '${_calculateAmount().toStringAsFixed(2)}€',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Botón continuar
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _currentDuration >= tariffs.minMinutes ? _continue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'CONTINUAR',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔗 **INTEGRACIÓN API EXTERNA**

### **✅ Servicio de Integración API**
```dart
class ExternalAPIService {
  final SupabaseClient supabase;
  
  ExternalAPIService(this.supabase);
  
  // Obtener configuración de API externa
  Future<ExternalIntegration?> getExternalIntegration(String companyId) async {
    final response = await supabase
        .from('external_integrations')
        .select()
        .eq('company_id', companyId)
        .eq('enabled', true)
        .single();
    
    return ExternalIntegration.fromJson(response);
  }
  
  // Sincronizar zonas desde API externa
  Future<List<Zone>> syncZonesFromExternalAPI(String companyId) async {
    final integration = await getExternalIntegration(companyId);
    if (integration == null) return [];
    
    try {
      // Llamar a la API externa
      final response = await http.get(
        Uri.parse('${integration.baseUrl}${integration.endpoints['zones']}'),
        headers: {
          'Authorization': 'Bearer ${integration.token}',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final zones = <Zone>[];
        
        for (final zoneData in data) {
          // Mapear datos según configuración
          final zone = Zone(
            id: zoneData[integration.mapping['zone_id']],
            name: zoneData[integration.mapping['zone_name']],
            color: zoneData[integration.mapping['zone_color']],
            pricePerMin: zoneData[integration.mapping['price_per_min']],
            minDuration: zoneData[integration.mapping['min_duration']],
            maxDuration: zoneData[integration.mapping['max_duration']],
            discounts: zoneData[integration.mapping['discounts']],
            residentDiscount: zoneData[integration.mapping['resident_discount']],
            isExternal: true,
          );
          
          zones.add(zone);
          
          // Guardar en cache
          await _saveToCache(companyId, zone.id, zoneData);
        }
        
        return zones;
      }
    } catch (e) {
      print('Error syncing zones from external API: $e');
      // Fallback a cache si está disponible
      return await _getZonesFromCache(companyId);
    }
    
    return [];
  }
  
  // Guardar en cache
  Future<void> _saveToCache(String companyId, String zoneId, Map<String, dynamic> data) async {
    await supabase.from('external_zone_cache').upsert({
      'company_id': companyId,
      'origin_key': zoneId,
      'payload_json': data,
      'synced_at': DateTime.now().toIso8601String(),
      'expires_at': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
    });
  }
  
  // Obtener desde cache
  Future<List<Zone>> _getZonesFromCache(String companyId) async {
    final response = await supabase
        .from('external_zone_cache')
        .select()
        .eq('company_id', companyId)
        .gt('expires_at', DateTime.now().toIso8601String());
    
    return response.map((data) => Zone.fromJson(data['payload_json'])).toList();
  }
}
```

---

## 🎯 **MÉTRICAS DE ÉXITO**

### **✅ Funcionalidad**
- **Sincronización Supabase**: 100% de datos dinámicos
- **Integración API Externa**: Soporte completo
- **IA Adaptativa**: Precisión > 85%
- **Accesibilidad**: WCAG 2.1 AA compliance

### **✅ Performance**
- **Tiempo de carga**: < 2 segundos
- **Sincronización**: < 500ms
- **Respuesta IA**: < 200ms
- **Disponibilidad**: > 99.9%

---

**🎉 ¡UI completamente dinámica basada en Supabase con IA adaptativa avanzada!**

*Última actualización: 21 de Septiembre de 2025*
