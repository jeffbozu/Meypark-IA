# 📺 MEYPARK IA - Sistema LIVE (Monitoreo en Tiempo Real)

## ✅ **SISTEMA COMPLETO IMPLEMENTADO**

### 🔐 **ACCESO DESDE CUALQUIER PC**

#### **Opción 1: Access Token (Recomendado)**
```bash
# En cualquier PC nuevo:
git clone <tu-repo>
cd meypark-ia
supabase login  # Abre navegador para autenticarse
supabase link --project-ref edkwlmauywdxbencaucj
```

#### **Opción 2: Service Role Key (Desarrollo)**
```bash
# Crear .env con tus keys:
NEXT_PUBLIC_SUPABASE_URL=https://edkwlmauywdxbencaucj.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_ACCESS_TOKEN=sbp_1c4a3b418883c444e40d1f0188069b4ef5ce9ddb
```

**¡NO necesitas darme las keys de nuevo!** Solo el access token.

---

## 📺 **SISTEMA LIVE - MONITOREO EN TIEMPO REAL**

### ✅ **FUNCIONALIDADES IMPLEMENTADAS**

#### **1. 📊 Telemetría en Tiempo Real**
- **`telemetry_current`** - Estado actual del dispositivo
  - `battery` - Nivel de batería
  - `rssi` - Señal WiFi
  - `temp_c` - Temperatura
  - `paper_pct` - Papel de impresora
  - `printer_state` - Estado impresora
  - `emv_state` - Estado terminal de pago
  - `coin_level` - Nivel de monedas
- **`telemetry_history`** - Historial de métricas
- **Realtime habilitado** para actualizaciones instantáneas

#### **2. 📸 Captura de Pantalla en Tiempo Real**
- **Edge Function `screenshot`** - Captura y almacena imágenes
- **`device_screenshots`** - Tabla para metadata de capturas
- **Supabase Storage** - Almacenamiento de imágenes
- **URLs públicas** para acceso directo a imágenes

#### **3. 🎮 Comandos Remotos**
- **`device_commands`** - Cola de comandos
  - `SCREENSHOT` - Capturar pantalla
  - `OPEN_PAYMENT_WITH_DURATION` - Abrir pago
  - `SET_A11Y_PROFILE` - Configurar accesibilidad
  - `PRINT_TEST` - Prueba de impresora
  - `REFRESH_TARIFFS` - Actualizar tarifas
  - `RESTART_UI` - Reiniciar interfaz
  - `PING_EMV` - Probar terminal de pago
  - `CHANGE_COMPANY` - Cambiar empresa
  - `PUSH_THEME` - Aplicar tema
- **`device_command_results`** - Resultados de comandos
- **Realtime** para notificaciones instantáneas

#### **4. 📱 Vistas de Monitoreo**
- **`live_sessions_v`** - Sesiones activas en tiempo real
- **`device_status_v`** - Estado de dispositivos
- **`recent_screenshots_v`** - Capturas recientes (24h)

#### **5. 🚨 Sistema de Alertas**
- **`alerts`** - Alertas del sistema
  - `paper_low_20` - Papel bajo 20%
  - `paper_low_10` - Papel bajo 10%
  - `emv_off` - Terminal de pago desconectado
  - `rssi_low` - Señal WiFi baja
  - `temp_high` - Temperatura alta
  - `power_issue` - Problema de energía
- **Realtime** para notificaciones instantáneas

### 🔄 **FLUJO DE MONITOREO LIVE**

#### **1. Captura de Pantalla**
```javascript
// Enviar comando de captura
const { data } = await supabase.functions.invoke('commands', {
  body: {
    device_id: 'device-uuid',
    action: 'SCREENSHOT',
    payload: {}
  }
});

// El dispositivo captura y envía a:
// POST /functions/v1/screenshot
// {
//   device_id: 'device-uuid',
//   image_data: 'base64-image-data',
//   image_format: 'png'
// }
```

#### **2. Monitoreo de Telemetría**
```javascript
// Suscribirse a telemetría en tiempo real
const subscription = supabase
  .channel('telemetry')
  .on('postgres_changes', {
    event: 'UPDATE',
    schema: 'public',
    table: 'telemetry_current'
  }, (payload) => {
    console.log('Telemetría actualizada:', payload.new);
  })
  .subscribe();
```

#### **3. Estado de Dispositivos**
```javascript
// Obtener estado actual de todos los dispositivos
const { data: devices } = await supabase
  .from('device_status_v')
  .select('*')
  .eq('company_id', companyId);
```

### 📊 **DASHBOARD LIVE**

#### **Métricas en Tiempo Real:**
- ✅ **Dispositivos online/offline**
- ✅ **Sesiones activas por dispositivo**
- ✅ **Telemetría actualizada cada 30s**
- ✅ **Capturas de pantalla en tiempo real**
- ✅ **Comandos pendientes y ejecutados**
- ✅ **Alertas abiertas por dispositivo**

#### **Vistas Disponibles:**
- ✅ **`live_sessions_v`** - Sesiones activas
- ✅ **`device_status_v`** - Estado de dispositivos
- ✅ **`recent_screenshots_v`** - Capturas recientes
- ✅ **`telemetry_current`** - Telemetría actual
- ✅ **`device_commands`** - Comandos remotos
- ✅ **`alerts`** - Alertas del sistema

### 🚀 **EDGE FUNCTIONS DESPLEGADAS**

1. **`invoice-get`** - Obtener información de facturas
2. **`commands`** - Enviar comandos a dispositivos
3. **`alerts`** - Crear alertas del sistema
4. **`screenshot`** - Captura de pantalla en tiempo real

### 🔗 **ENLACES IMPORTANTES**

- **Dashboard Supabase**: https://supabase.com/dashboard/project/edkwlmauywdxbencaucj
- **Edge Functions**: https://supabase.com/dashboard/project/edkwlmauywdxbencaucj/functions
- **Storage**: https://supabase.com/dashboard/project/edkwlmauywdxbencaucj/storage
- **API Docs**: https://edkwlmauywdxbencaucj.supabase.co/rest/v1/

### 🎯 **PRÓXIMOS PASOS**

1. **Fase 2**: Panel de administración web con monitoreo live
2. **Fase 3**: Kiosko Flutter con captura de pantalla automática
3. **Fase 4**: Sistema de notificaciones push
4. **Fase 5**: Dashboard móvil para inspectores

---

## 🎉 **¡SISTEMA LIVE COMPLETO!**

**El backend está 100% preparado para monitoreo en tiempo real con:**
- ✅ Captura de pantalla en vivo
- ✅ Telemetría en tiempo real
- ✅ Comandos remotos
- ✅ Alertas instantáneas
- ✅ Vistas de monitoreo
- ✅ Almacenamiento de imágenes
- ✅ Realtime subscriptions

**¡Listo para la Fase 2!** 🚀
