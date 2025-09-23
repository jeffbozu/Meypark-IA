# 🚫 Cómo Deshabilitar Zonas en Supabase

## 📋 **Método 1: Desde el Dashboard de Supabase**

### 1. **Acceder al Dashboard**
- Ve a: https://supabase.com/dashboard
- Selecciona tu proyecto: `meypark-ia` (o el nombre de tu proyecto)

### 2. **Navegar a la Tabla**
- Ve a **Table Editor** en el menú lateral izquierdo
- Busca la tabla: `parking_zones`
- **IMPORTANTE**: Si no ves la tabla, ejecuta primero las migraciones

### 3. **Deshabilitar Zonas**
- Haz clic en la fila de la zona que quieres deshabilitar
- Cambia el campo `is_active` de `true` a `false`
- Haz clic en **Save** para guardar

## 🗄️ **Método 2: Usando SQL Directamente**

### 1. **Acceder al SQL Editor**
- Ve a **SQL Editor** en el dashboard
- Crea una nueva consulta

### 2. **Comandos SQL para Deshabilitar**

```sql
-- Deshabilitar una zona específica por ID
UPDATE parking_zones 
SET is_active = false 
WHERE id = 'uuid-de-la-zona';

-- Deshabilitar una zona por código
UPDATE parking_zones 
SET is_active = false 
WHERE zone_code = 'zone_001';

-- Deshabilitar múltiples zonas
UPDATE parking_zones 
SET is_active = false 
WHERE zone_code IN ('zone_002', 'zone_003', 'zone_004');

-- Deshabilitar todas las zonas de un tipo específico
UPDATE parking_zones 
SET is_active = false 
WHERE name LIKE '%Turística%';
```

### 3. **Verificar Cambios**
```sql
-- Ver todas las zonas activas
SELECT zone_code, name, is_active 
FROM parking_zones 
WHERE is_active = true;

-- Ver todas las zonas deshabilitadas
SELECT zone_code, name, is_active 
FROM parking_zones 
WHERE is_active = false;
```

## 🔄 **Método 3: Usando la Aplicación Flutter**

### 1. **Acceder al Modo Técnico**
- Mantén presionado el logo por 3 segundos
- Introduce la contraseña: `admin123`

### 2. **Gestionar Zonas**
- Ve a la sección de **Gestión de Zonas**
- Selecciona las zonas que quieres deshabilitar
- Cambia el estado a **Inactivo**

## 🚀 **PASO PREVIO: Ejecutar Migraciones**

### **Si no ves las tablas, ejecuta primero:**

1. **Desde el Dashboard de Supabase:**
   - Ve a **SQL Editor**
   - Copia y pega el contenido de: `supabase/migrations/20250122000004_business_data_tables.sql`
   - Ejecuta la consulta
   - Luego ejecuta: `supabase/migrations/20250122000005_seed_business_data.sql`

2. **Desde la línea de comandos:**
   ```bash
   cd /home/jeffrey/development/MEYPAR_IA/meypark-ia
   supabase db push
   ```

### **Verificar que las tablas existen:**
```sql
-- Ver todas las tablas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE '%parking%';

-- Ver estructura de la tabla parking_zones
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'parking_zones' 
AND table_schema = 'public';
```

### **Esquema de la tabla `parking_zones`:**
```sql
CREATE TABLE parking_zones (
    id UUID PRIMARY KEY,
    company_id UUID NOT NULL,
    zone_code VARCHAR(50) NOT NULL,    -- 'zone_001', 'zone_002', etc.
    name VARCHAR(100) NOT NULL,        -- 'Zona Centro', 'Zona Comercial', etc.
    description TEXT,
    color VARCHAR(7) DEFAULT '#FF6B6B', -- Color hex
    icon VARCHAR(50),                  -- Nombre del icono
    schedule_json JSONB,               -- Horarios en JSON
    price_per_hour_cents INTEGER,      -- Precio por hora en centavos
    price_per_minute_cents INTEGER,    -- Precio por minuto en centavos
    max_duration_hours INTEGER,        -- Duración máxima en horas
    min_duration_minutes INTEGER,      -- Duración mínima en minutos
    is_active BOOLEAN DEFAULT true,    -- ⭐ ESTE ES EL CAMPO CLAVE
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
);
```

## 📊 **Zonas Actuales en el Sistema**

| Código | Nombre | Estado | Descripción |
|--------|--------|--------|-------------|
| zone_001 | Zona Centro | ✅ Activa | Centro de la ciudad |
| zone_002 | Zona Comercial | ✅ Activa | Áreas comerciales |
| zone_003 | Zona Residencial | ✅ Activa | Para residentes |
| zone_004 | Zona Turística | ✅ Activa | Para turistas |
| zone_005 | Zona Hospital | ✅ Activa | Hospitales y clínicas |
| zone_006 | Zona Universidad | ✅ Activa | Campus universitarios |

## ⚠️ **Consideraciones Importantes**

### **Antes de Deshabilitar:**
1. **Verificar transacciones activas** - No deshabilitar zonas con pagos en curso
2. **Notificar a usuarios** - Avisar sobre cambios en disponibilidad
3. **Backup de datos** - Hacer respaldo antes de cambios masivos

### **Después de Deshabilitar:**
1. **Verificar en la app** - Comprobar que las zonas no aparecen
2. **Actualizar documentación** - Registrar cambios realizados
3. **Monitorear sistema** - Verificar que no hay errores

## 🔧 **Reactivar Zonas**

```sql
-- Reactivar una zona específica
UPDATE parking_zones 
SET is_active = true 
WHERE zone_code = 'zone_001';

-- Reactivar todas las zonas
UPDATE parking_zones 
SET is_active = true;
```

## 📱 **Verificación en la App**

### **Pantalla de Zonas:**
- Las zonas deshabilitadas (`is_active = false`) **NO aparecerán** en la lista
- Solo se mostrarán las zonas activas
- El filtro se aplica automáticamente en el provider

### **Código del Provider:**
```dart
// En supabase_providers.dart
.eq('is_active', true)  // Solo zonas activas
```

## 🚨 **Solución de Problemas**

### **Si una zona sigue apareciendo:**
1. Verificar que `is_active = false` en la base de datos
2. Reiniciar la aplicación Flutter
3. Verificar la conexión a Supabase

### **Si hay errores de conexión:**
1. Verificar las credenciales de Supabase
2. Comprobar la URL y clave en `env.dart`
3. Revisar los logs de la aplicación

## 📞 **Soporte**

Si necesitas ayuda adicional:
- **Documentación**: Ver archivos en `/docs/`
- **Logs**: Revisar `flutter logs`
- **Base de datos**: Verificar en Supabase Dashboard
